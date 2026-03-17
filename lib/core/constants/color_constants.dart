import 'package:flutter/material.dart';

class AppColors {
  // Primary Navy - Deep and Professional
  static const Color primaryNavy = Color(0xFF1A2A42);
  static const Color deepNavy = Color(0xFF101929);
  
  // Accent Yellow - Gold/Amber for Premium feel
  static const Color accentYellow = Color(0xFFFBCF84);
  static const Color premiumGold = Color(0xFFDDB26A);
  
  // Backgrounds
  static const Color lightBlueBackground = Color(0xFFF4F9FF);
  static const Color white = Colors.white;
  static const Color glassWhite = Color(0x1AFFFFFF);
  
  // Text
  static const Color textPrimary = Color(0xFF1A2A42);
  static const Color textSecondary = Colors.white70;
  
  // Gradients
  static const LinearGradient navyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryNavy, deepNavy],
  );
}
