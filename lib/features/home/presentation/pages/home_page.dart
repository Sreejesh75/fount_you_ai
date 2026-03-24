import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:found_you_ai/core/constants/color_constants.dart';
import 'package:found_you_ai/core/widgets/primary_button.dart';
import 'package:found_you_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:found_you_ai/features/auth/presentation/bloc/auth_event.dart';
import 'package:found_you_ai/features/auth/presentation/bloc/auth_state.dart';
import 'package:found_you_ai/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:found_you_ai/features/attendance/presentation/bloc/attendance_event.dart';
import 'package:found_you_ai/features/attendance/presentation/bloc/attendance_state.dart';
import 'package:found_you_ai/features/attendance/presentation/pages/attendance_page.dart';
import 'package:found_you_ai/features/attendance/presentation/pages/attendance_report_page.dart';
import 'package:found_you_ai/features/workers/presentation/pages/register_worker_page.dart';
import 'package:found_you_ai/features/workers/presentation/pages/worker_list_page.dart';
import 'package:found_you_ai/features/attendance/presentation/widgets/attendance_chart.dart';
import 'package:found_you_ai/features/attendance/presentation/widgets/dashboard_card.dart';
import 'package:found_you_ai/features/attendance/presentation/widgets/recent_activity_item.dart';

import 'package:found_you_ai/features/attendance/data/models/dashboard_summary_model.dart';

import 'package:found_you_ai/features/auth/presentation/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  void _fetchDashboardData() {
    context.read<AttendanceBloc>().add(const FetchDashboardSummaryEvent());
  }

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
              children: [
                _buildHeader(context),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _fetchDashboardData();
                      // Small delay to allow BLoC to start loading
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    color: AppColors.accentYellow,
                    backgroundColor: AppColors.primaryNavy,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: BlocBuilder<AttendanceBloc, AttendanceState>(
                        builder: (context, state) {
                          if (state is AttendanceLoading) {
                            return const Center(child: Padding(
                              padding: EdgeInsets.only(top: 100),
                              child: CircularProgressIndicator(color: AppColors.accentYellow),
                            ));
                          }
                          
                          if (state is AttendanceSummaryLoaded) {
                            final summary = state.summary;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildWelcomeMessage(),
                                const SizedBox(height: 32),
                                _buildSummaryCards(summary),
                                const SizedBox(height: 32),
                                _buildChartSection(summary),
                                const SizedBox(height: 32),
                                _buildActivitySection(summary),
                                const SizedBox(height: 32),
                                _buildActionButtons(context),
                                const SizedBox(height: 40),
                              ],
                            );
                          }
                          
                          if (state is AttendanceError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 100),
                                child: Column(
                                  children: [
                                    Text(state.message, style: GoogleFonts.inter(color: Colors.redAccent), textAlign: TextAlign.center),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: _fetchDashboardData,
                                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentYellow),
                                      child: const Text('Retry', style: TextStyle(color: AppColors.deepNavy)),
                                    ),
                                    const SizedBox(height: 40),
                                    _buildActionButtons(context),
                                  ],
                                ),
                              ),
                            );
                          }

                          return _buildInitialUI(context);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.person_pin_rounded, color: AppColors.accentYellow, size: 28),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
            },
          ),
          Text(
            'FOUND YOU',
            style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white38),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String name = 'Admin';
        if (state is AuthAuthenticated) name = state.user?.name ?? 'Admin';
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $name 👋',
              style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('EEEE, MMMM dd').format(DateTime.now()),
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white38),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCards(DashboardSummaryModel summary) {
    final today = summary.today;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        DashboardCard(
          title: 'Daily Attendance',
          value: '${today.presentCount}/${today.totalWorkers}',
          icon: Icons.check_circle_rounded,
          color: Colors.greenAccent,
          subtitle: today.totalWorkers > 0 
            ? '${((today.presentCount / today.totalWorkers) * 100).toInt()}%' 
            : '0%',
        ),
        DashboardCard(
          title: 'Total Wage',
          value: '₹${NumberFormat('#,##,###').format(today.totalEstimatedWage)}',
          icon: Icons.currency_rupee_rounded,
          color: AppColors.accentYellow,
          subtitle: 'Today\'s Total',
        ),
      ],
    );
  }

  Widget _buildChartSection(DashboardSummaryModel summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attendance Trends',
          style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        const SizedBox(height: 16),
        AttendanceChart(trends: summary.trends),
      ],
    );
  }

  Widget _buildActivitySection(DashboardSummaryModel summary) {
    if (summary.recentActivity.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Scans',
              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceReportPage())),
              child: Text('View All', style: GoogleFonts.inter(color: AppColors.accentYellow, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...summary.recentActivity.map((activity) => RecentActivityItem(activity: activity)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          text: 'START SCANNING',
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendancePage())),
        ),
        const SizedBox(height: 16),
        _buildSecondaryButton(
          context,
          'MANAGE WORKERS',
          const WorkerListPage(),
          Icons.people_outline_rounded,
        ),
        const SizedBox(height: 16),
        _buildSecondaryButton(
          context,
          'REGISTER NEW WORKER',
          const RegisterWorkerPage(),
          Icons.person_add_outlined,
          borderColor: AppColors.accentYellow.withValues(alpha: 0.3),
        ),
      ],
    );
  }

  Widget _buildSecondaryButton(BuildContext context, String text, Widget page, IconData icon, {Color? borderColor}) {
    return OutlinedButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 58),
        side: BorderSide(color: borderColor ?? Colors.white.withValues(alpha: 0.1)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white60, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.inter(color: Colors.white70, fontWeight: FontWeight.w700, letterSpacing: 1.2),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialUI(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        const Icon(Icons.dashboard_rounded, size: 80, color: Colors.white10),
        const SizedBox(height: 20),
        Text('Loading Dashboard...', style: GoogleFonts.inter(color: Colors.white24)),
        const SizedBox(height: 40),
        _buildActionButtons(context),
      ],
    );
  }
}
