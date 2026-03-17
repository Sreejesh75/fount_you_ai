import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/color_constants.dart';
import '../bloc/worker_bloc.dart';
import '../bloc/worker_event.dart';
import '../bloc/worker_state.dart';
import '../../data/models/worker_model.dart';
import '../../../../core/widgets/custom_text_field.dart';

class WorkerListPage extends StatefulWidget {
  const WorkerListPage({super.key});

  @override
  State<WorkerListPage> createState() => _WorkerListPageState();
}

class _WorkerListPageState extends State<WorkerListPage> {
  @override
  void initState() {
    super.initState();
    context.read<WorkerBloc>().add(FetchAllWorkersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepNavy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Registered Workers',
          style: GoogleFonts.syne(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<WorkerBloc, WorkerState>(
        listener: (context, state) {
          if (state is WorkerActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is WorkerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
            );
          }
        },
        builder: (context, state) {
          if (state is WorkerLoading && state is! WorkersLoadedSuccess) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accentYellow));
          } else if (state is WorkersLoadedSuccess) {
            final workers = state.workers;
            if (workers.isEmpty) {
              return Center(
                child: Text(
                  'No workers registered yet',
                  style: GoogleFonts.inter(color: Colors.white54),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: workers.length,
              itemBuilder: (context, index) {
                final worker = workers[index];
                return _WorkerCard(worker: worker);
              },
            );
          }
          return const Center(child: CircularProgressIndicator(color: AppColors.accentYellow));
        },
      ),
    );
  }
}

class _WorkerCard extends StatelessWidget {
  final WorkerModel worker;
  const _WorkerCard({required this.worker});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              image: DecorationImage(
                image: NetworkImage(worker.photoUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  worker.name,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  worker.jobRole,
                  style: GoogleFonts.inter(color: AppColors.accentYellow, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.white38, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      worker.place,
                      style: GoogleFonts.inter(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_note_rounded, color: Colors.white54),
                onPressed: () => _showEditDialog(context, worker),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                onPressed: () => _showDeleteConfirmation(context, worker),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WorkerModel worker) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.deepNavy,
        title: Text('Delete Worker', style: GoogleFonts.syne(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete ${worker.name}?',
          style: GoogleFonts.inter(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('CANCEL', style: TextStyle(color: Colors.white38)),
          ),
          TextButton(
            onPressed: () {
              context.read<WorkerBloc>().add(DeleteWorkerEvent(worker.id));
              Navigator.pop(dialogContext);
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, WorkerModel worker) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => _EditWorkerSheet(worker: worker, workerBloc: context.read<WorkerBloc>()),
    );
  }
}

class _EditWorkerSheet extends StatefulWidget {
  final WorkerModel worker;
  final WorkerBloc workerBloc;
  const _EditWorkerSheet({required this.worker, required this.workerBloc});

  @override
  State<_EditWorkerSheet> createState() => _EditWorkerSheetState();
}

class _EditWorkerSheetState extends State<_EditWorkerSheet> {
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _placeController;
  late TextEditingController _phoneController;
  late TextEditingController _wageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.worker.name);
    _roleController = TextEditingController(text: widget.worker.jobRole);
    _placeController = TextEditingController(text: widget.worker.place);
    _phoneController = TextEditingController(text: widget.worker.contactNumber);
    _wageController = TextEditingController(text: widget.worker.dailyWage.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.deepNavy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        top: 32,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Edit Worker Details',
              style: GoogleFonts.syne(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomTextField(controller: _nameController, hintText: 'Name', icon: Icons.person_outline),
            CustomTextField(controller: _roleController, hintText: 'Role', icon: Icons.work_outline),
            CustomTextField(controller: _placeController, hintText: 'Location', icon: Icons.location_on_outlined),
            CustomTextField(controller: _phoneController, hintText: 'Phone', icon: Icons.phone_android),
            CustomTextField(controller: _wageController, hintText: 'Wage', icon: Icons.payments_outlined, keyboardType: TextInputType.number),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                widget.workerBloc.add(UpdateWorkerEvent(
                  id: widget.worker.id,
                  name: _nameController.text,
                  jobRole: _roleController.text,
                  place: _placeController.text,
                  contactNumber: _phoneController.text,
                  dailyWage: double.tryParse(_wageController.text),
                ));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentYellow,
                foregroundColor: AppColors.deepNavy,
                padding: const EdgeInsets.all(18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('SAVE CHANGES', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
