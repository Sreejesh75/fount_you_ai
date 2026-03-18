import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _nameController = TextEditingController();
  String? _selectedRole = 'Supervisor';
  
  final List<String> _roles = ['Supervisor', 'Engineer', 'Owner', 'Admin'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepNavy,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background Circles
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              physics: const BouncingScrollPhysics(),
              child: BlocConsumer<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is ProfileError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                    );
                  }
                  if (state is ProfileUpdateSuccess) {
                    // Update AuthBloc as well to reflect changes immediately
                    context.read<AuthBloc>().add(AuthUserUpdatedEvent(state.user));
                  }
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 60),
                      Text(
                        'COMPLETE YOUR PROFILE',
                        style: GoogleFonts.syne(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tell us about yourself to get started',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(height: 48),
                      
                      GlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildInputField('FULL NAME', _nameController, Icons.person_outline_rounded),
                            const SizedBox(height: 32),
                            _buildRoleDropdown('YOUR DESIGNATION', Icons.badge_outlined),
                            const SizedBox(height: 48),
                            
                            PrimaryButton(
                              text: 'FINALIZE SETUP',
                              onPressed: () {
                                if (_nameController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please enter your name')),
                                  );
                                  return;
                                }
                                context.read<ProfileBloc>().add(UpdateProfileEvent(
                                  name: _nameController.text.trim(),
                                  role: _selectedRole,
                                ));
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      if (state is ProfileLoading)
                        const Center(
                          child: CircularProgressIndicator(color: AppColors.accentYellow),
                        ),
                      
                      const SizedBox(height: 40),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.accentYellow),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.white38,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: GoogleFonts.outfit(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
            isDense: true,
            hintText: 'username',
            hintStyle: TextStyle(color: Colors.white12, fontSize: 16),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentYellow)),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleDropdown(String label, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.accentYellow),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.white38,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedRole,
          dropdownColor: AppColors.primaryNavy,
          style: GoogleFonts.outfit(color: Colors.white, fontSize: 18),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentYellow)),
          ),
          items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
          onChanged: (val) => setState(() => _selectedRole = val),
        ),
      ],
    );
  }
}
