import 'package:flutter/material.dart';
import '../../../../core/constants/color_constants.dart';

class ScanningFrame extends StatelessWidget {
  final bool isFaceDetected;
  final bool isSuccess;

  const ScanningFrame({
    super.key,
    required this.isFaceDetected,
    this.isSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 300,
      height: 380,
      decoration: BoxDecoration(
        border: Border.all(
          color: isFaceDetected
              ? (isSuccess ? Colors.greenAccent : AppColors.accentYellow)
              : Colors.white12,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          _buildTechCorner(top: 0, left: 0, borderTop: true, borderLeft: true),
          _buildTechCorner(top: 0, right: 0, borderTop: true, borderRight: true),
          _buildTechCorner(bottom: 0, left: 0, borderBottom: true, borderLeft: true),
          _buildTechCorner(bottom: 0, right: 0, borderBottom: true, borderRight: true),
        ],
      ),
    );
  }

  Widget _buildTechCorner({
    double? top,
    double? bottom,
    double? left,
    double? right,
    bool borderTop = false,
    bool borderBottom = false,
    bool borderLeft = false,
    bool borderRight = false,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border(
            top: borderTop ? const BorderSide(color: AppColors.accentYellow, width: 3) : BorderSide.none,
            bottom: borderBottom ? const BorderSide(color: AppColors.accentYellow, width: 3) : BorderSide.none,
            left: borderLeft ? const BorderSide(color: AppColors.accentYellow, width: 3) : BorderSide.none,
            right: borderRight ? const BorderSide(color: AppColors.accentYellow, width: 3) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
