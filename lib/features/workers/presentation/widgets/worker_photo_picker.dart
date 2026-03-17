import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/constants/color_constants.dart';

class WorkerPhotoPicker extends StatelessWidget {
  final File? capturedPhoto;
  final VoidCallback onTap;

  const WorkerPhotoPicker({
    super.key,
    required this.capturedPhoto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Stack(
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(
                  color: AppColors.accentYellow.withValues(alpha: 0.3),
                  width: 2,
                ),
                image: capturedPhoto != null
                    ? DecorationImage(
                        image: FileImage(capturedPhoto!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: capturedPhoto == null
                  ? const Icon(
                      Icons.add_a_photo_rounded,
                      size: 40,
                      color: AppColors.accentYellow,
                    )
                  : null,
            ),
            if (capturedPhoto != null)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.accentYellow,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit_rounded, size: 20, color: AppColors.deepNavy),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
