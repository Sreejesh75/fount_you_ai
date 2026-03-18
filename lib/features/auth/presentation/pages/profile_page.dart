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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  String? _selectedRole;
  bool _isEditing = false;
  
  final List<String> _roles = ['Supervisor', 'Engineer', 'Owner', 'Admin'];

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetProfileEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _setupControllers(ProfileLoaded state) {
    if (!_isEditing) {
      _nameController.text = state.user.name ?? 'Admin';
      
      // Normalize role to match dropdown items (e.g., 'admin' -> 'Admin')
      final backendRole = state.user.role;
      if (backendRole != null) {
        // Try to find a case-insensitive match in our _roles list
        try {
          _selectedRole = _roles.firstWhere(
            (r) => r.toLowerCase() == backendRole.toLowerCase(),
            orElse: () => _roles.last, // Default to 'Admin'
          );
        } catch (_) {
          _selectedRole = 'Admin';
        }
      } else {
        _selectedRole = 'Admin';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepNavy,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'PROFILE',
          style: GoogleFonts.syne(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
          if (state is ProfileUpdateSuccess) {
            setState(() => _isEditing = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          }
          if (state is AccountDeletedSuccess) {
            context.read<AuthBloc>().add(LogoutEvent());
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoaded) {
            _setupControllers(state);
          }
          
          return Stack(
            children: [
              // Background Circles
              Positioned(
                top: -100,
                left: -100,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryNavy.withValues(alpha: 0.1),
                  ),
                ),
              ),
              
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Avatar placeholder
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.accentYellow, width: 3),
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 60,
                            color: AppColors.accentYellow,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      GlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Personal Information',
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _isEditing ? Icons.close_rounded : Icons.edit_rounded,
                                    color: AppColors.accentYellow,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() => _isEditing = !_isEditing);
                                  },
                                ),
                              ],
                            ),
                            const Divider(color: Colors.white10, height: 32),
                            
                            _buildInfoField('FULL NAME', _nameController, editable: _isEditing),
                            const SizedBox(height: 24),
                            
                            _buildRoleDropdown('YOUR ROLE', editable: _isEditing),
                            const SizedBox(height: 24),
                            
                            _buildStaticField('PHONE NUMBER', 
                              state is ProfileLoaded ? state.user.phoneNumber : 'Loading...'
                            ),
                            
                            if (_isEditing) ...[
                              const SizedBox(height: 40),
                              PrimaryButton(
                                text: 'SAVE CHANGES',
                                onPressed: () {
                                  context.read<ProfileBloc>().add(UpdateProfileEvent(
                                    name: _nameController.text,
                                    role: _selectedRole,
                                  ));
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Secondary Actions
                      TextButton.icon(
                        onPressed: () => _showDeleteDialog(context),
                        icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent, size: 18),
                        label: Text(
                          'DELETE ACCOUNT',
                          style: GoogleFonts.inter(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      
                      if (state is ProfileLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: CircularProgressIndicator(color: AppColors.accentYellow),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller, {required bool editable}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Colors.white38,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        editable 
          ? TextField(
              controller: controller,
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentYellow)),
              ),
            )
          : Text(
              controller.text,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
      ],
    );
  }

  Widget _buildRoleDropdown(String label, {required bool editable}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Colors.white38,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        editable 
          ? DropdownButtonFormField<String>(
              value: _selectedRole,
              dropdownColor: AppColors.primaryNavy,
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 16),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentYellow)),
              ),
              items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (val) => setState(() => _selectedRole = val),
            )
          : Text(
              _selectedRole ?? 'Admin',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
      ],
    );
  }

  Widget _buildStaticField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Colors.white38,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.primaryNavy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete Account?', style: GoogleFonts.outfit(color: Colors.white)),
        content: Text(
          'This will permanently remove your administrator profile. This action cannot be undone.',
          style: GoogleFonts.inter(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('CANCEL', style: TextStyle(color: Colors.white38)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ProfileBloc>().add(DeleteAccountEvent());
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
