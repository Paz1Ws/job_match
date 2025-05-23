import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/core/domain/models/candidate_model.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase, User;

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

  // Parse CV and create new user instead of updating existing one
  Future<Candidate> parseAndSaveCandidate({
    required Uint8List bytes,
    required String filename,
    required String userId,
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
                ?.map(
                  (e) =>
                      (e['institution'] ?? 'Educational institution')
                          .toString(),
                )
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
    final location = data['location']?.toString() ?? 'Not specified';
    final phone =
        data['phone_numbers'] != null &&
                (data['phone_numbers'] as List).isNotEmpty
            ? data['phone_numbers'][0]?.toString() ?? '974023810'
            : '${900000000 + Random().nextInt(99999999)}';

    // Generate unique email and password based on parsed data
    final String email = _generateEmail(formattedName);
    final String password = _generateRandomPassword();

    // Create new user
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
      experienceLevel: _determineExperienceLevel(data['employment']),
    );

    // Save candidate to database
    await Supabase.instance.client
        .from('candidates')
        .insert(candidate.toJson());

    // Print credentials to console for testing purposes
    print('Created new user from CV upload:');
    print('Email: $email');
    print('Password: $password');

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

  // Generate email based on name
  String _generateEmail(String name) {
    // Convert to lowercase, replace spaces with dots and remove special characters
    String sanitizedName = name
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '') // Remove special characters
        .trim()
        .replaceAll(' ', '.');

    // Add random number to ensure uniqueness
    final random = Random();
    final randomNum = random.nextInt(9999);

    return '$sanitizedName$randomNum@gmail.com';
  }

  // Generate random password
  String _generateRandomPassword() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        10, // 10 character password
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
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
}

final parseCandidateProvider = Provider((ref) {
  return CvParser();
});
