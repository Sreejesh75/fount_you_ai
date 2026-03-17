import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'dart:io';

import '../../../../core/constants/color_constants.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/camera_capture_page.dart';
import '../bloc/worker_bloc.dart';
import '../bloc/worker_event.dart';
import '../bloc/worker_state.dart';
import '../widgets/worker_photo_picker.dart';

class RegisterWorkerPage extends StatefulWidget {
  const RegisterWorkerPage({super.key});

  @override
  State<RegisterWorkerPage> createState() => _RegisterWorkerPageState();
}

class _RegisterWorkerPageState extends State<RegisterWorkerPage> {
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _placeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _wageController = TextEditingController();
  
  File? _capturedPhoto;

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _placeController.dispose();
    _phoneController.dispose();
    _wageController.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    if (!mounted) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CameraCapturePage(camera: frontCamera),
      ),
    );

    if (!mounted) return;

    if (result != null && result is XFile) {
      setState(() {
        _capturedPhoto = File(result.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepNavy,
      appBar: AppBar(
        title: Text('New Worker', style: GoogleFonts.syne(fontWeight: FontWeight.w700, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<WorkerBloc, WorkerState>(
        listener: (context, state) {
          if (state is WorkerRegisteredSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Worker Registered Successfully!')),
            );
            Navigator.pop(context);
          } else if (state is WorkerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WorkerPhotoPicker(
                capturedPhoto: _capturedPhoto,
                onTap: _capturePhoto,
              ),
              const SizedBox(height: 32),
              
              GlassCard(
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      hintText: 'Full Name',
                      icon: Icons.person_outline_rounded,
                    ),
                    CustomTextField(
                      controller: _roleController,
                      hintText: 'Job Role (e.g. Engineer)',
                      icon: Icons.work_outline_rounded,
                    ),
                    CustomTextField(
                      controller: _placeController,
                      hintText: 'Work Location',
                      icon: Icons.location_on_outlined,
                    ),
                    CustomTextField(
                      controller: _phoneController,
                      hintText: 'Contact Number',
                      icon: Icons.phone_android_rounded,
                      keyboardType: TextInputType.phone,
                    ),
                    CustomTextField(
                      controller: _wageController,
                      hintText: 'Daily Wage',
                      icon: Icons.payments_outlined,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<WorkerBloc, WorkerState>(
                      builder: (context, state) {
                        return PrimaryButton(
                          text: 'REGISTER WORKER',
                          isLoading: state is WorkerLoading,
                          onPressed: () {
                            if (_capturedPhoto == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please capture a photo first')),
                              );
                              return;
                            }
                            
                            final name = _nameController.text.trim();
                            final role = _roleController.text.trim();
                            final place = _placeController.text.trim();
                            final phone = _phoneController.text.trim();
                            final wage = double.tryParse(_wageController.text.trim()) ?? 0;

                            if (name.isEmpty || role.isEmpty || place.isEmpty || phone.isEmpty || wage == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('All fields are required')),
                              );
                              return;
                            }

                            context.read<WorkerBloc>().add(
                                  RegisterWorkerEvent(
                                    name: name,
                                    jobRole: role,
                                    place: place,
                                    contactNumber: phone,
                                    dailyWage: wage,
                                    photo: _capturedPhoto!,
                                  ),
                                );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
