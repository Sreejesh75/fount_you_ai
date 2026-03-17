import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../features/workers/data/models/worker_model.dart';
import '../../data/models/attendance_model.dart';

class AttendanceSuccessView extends StatefulWidget {
  final AttendanceModel record;
  final WorkerModel worker;
  final VoidCallback onReset;

  const AttendanceSuccessView({
    super.key,
    required this.record,
    required this.worker,
    required this.onReset,
  });

  @override
  State<AttendanceSuccessView> createState() => _AttendanceSuccessViewState();
}

class _AttendanceSuccessViewState extends State<AttendanceSuccessView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: GlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'ATTENDANCE MARKED',
                            style: GoogleFonts.inter(
                              color: Colors.greenAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Worker Photo
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.accentYellow, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentYellow.withValues(alpha: 0.2),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(widget.worker.photoUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Worker Info
                    Text(
                      widget.worker.name,
                      style: GoogleFonts.syne(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.worker.jobRole,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.accentYellow,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Details Table
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildDetailItem('Time', widget.record.time, Icons.access_time_rounded),
                          Container(width: 1, height: 30, color: Colors.white10),
                          _buildDetailItem('Status', 'Present', Icons.person_pin_rounded),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Done Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: widget.onReset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentYellow,
                          foregroundColor: AppColors.deepNavy,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: Text(
                          'DONE',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white38, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.inter(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
