import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/core/domain/models/candidate_model.dart';
import 'package:job_match/presentation/widgets/common/profile_photo_picker.dart';
import 'package:job_match/config/util/form_utils.dart'; // Assuming FormUtils exists

class EditCandidateProfileDialog extends ConsumerStatefulWidget {
  final Candidate candidate;

  const EditCandidateProfileDialog({super.key, required this.candidate});

  @override
  ConsumerState<EditCandidateProfileDialog> createState() =>
      _EditCandidateProfileDialogState();
}

class _EditCandidateProfileDialogState
    extends ConsumerState<EditCandidateProfileDialog> {
  late TextEditingController _nameController;
  late TextEditingController _mainPositionController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;
  late TextEditingController _phoneController;
  late TextEditingController _educationController;
  late TextEditingController _experienceController;
  late TextEditingController _skillsController;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.candidate.name ?? '');
    _mainPositionController = TextEditingController(
      text: widget.candidate.mainPosition ?? '',
    );
    _bioController = TextEditingController(text: widget.candidate.bio ?? '');
    _locationController = TextEditingController(
      text: widget.candidate.location ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.candidate.phone ?? '',
    );
    _educationController = TextEditingController(
      text: widget.candidate.education ?? '',
    );
    _experienceController = TextEditingController(
      text: widget.candidate.experience ?? '',
    );
    _skillsController = TextEditingController(
      text: widget.candidate.skills?.join(', ') ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mainPositionController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _educationController.dispose();
    _experienceController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.orange, width: 2), // orange
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final updates = {
          'name': _nameController.text,
          'main_position': _mainPositionController.text,
          'bio': _bioController.text,
          'location': _locationController.text,
          'phone': _phoneController.text,
          'education': _educationController.text,
          'experience': _experienceController.text,
          'skills':
              _skillsController.text
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList(),
        };

        final updateProvider = ref.read(updateProfileProvider);
        await updateProvider(updates);
        await refreshCandidateProfile(ref); // Refresh profile data

        if (mounted) {
          Navigator.of(context).pop(); // Close dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Perfil actualizado correctamente.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al actualizar el perfil: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 12.0),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12.0,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
      title: const Text(
        'Editar Perfil',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.orange,
        ),
      ),
      content: SizedBox(
        width: screenWidth * (screenWidth > 600 ? 0.5 : 0.9),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 16),
                ProfilePhotoPicker(
                  currentPhotoUrl: widget.candidate.photo,
                  isCompany: false,
                  radius: 50,
                  onPhotoUpdated: () async {
                    // Refresh the candidate profile in the dialog's parent scope
                    await refreshCandidateProfile(ref);
                    // No need to setState here as ProfilePhotoPicker handles its own UI
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration('Nombre Completo'),
                  validator: FormUtils.validateName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _mainPositionController,
                  decoration: _inputDecoration(
                    'Puesto Principal',
                    hint: 'Ej: Desarrollador Frontend',
                  ),
                  validator:
                      (value) =>
                          FormUtils.validateRequired(value, 'Puesto Principal'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bioController,
                  decoration: _inputDecoration('Biografía'),
                  maxLines: 3,
                  validator: FormUtils.validateBio,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: _inputDecoration(
                    'Ubicación',
                    hint: 'Ej: Lima, Perú',
                  ),
                  validator:
                      (value) => FormUtils.validateRequired(value, 'Ubicación'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: _inputDecoration('Teléfono'),
                  keyboardType: TextInputType.phone,
                  validator: FormUtils.validatePhone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _educationController,
                  decoration: _inputDecoration('Nivel Educativo'),
                  validator:
                      (value) =>
                          FormUtils.validateRequired(value, 'Nivel Educativo'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _experienceController,
                  decoration: _inputDecoration('Experiencia Laboral (resumen)'),
                  maxLines: 3,
                  validator: FormUtils.validateWorkExperience,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _skillsController,
                  decoration: _inputDecoration(
                    'Habilidades',
                    hint: 'Separadas por coma: Flutter, Firebase, UI/UX',
                  ),
                  validator: FormUtils.validateSkillsSeparatedByCommas,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancelar',
            style: TextStyle(color: Colors.orange.shade700),
          ),
        ),
        ElevatedButton.icon(
          icon:
              _isLoading
                  ? Container()
                  : const Icon(
                    Icons.save_alt_outlined,
                    size: 20,
                    color: Colors.white,
                  ),
          label:
              _isLoading
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : const Text('Guardar Cambios'),
          onPressed: _isLoading ? null : _saveProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ],
    );
  }
}
