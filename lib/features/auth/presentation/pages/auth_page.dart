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
import 'verify_otp_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool _isLogin = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepNavy,
      resizeToAvoidBottomInset: false, // Prevents elements from moving when keyboard opens
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryNavy.withValues(alpha: 0.3),
              ),
            ),
          ),
          Positioned(
            bottom: -150, // Moved lower to keep it static at the bottom
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.premiumGold.withValues(alpha: 0.08),
              ),
            ),
          ),

          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login Successful!')),
                );
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              } else if (state is OtpRequestedSuccess) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VerifyOtpPage(
                      phoneNumber: state.phoneNumber,
                      otp: state.otp,
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              return SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Animated App Logo/Icon
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withValues(alpha: 0.1),
                                      Colors.white.withValues(alpha: 0.02),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const Icon(
                                      Icons.center_focus_weak_rounded, // Better scanner theme
                                      size: 72,
                                      color: AppColors.accentYellow,
                                    ),
                                    Icon(
                                      Icons.person_rounded,
                                      size: 28,
                                      color: Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                _isLogin ? 'FOUND YOU' : 'JOIN US',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.syne( // Trendy, stylish display font
                                  fontSize: 42,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -1.5,
                                  color: Colors.white,
                                  height: 0.9,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _isLogin
                              ? 'Next-Gen AI Attendance Tracker'
                              : 'Register to start tracking attendance',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.4),
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 48),
                        GlassCard(
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _phoneController,
                                hintText: 'Phone Number',
                                icon: Icons.phone_android_rounded,
                                keyboardType: TextInputType.phone,
                              ),
                              if (_isLogin) ...[
                                CustomTextField(
                                  controller: _passwordController,
                                  hintText: 'Password',
                                  icon: Icons.lock_outline_rounded,
                                  isObscure: true,
                                ),
                              ],
                              const SizedBox(height: 12),
                              PrimaryButton(
                                text: _isLogin ? 'CONTINUE' : 'SEND OTP',
                                isLoading: state is AuthLoading,
                                onPressed: () {
                                  final phone = _phoneController.text.trim();
                                  if (phone.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Phone number is required')),
                                    );
                                    return;
                                  }
                                  if (_isLogin) {
                                    final pass = _passwordController.text.trim();
                                    if (pass.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Password is required')),
                                      );
                                      return;
                                    }
                                    context.read<AuthBloc>().add(
                                          LoginEvent(
                                              phoneNumber: phone, password: pass),
                                        );
                                  } else {
                                    context.read<AuthBloc>().add(RequestOtpEvent(phone));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                              _passwordController.clear();
                              _animationController.reset();
                              _animationController.forward();
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                              children: [
                                TextSpan(
                                  text: _isLogin
                                      ? "New here? "
                                      : "Have an account? ",
                                ),
                                TextSpan(
                                  text: _isLogin ? "Join Now" : "Sign In",
                                  style: const TextStyle(
                                    color: AppColors.accentYellow,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
