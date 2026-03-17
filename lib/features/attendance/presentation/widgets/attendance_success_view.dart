import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/color_constants.dart';
import '../../data/models/attendance_model.dart';

class AttendanceSuccessView extends StatelessWidget {
  final AttendanceModel record;
  final VoidCallback onReset;

  const AttendanceSuccessView({
    super.key,
    required this.record,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.deepNavy,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.verified_user_rounded, color: Colors.greenAccent, size: 80),
          const SizedBox(height: 20),
          Text(
            'LOGGED IN',
            style: GoogleFonts.syne(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                Text(
                  record.workerName ?? 'Success',
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentYellow,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Time: ${record.time}',
                  style: GoogleFonts.inter(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          ElevatedButton(
            onPressed: onReset,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentYellow,
              foregroundColor: AppColors.deepNavy,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('READY FOR NEXT SCAN', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
