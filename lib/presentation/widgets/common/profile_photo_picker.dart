import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';

class ProfilePhotoPicker extends ConsumerStatefulWidget {
  final String? currentPhotoUrl;
  final bool isCompany;
  final VoidCallback? onPhotoUpdated;
  final double radius; // Add radius parameter

  const ProfilePhotoPicker({
    super.key,
    this.currentPhotoUrl,
    this.isCompany = false,
    this.onPhotoUpdated,
    this.radius = 40.0, // Default radius
  });

  @override
  ConsumerState<ProfilePhotoPicker> createState() => _ProfilePhotoPickerState();
}

class _ProfilePhotoPickerState extends ConsumerState<ProfilePhotoPicker> {
  bool _isUploading = false;
  String? _updatedPhotoUrl;

  String? get effectivePhotoUrl => _updatedPhotoUrl ?? widget.currentPhotoUrl;

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

        String uploadedUrl = "";
        if (widget.isCompany) {
          final uploadLogo = ref.read(uploadCompanyLogoProvider);
          uploadedUrl = await uploadLogo(fileBytes, fileName);
          await refreshCompanyProfile(ref);
        } else {
          final uploadPhoto = ref.read(uploadCandidatePhotoProvider);
          uploadedUrl = await uploadPhoto(fileBytes, fileName);
          await refreshCandidateProfile(ref);
        }

        setState(() {
          _isUploading = false;
          _updatedPhotoUrl = uploadedUrl; // Store the uploaded URL locally
        });

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
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al subir la imagen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the effective URL which could be either the updated one or the original one
    final currentUrl = effectivePhotoUrl;
    
    return GestureDetector(
      onTap: _isUploading ? null : _pickAndUploadPhoto,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: widget.radius,
            backgroundImage: currentUrl != null && currentUrl.isNotEmpty
                ? NetworkImage(currentUrl)
                : null,
            backgroundColor: Colors.grey.shade200,
            child: (currentUrl == null || currentUrl.isEmpty)
                ? Icon(
                    widget.isCompany ? Icons.business : Icons.person,
                    size: widget.radius,
                    color: Colors.grey.shade400,
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: widget.radius * 0.4,
              ),
            ),
          ),
          if (_isUploading)
            Container(
              width: widget.radius * 2,
              height: widget.radius * 2,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SizedBox(
                  width: widget.radius * 0.8,
                  height: widget.radius * 0.8,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
