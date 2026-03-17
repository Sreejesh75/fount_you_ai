import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/color_constants.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class VerifyOtpPage extends StatefulWidget {
  final String phoneNumber;
  final String? otp;

  const VerifyOtpPage({super.key, required this.phoneNumber, this.otp});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.otp != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'OTP sent successfully! Your code is: ${widget.otp}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      appBar: AppBar(
        title: Text('Verify OTP', style: GoogleFonts.inter(color: AppColors.accentYellow)),
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.accentYellow),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.popUntil(context, (route) => route.isFirst);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password Set Successfully! Logged In.')),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_open,
                    size: 80,
                    color: AppColors.accentYellow,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Verify Phone Number',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'We sent an OTP to ${widget.phoneNumber}\nPlease enter it below to set your password.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.lightBlueBackground,
                    ),
                  ),
                  const SizedBox(height: 48),
                  GlassCard(
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _otpController,
                          hintText: 'Enter OTP',
                          icon: Icons.message_rounded,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _passwordController,
                          hintText: 'Set New Password',
                          icon: Icons.lock,
                          isObscure: true,
                        ),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          text: 'VERIFY & SET PASSWORD',
                          isLoading: state is AuthLoading,
                          onPressed: () {
                            final otp = _otpController.text.trim();
                            final pass = _passwordController.text.trim();

                            if (otp.isEmpty || pass.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('All fields are required!')),
                              );
                              return;
                            }

                            context.read<AuthBloc>().add(
                                  VerifyOtpAndSetPasswordEvent(
                                    phoneNumber: widget.phoneNumber,
                                    otp: otp,
                                    password: pass,
                                  ),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
