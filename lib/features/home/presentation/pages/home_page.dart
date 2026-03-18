import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:found_you_ai/core/constants/color_constants.dart';
import 'package:found_you_ai/core/widgets/primary_button.dart';
import 'package:found_you_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:found_you_ai/features/auth/presentation/bloc/auth_event.dart';
import 'package:found_you_ai/features/auth/presentation/bloc/auth_state.dart';
import 'package:found_you_ai/features/attendance/presentation/pages/attendance_page.dart';
import 'package:found_you_ai/features/attendance/presentation/pages/attendance_report_page.dart';
import 'package:found_you_ai/features/workers/presentation/pages/register_worker_page.dart';
import 'package:found_you_ai/features/workers/presentation/pages/worker_list_page.dart';

import 'package:found_you_ai/features/auth/presentation/pages/profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepNavy,
      body: Stack(
        children: [
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
          
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.person_pin_rounded, color: AppColors.accentYellow, size: 28),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ProfilePage()),
                          );
                        },
                      ),
                      Text(
                        'FOUND YOU',
                        style: GoogleFonts.syne(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout_rounded, color: Colors.white38),
                        onPressed: () {
                          context.read<AuthBloc>().add(LogoutEvent());
                        },
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.03),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: const Icon(
                      Icons.face_unlock_rounded,
                      size: 120,
                      color: AppColors.accentYellow,
                    ),
                  ),
                ),
                
                const SizedBox(height: 48),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      String name = 'Admin';
                      String role = 'Supervisor';
                      
                      if (state is AuthAuthenticated) {
                        name = state.user?.name ?? 'Admin';
                        role = state.user?.role ?? 'Supervisor';
                      }
                      
                      return Column(
                        children: [
                          Text(
                            'Welcome, $name',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Authorized $role',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentYellow.withValues(alpha: 0.8),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ready to mark attendance for today?',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                
                const Spacer(),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    children: [
                      PrimaryButton(
                        text: 'START SCANNING',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AttendancePage()),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AttendanceReportPage()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 58),
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text(
                          'VIEW ATTENDANCE LOG',
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RegisterWorkerPage()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 58),
                          side: const BorderSide(color: AppColors.accentYellow),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text(
                          'REGISTER NEW WORKER',
                          style: GoogleFonts.inter(
                            color: AppColors.accentYellow,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const WorkerListPage()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 58),
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text(
                          'MANAGE WORKERS',
                          style: GoogleFonts.inter(
                            color: Colors.white60,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
