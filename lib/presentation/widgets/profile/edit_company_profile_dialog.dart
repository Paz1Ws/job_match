import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/core/domain/models/company_model.dart';
import 'package:job_match/presentation/widgets/common/profile_photo_picker.dart';
import 'package:job_match/config/util/form_utils.dart'; // Assuming FormUtils exists

class EditCompanyProfileDialog extends ConsumerStatefulWidget {
  final Company company;

  const EditCompanyProfileDialog({super.key, required this.company});

  @override
  ConsumerState<EditCompanyProfileDialog> createState() =>
      _EditCompanyProfileDialogState();
}

class _EditCompanyProfileDialogState
    extends ConsumerState<EditCompanyProfileDialog> {
  late TextEditingController _companyNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _websiteController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _industryController;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _companyNameController = TextEditingController(
      text: widget.company.companyName ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.company.description ?? '',
    );
    _websiteController = TextEditingController(
      text: widget.company.website ?? '',
    );
    _phoneController = TextEditingController(text: widget.company.phone ?? '');
    _addressController = TextEditingController(
      text: widget.company.address ?? '',
    );
    _industryController = TextEditingController(
      text: widget.company.industry ?? '',
    );
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _industryController.dispose();
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
          'company_name': _companyNameController.text,
          'description': _descriptionController.text,
          'website': _websiteController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
          'industry': _industryController.text,
        };

        final updateProvider = ref.read(updateCompanyProvider);

        await updateProvider(updates);
        await refreshCompanyProfile(ref); // Refresh profile data

        if (mounted) {
          Navigator.of(context).pop(); // Close dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Perfil de empresa actualizado correctamente.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          print("Error details: $e");
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
        'Editar Perfil de Empresa',
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
                  currentPhotoUrl: widget.company.logo,
                  isCompany: true,
                  radius: 50,
                  onPhotoUpdated: () async {
                    await refreshCompanyProfile(ref);
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _companyNameController,
                  decoration: _inputDecoration('Nombre de la Empresa'),
                  validator: FormUtils.validateCompanyName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: _inputDecoration('Descripción de la Empresa'),
                  maxLines: 3,
                  validator: FormUtils.validateCompanyDescription,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _websiteController,
                  decoration: _inputDecoration(
                    'Sitio Web',
                    hint: 'https://ejemplo.com',
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: _inputDecoration('Teléfono de Contacto'),
                  keyboardType: TextInputType.phone,
                  validator: FormUtils.validateCompanyPhone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: _inputDecoration('Dirección'),
                  validator:
                      (value) => FormUtils.validateRequired(value, 'Dirección'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _industryController,
                  decoration: _inputDecoration('Industria'),
                  validator:
                      (value) => FormUtils.validateRequired(value, 'Industria'),
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
