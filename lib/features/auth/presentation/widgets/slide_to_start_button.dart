import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/color_constants.dart';

class SlideToStartButton extends StatefulWidget {
  final VoidCallback onSlideComplete;
  final String text;

  const SlideToStartButton({
    super.key,
    required this.onSlideComplete,
    this.text = 'Slide to Get Started',
  });

  @override
  State<SlideToStartButton> createState() => _SlideToStartButtonState();
}

class _SlideToStartButtonState extends State<SlideToStartButton> with SingleTickerProviderStateMixin {
  double _dragValue = 0.0;
  bool _isCompleted = false;
  AnimationController? _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController!, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonWidth = constraints.maxWidth;
        const buttonHeight = 64.0;
        const thumbSize = 54.0;
        final maxDragDistance = buttonWidth - thumbSize - 10;

        return ClipRRect(
          borderRadius: BorderRadius.circular(buttonHeight / 2),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: buttonWidth,
              height: buttonHeight,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(buttonHeight / 2),
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Shimmer-like track effect can go here, but keeping it clean
                  Center(
                    child: Opacity(
                      opacity: (1.0 - (_dragValue / (maxDragDistance * 0.5))).clamp(0.0, 1.0),
                      child: Text(
                        widget.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                  
                  // Slidable thumb
                  Positioned(
                    left: 5 + _dragValue,
                    top: 5,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        if (_isCompleted) return;
                        setState(() {
                          _dragValue += details.delta.dx;
                          if (_dragValue < 0) _dragValue = 0;
                          if (_dragValue > maxDragDistance) _dragValue = maxDragDistance;
                        });
                      },
                      onHorizontalDragEnd: (details) {
                        if (_isCompleted) return;
                        if (_dragValue >= maxDragDistance * 0.8) {
                          setState(() {
                            _dragValue = maxDragDistance;
                            _isCompleted = true;
                          });
                          widget.onSlideComplete();
                        } else {
                          setState(() {
                            _dragValue = 0;
                          });
                        }
                      },
                      child: _pulseController != null 
                        ? ScaleTransition(
                            scale: _pulseAnimation,
                            child: _buildThumb(thumbSize),
                          )
                        : _buildThumb(thumbSize),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildThumb(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accentYellow, AppColors.premiumGold],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.accentYellow.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: AppColors.primaryNavy,
        size: 24,
      ),
    );
  }
}
