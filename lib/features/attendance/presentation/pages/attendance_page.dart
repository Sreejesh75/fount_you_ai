import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../features/workers/presentation/bloc/worker_bloc.dart';
import '../../../../features/workers/presentation/bloc/worker_event.dart';
import '../../../../features/workers/presentation/bloc/worker_state.dart';
import '../../data/models/attendance_model.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';
import '../widgets/attendance_status_pill.dart';
import '../widgets/attendance_success_view.dart';
import '../widgets/scanning_frame.dart';
import 'dart:ui';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  CameraController? _cameraController;
  late FaceDetector _faceDetector;
  bool _isBusy = false;
  bool _canProcess = true;
  String _status = "Align face to camera";
  bool _isFaceDetected = false;
  bool _isRecognizing = false;
  AttendanceModel? _markedRecord;

  CameraDescription? _cameraDescription;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: false,
        enableLandmarks: false,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
    context.read<WorkerBloc>().add(FetchAllWorkersEvent());
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraDescription = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      _cameraDescription!,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.yuv420 : ImageFormatGroup.bgra8888,
    );

    try {
      await _cameraController?.initialize();
      if (!mounted) return;

      _cameraController?.startImageStream(_processFaceDetection);
      setState(() {});
    } catch (e) {
      debugPrint("Camera initialize error: $e");
    }
  }

  Future<void> _processFaceDetection(CameraImage image) async {
    if (_isBusy || !_canProcess || _isRecognizing) return;
    _isBusy = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) {
        _isBusy = false;
        return;
      }

      final faces = await _faceDetector.processImage(inputImage);

      if (mounted) {
        setState(() {
          _isFaceDetected = faces.isNotEmpty;
          _status = _isFaceDetected ? "Scanning Face..." : "Scan your face";
        });

        if (_isFaceDetected && !_isRecognizing) {
          _onFaceMatched();
        }
      }
    } catch (e) {
      debugPrint("Face detection error: $e");
    } finally {
      _isBusy = false;
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_cameraDescription == null) return null;

    final rotation = InputImageRotationValue.fromRawValue(_cameraDescription!.sensorOrientation) ?? InputImageRotation.rotation0deg;
    
    // Most robust format mapping for Android ML Kit
    final format = Platform.isAndroid ? InputImageFormat.nv21 : InputImageFormat.bgra8888;

    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  Future<void> _onFaceMatched() async {
    setState(() {
      _isRecognizing = true;
      _status = "Searching Database...";
    });

    // Simulated network/AI delay to make it feel realistic
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    final workerState = context.read<WorkerBloc>().state;
    if (workerState is WorkersLoadedSuccess && workerState.workers.isNotEmpty) {
      // For Demo: We match the face to the first registered worker
      final matchedWorker = workerState.workers.first;
      context.read<AttendanceBloc>().add(MarkAttendanceEvent(matchedWorker.id));
    } else {
      setState(() {
        _isRecognizing = false;
        _status = "Access Denied: Unknown Face";
      });
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) setState(() { _status = "Scan your face"; });
    }
  }

  @override
  void dispose() {
    _canProcess = false;
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  void _resetScanner() {
    setState(() {
      _markedRecord = null;
      _isRecognizing = false;
      _isFaceDetected = false;
      _status = "Scan your face";
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AttendanceBloc, AttendanceState>(
      listener: (context, state) {
        if (state is AttendanceSuccess) {
          setState(() {
            _markedRecord = state.record;
            _status = "Authenticated!";
          });
        } else if (state is AttendanceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
          );
          _resetScanner();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.deepNavy,
        body: Stack(
          alignment: Alignment.center,
          children: [
            // Full Screen Camera
            if (_cameraController != null && _cameraController!.value.isInitialized)
              Transform.scale(
                scale: 1.1,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1 / _cameraController!.value.aspectRatio,
                    child: CameraPreview(_cameraController!),
                  ),
                ),
              )
            else
              const Center(child: CircularProgressIndicator(color: AppColors.accentYellow)),

            // Scanning Frame
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ScanningFrame(
                    isFaceDetected: _isFaceDetected,
                    isSuccess: _markedRecord != null,
                  ),
                  if (_isRecognizing && _markedRecord == null)
                    const CircularProgressIndicator(color: AppColors.accentYellow, strokeWidth: 2),
                ],
              ),
            ),

            // Floating Status Pill
            Positioned(
              bottom: 80,
              child: AttendanceStatusPill(status: _status),
            ),

            // Success View Overlay
            if (_markedRecord != null)
              AttendanceSuccessView(
                record: _markedRecord!,
                onReset: _resetScanner,
              ),

            // Top Control
            Positioned(
              top: 50,
              left: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
