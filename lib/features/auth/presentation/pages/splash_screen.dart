import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/color_constants.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import 'auth_page.dart';
import 'complete_profile_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../widgets/slide_to_start_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSlideComplete() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const AuthStatusWrapper(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animated Background (Subtle Ken Burns effect)
          ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset(
              'assets/images/splashscreen.png',
              fit: BoxFit.contain,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.navyGradient,
                  ),
                  child: const Center(
                    child: Text(
                      'Found You AI',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Enhanced Overlay - Professional Multi-stop Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.8),
                  Colors.black,
                ],
                stops: const [0.0, 0.2, 0.5, 0.7, 0.9, 1.0],
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 48.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SlideToStartButton(
                    onSlideComplete: _onSlideComplete,
                    text: 'Slide to Get Started',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthStatusWrapper extends StatelessWidget {
  const AuthStatusWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          if (state.user?.name == 'System Admin') {
            return const CompleteProfilePage();
          }
          return const HomePage();
        } else {
          return const AuthPage();
        }
      },
    );
  }
}
