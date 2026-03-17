import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../constants/color_constants.dart';

class CameraCapturePage extends StatefulWidget {
  final CameraDescription camera;
  const CameraCapturePage({super.key, required this.camera});

  @override
  State<CameraCapturePage> createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends State<CameraCapturePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Center(child: CameraPreview(_controller)),
                // Centered circular guide
                Center(
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.accentYellow, width: 2),
                      borderRadius: BorderRadius.circular(140),
                    ),
                  ),
                ),
                // Camera button
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FloatingActionButton(
                      backgroundColor: AppColors.accentYellow,
                      onPressed: () async {
                        try {
                          await _initializeControllerFuture;
                          final image = await _controller.takePicture();
                          if (!mounted) return;
                          Navigator.pop(context, image);
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                      child: const Icon(Icons.camera_alt, color: AppColors.deepNavy),
                    ),
                  ),
                ),
                // Close button
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator(color: AppColors.accentYellow));
          }
        },
      ),
    );
  }
}
