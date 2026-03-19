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
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animated Background (Ken Burns effect)
          ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset(
              'assets/images/splashscreen.png',
              fit: BoxFit.cover,
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
          
          // Enhanced Overlay - Professional Dark Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.9),
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 64.0),
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
