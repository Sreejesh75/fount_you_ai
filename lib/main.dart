import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/auth/presentation/pages/auth_page.dart';
import 'features/auth/presentation/pages/complete_profile_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/profile_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/workers/presentation/bloc/worker_bloc.dart';
import 'features/attendance/presentation/bloc/attendance_bloc.dart';
import 'core/constants/color_constants.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => di.sl<ProfileBloc>(),
        ),
        BlocProvider<WorkerBloc>(
          create: (context) => di.sl<WorkerBloc>(),
        ),
        BlocProvider<AttendanceBloc>(
          create: (context) => di.sl<AttendanceBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Found You AI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryNavy),
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
          scaffoldBackgroundColor: AppColors.primaryNavy,
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              // If name is the initial default, they are a new user
              if (state.user?.name == 'System Admin') {
                return const CompleteProfilePage();
              }
              return const HomePage();
            } else {
              return const AuthPage();
            }
          },
        ),
      ),
    );
  }
}
