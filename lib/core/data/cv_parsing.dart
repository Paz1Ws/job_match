import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/core/domain/models/candidate_model.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase, User;

int generateRandomMatchPercentage() {
  return Random().nextInt(41) +
      60; // Generates a number from 0-40, then adds 60
}

class CvParser {
  final _client = Dio(
    BaseOptions(
      baseUrl: 'https://api.affinda.com/v2/resumes/',
      headers: {
        'Authorization':
            'Bearer ${'aff_92fb9abfcd1e50f96989b15c833937e07c110ed4'}',
      },
      connectTimeout: const Duration(
        seconds: 300,
      ), // Tiempo para establecer la conexión
      receiveTimeout: const Duration(
        seconds: 300,
      ), // Tiempo para recibir la respuesta
      sendTimeout: const Duration(
        seconds: 300,
      ), // Tiempo para enviar la solicitud
    ),
  );

  /// Parámetros fijos de tu cuenta
  final String workspaceId = 'opiUSrQg';
  final String documentTypeId = 'xaGfCfRx';

  Future<Map<String, dynamic>> parseCv(Uint8List bytes, String filename) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        bytes,
        filename: filename,
        contentType: DioMediaType('application', 'pdf'),
      ),
      'workspace': workspaceId,
      'documentType': documentTypeId,
    });

    final resp = await _client.post(
      '', // la baseUrl ya incluye /pipeline/resumes
      data: formData,
      // evita que Dio considere 404 como excepción si prefieres manejar errores manualmente:
      options: Options(validateStatus: (status) => status! < 500),
    );

    if (resp.statusCode == 200) {
      return resp.data as Map<String, dynamic>;
    } else {
      throw Exception('Affinda error ${resp.statusCode}: ${resp.data}');
    }
  }

  // Parse CV and create new user with provided credentials
  Future<Candidate> parseAndSaveCandidate({
    required Uint8List bytes,
    required String filename,
    required String email,
    required String password,
  }) async {
    // Parse the CV using the existing parseCv method that uses Affinda
    final resp = await parseCv(bytes, filename);
    final data = resp['data'] as Map<String, dynamic>;

    // Process the name properly
    String formattedName = _formatName(data['name']);

    // Get appropriate values ensuring correct types
    final experience =
        (data['employment'] != null)
            ? ((data['employment'] as List?)
                ?.map((e) => (e['summary'] ?? 'Work experience').toString())
                .join('\n'))
            : 'No previous experience';
    final education =
        (data['education'] != null)
            ? ((data['education'] as List?)
                ?.map((e) => _formatEducationEntry(e))
                .where((entry) => entry.isNotEmpty)
                .join('\n'))
            : 'No formal education listed';
    final skills =
        (data['skills'] as List?)
            ?.map((s) => (s['name'] ?? 'General skill').toString())
            .toList() ??
        ['Adaptability', 'Communication', 'Problem solving'];
    final bio =
        data['summary']?.toString() ??
        'Professional looking for new opportunities';

    // Format location properly from raw location data
    final location = _formatLocation(data['location']);

    final phone =
        data['phone_numbers'] != null &&
                (data['phone_numbers'] as List).isNotEmpty
            ? data['phone_numbers'][0]?.toString() ?? '974023810'
            : '';

    // Create new user with provided email and password
    final User user = await signUpWithEmailAndPassword(
      email: email,
      password: password,
      role: 'postulante',
    );

    // Create candidate with CV data
    final candidate = Candidate(
      userId: user.id,
      name: formattedName,
      experience: experience,
      education: education,
      skills: skills,
      parsedAt: DateTime.now(),
      bio: bio,
      location: location,
      resumeUrl: null, // Will be set after upload
      phone: phone,
      mainPosition: _determineExperienceLevel(data['employment']),
    );

    // Save candidate to database
    await Supabase.instance.client
        .from('candidates')
        .insert(candidate.toJson());

    return candidate;
  }

  // Format name correctly from raw name data
  String _formatName(dynamic rawName) {
    if (rawName == null) return 'Usuario';

    // If it's a map, try to join first, middle, last in a readable way
    if (rawName is Map<String, dynamic>) {
      final first = (rawName['first'] ?? '').toString().trim();
      final middle = (rawName['middle'] ?? '').toString().trim();
      final last = (rawName['last'] ?? '').toString().trim();

      // Only include non-empty parts, join with space
      final parts = [first, middle, last].where((p) => p.isNotEmpty).toList();
      if (parts.isNotEmpty) {
        return parts.join(' ');
      }
      // If all are empty, fallback to raw string if available
      if (rawName['raw'] != null &&
          rawName['raw'].toString().trim().isNotEmpty) {
        return rawName['raw'].toString().trim();
      }
      return 'Usuario';
    }
    // If it's just a string, return it trimmed
    return rawName.toString().trim();
  }

  // Format location to be human-readable from raw location data
  String _formatLocation(dynamic rawLocation) {
    if (rawLocation == null) return 'No especificado';

    // If it's a string, return it directly
    if (rawLocation is String) return rawLocation;

    // If it's a map, process the fields
    if (rawLocation is Map<String, dynamic>) {
      // Priority elements for location
      List<String> locationParts = [];

      // Add city if available
      if (rawLocation['city'] != null &&
          rawLocation['city'].toString().isNotEmpty) {
        locationParts.add(rawLocation['city'].toString());
      }

      // Add state if available
      if (rawLocation['state'] != null &&
          rawLocation['state'].toString().isNotEmpty) {
        locationParts.add(rawLocation['state'].toString());
      }

      // Add country if available
      if (rawLocation['country'] != null &&
          rawLocation['country'].toString().isNotEmpty) {
        locationParts.add(rawLocation['country'].toString());
      }

      // If we have formatted field, use it as fallback
      if (locationParts.isEmpty && rawLocation['formatted'] != null) {
        return rawLocation['formatted'].toString();
      }

      // If we have raw input, use it as second fallback
      if (locationParts.isEmpty && rawLocation['rawInput'] != null) {
        return rawLocation['rawInput'].toString();
      }

      // Join all parts with commas
      if (locationParts.isNotEmpty) {
        return locationParts.join(', ');
      }
    }

    // Last resort fallback
    return 'No especificado';
  }

  // Helper method to determine experience level based on employment history
  String _determineExperienceLevel(List? employmentHistory) {
    if (employmentHistory == null || employmentHistory.isEmpty) {
      return 'Junior';
    }

    // Count total years of experience (simplified logic)
    int totalYears =
        employmentHistory.length; // Assume each job is roughly 1 year

    if (totalYears > 7) {
      return 'Senior';
    } else if (totalYears > 3) {
      return 'Mid';
    } else {
      return 'Junior';
    }
  }

  // Helper method to format education entries properly
  String _formatEducationEntry(dynamic educationEntry) {
    if (educationEntry == null) return '';

    // If it's a string, just return it
    if (educationEntry is String) {
      return educationEntry.isNotEmpty
          ? educationEntry
          : 'Educational institution';
    }

    // If it's not a map, fallback to string
    if (educationEntry is! Map<String, dynamic>) {
      return educationEntry.toString().isNotEmpty
          ? educationEntry.toString()
          : 'Educational institution';
    }

    final entry = educationEntry;
    String institutionName = '';
    String degree = '';
    String location = '';

    // Extract institution name
    if (entry['organization'] != null) {
      if (entry['organization'] is String) {
        institutionName = entry['organization'].toString();
      } else if (entry['organization'] is Map<String, dynamic>) {
        final org = entry['organization'] as Map<String, dynamic>;
        institutionName = org['name']?.toString() ?? '';
      }
    } else if (entry['institution'] != null) {
      institutionName = entry['institution'].toString();
    } else {
      for (final key in ['school', 'university', 'college', 'name']) {
        if (entry[key] != null && entry[key].toString().isNotEmpty) {
          institutionName = entry[key].toString();
          break;
        }
      }
    }

    // Extract degree/program information (avoid printing the whole map)
    // Prefer 'accreditation', then 'degree', then 'education', then 'program', then 'inputStr'
    for (final key in [
      'accreditation',
      'degree',
      'education',
      'program',
      'inputStr',
    ]) {
      final value = entry[key];
      if (value != null && value is String && value.trim().isNotEmpty) {
        degree = value.trim();
        break;
      }
    }

    // Extract location if available
    if (entry['location'] != null) {
      final formattedLocation = _formatLocation(entry['location']);
      if (formattedLocation != 'No especificado') {
        location = formattedLocation;
      }
    }

    // Build the formatted string
    List<String> parts = [];
    if (degree.isNotEmpty) parts.add(degree);
    if (institutionName.isNotEmpty) parts.add(institutionName);
    if (location.isNotEmpty) parts.add(location);

    if (parts.isEmpty) return 'Educational institution';

    return parts.join(' - ');
  }
}

final parseCandidateProvider = Provider((ref) {
  return CvParser();
});
