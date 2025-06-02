import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';

class ProfilePhotoPicker extends ConsumerStatefulWidget {
  final String? currentPhotoUrl;
  final bool isCompany;
  final VoidCallback? onPhotoUpdated;

  const ProfilePhotoPicker({
    super.key,
    this.currentPhotoUrl,
    this.isCompany = false,
    this.onPhotoUpdated,
  });

  @override
  ConsumerState<ProfilePhotoPicker> createState() => _ProfilePhotoPickerState();
}

class _ProfilePhotoPickerState extends ConsumerState<ProfilePhotoPicker> {
  bool _isUploading = false;

  Future<void> _pickAndUploadPhoto() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() => _isUploading = true);

        final fileBytes = result.files.single.bytes!;
        final fileName = result.files.single.name;

        if (widget.isCompany) {
          final uploadLogo = ref.read(uploadCompanyLogoProvider);
          await uploadLogo(fileBytes, fileName);
          // Refresca desde la base de datos
          await refreshCompanyProfile(ref);
        } else {
          final uploadPhoto = ref.read(uploadCandidatePhotoProvider);
          await uploadPhoto(fileBytes, fileName);
          // Refresca desde la base de datos
          await refreshCandidateProfile(ref);
        }

        widget.onPhotoUpdated?.call();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.isCompany
                    ? 'Logo actualizado exitosamente'
                    : 'Foto de perfil actualizada exitosamente',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al subir la imagen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isUploading ? null : _pickAndUploadPhoto,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage:
                widget.currentPhotoUrl != null &&
                        widget.currentPhotoUrl!.isNotEmpty
                    ? NetworkImage(widget.currentPhotoUrl!)
                    : null,
            backgroundColor: Colors.grey.shade300,
            child:
                widget.currentPhotoUrl != null &&
                        widget.currentPhotoUrl!.isNotEmpty
                    ? null
                    : Icon(
                      widget.isCompany ? Icons.business : Icons.person,
                      color: Colors.white,
                      size: 24,
                    ),
          ),
          if (_isUploading)
            const Positioned.fill(
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.black54,
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
