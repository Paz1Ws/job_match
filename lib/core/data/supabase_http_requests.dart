import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/domain/models/candidate_model.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dio/dio.dart'; // Add this import for Dio
import 'dart:convert';

import 'package:uuid/uuid.dart'; // Needed for jsonEncode/jsonDecode

// Supabase client provider
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// 2.1. Candidates
final candidatesProvider = FutureProvider.autoDispose<List<Candidate>>((
  ref,
) async {
  final supabase = ref.read(supabaseProvider);
  final res = await supabase.from('candidates').select('*').order('name');
  return res.map((e) => Candidate.fromJson(e)).toList();
});

// 2.2. Companies
final companiesProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final supabase = ref.read(supabaseProvider);
      final res = await supabase.from('companies').select('*');
      return res;
    });

// 2.3. Jobs
final jobsProvider = FutureProvider.autoDispose<List<Job>>((ref) async {
  final supabase = ref.read(supabaseProvider);
  final res = await supabase
      .from('jobs')
      .select('*')
      .order('created_at', ascending: false);
  return res.map((e) => Job.fromMap(e)).toList();
});

final jobsProviderWithCompanyName =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final supabase = ref.read(supabaseProvider);
      final res = await supabase
          .from('jobs')
          .select('*, users!company_id(companies(company_name))')
          .order('created_at', ascending: false);

      return res;
    });

// 2.4. Applications
final applicationsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final supabase = ref.read(supabaseProvider);
      final res = await supabase
          .from('applications')
          .select('*')
          .order('applied_at', ascending: false);
      return res;
    });

// Applications for a specific job
final applicationsByJobIdProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      jobId,
    ) async {
      final supabase = ref.read(supabaseProvider);
      final res = await supabase
          .from('applications')
          .select('*')
          .eq('job_id', jobId)
          .order('applied_at', ascending: false);
      return res;
    });

final jobsCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final supabase = ref.read(supabaseProvider);
  final response = await supabase.from('jobs').select('id');

  final count = response.length;
  return count;
});

final recentJobsCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final supabase = ref.read(supabaseProvider);
  final response = await supabase
      .from('jobs')
      .select('id')
      .gte(
        'created_at',
        DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
      )
      .lte('created_at', DateTime.now().toIso8601String());

  final count = response.length;
  return count;
});

final candidatesCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final supabase = ref.read(supabaseProvider);
  final response = await supabase.from('candidates').select('user_id');

  final count = response.length;
  return count;
});

final companiesCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final supabase = ref.read(supabaseProvider);
  final response = await supabase.from('companies').select('user_id');

  final count = response.length;
  return count;
});

// 📋 CRUD DEMO OPERATIONS

/// 1. Crear una empresa (POST /companies)
/// Permite a un usuario autenticado registrar una nueva empresa.
final createCompanyProvider = Provider((ref) {
  final supabase = ref.read(supabaseProvider);
  return (String name, String description) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuario no autenticado');

    final response =
        await supabase.from('companies').insert({
          'user_id': userId,
          'company_name': name,
          'description': description,
        }).select();

    return response;
  };
});

/// 2. Actualizar una empresa (PUT /companies/{id})
/// Permite a un usuario autenticado modificar los detalles de su empresa.
final updateCompanyProvider = Provider((ref) {
  final supabase = ref.read(supabaseProvider);
  return (int companyId, Map<String, dynamic> updates) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuario no autenticado');

    final response =
        await supabase
            .from('companies')
            .update(updates)
            .eq('id', companyId)
            .eq('user_id', userId)
            .select();

    return response;
  };
});

/// 3. Crear una vacante (POST /jobs)
/// Permite a una empresa publicar una nueva vacante.
final createJobProvider = Provider<Future<void> Function(Map<String, dynamic>)>(
  (ref) => (Map<String, dynamic> jobData) async {
    final supabase = ref.read(supabaseProvider);
    try {
      await supabase.from('jobs').insert(jobData);
    } catch (e) {
      print('Error creating job: $e');
      rethrow;
    }
  },
);

/// Provider for updating an existing job
final updateJobProvider = FutureProvider.family<void, UpdateJobParams>((
  ref,
  params,
) async {
  final supabase = ref.read(supabaseProvider);

  try {
    await supabase.from('jobs').update(params.jobData).eq('id', params.jobId);
    print('Job updated successfully: ${params.jobId}');
  } catch (e) {
    print('Error updating job: $e');
    rethrow;
  }
});

/// Class to hold parameters for updating a job
class UpdateJobParams {
  final String jobId;
  final Map<String, dynamic> jobData;

  UpdateJobParams({required this.jobId, required this.jobData});
}

/// 5. Postular a una vacante (POST /applications)
/// Permite a un usuario autenticado postularse a una vacante.
final applyToJobProvider = Provider<
  Future<void> Function(String jobId, String candidateName, String coverLetter)
>((ref) {
  final supabase = ref.read(supabaseProvider);
  final candidate = ref.watch(candidateProfileProvider);

  // Get the current user
  final userId = supabase.auth.currentUser?.id;

  Future<void> applyToJob(
    String jobId,
    String candidateName, // candidateId is now candidateName for simplicity
    String coverLetter,
  ) async {
    if (candidate == null) {
      throw Exception('Candidate profile not found or user ID is null.');
    }
    try {
      await supabase.from('applications').insert({
        'job_id': jobId,
        'user_id': userId,
        'candidate': candidateName,
        'cover_letter': coverLetter,
        'applied_at': DateTime.now().toIso8601String(),
        'status': 'pending',
      });
      print(
        'Applied to job $jobId by candidate ${candidate.userId} ($candidateName)',
      );
    } catch (e) {
      print('Error applying to job: $e');
      rethrow;
    }
  }

  return applyToJob;
});

/// 6. Actualizar el perfil de usuario (PUT /profiles/{id})
/// Permite a un usuario autenticado actualizar su perfil.
final updateProfileProvider = Provider((ref) {
  final supabase = ref.read(supabaseProvider);
  return (Map<String, dynamic> updates) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuario no autenticado');

    final response =
        await supabase
            .from('candidates')
            .update(updates)
            .eq('user_id', userId)
            .select();

    return response;
  };
});

final uploadCvProvider = Provider((ref) {
  final supabase = ref.read(supabaseProvider);
  return (Uint8List fileBytes, String fileName) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuario no autenticado');

    try {
      // Upload the CV file to storage
      final storagePath = '$userId/$fileName';
      await supabase.storage.from('cvs').uploadBinary(storagePath, fileBytes);

      // Get the public URL for the uploaded file
      final fileUrl = supabase.storage.from('cvs').getPublicUrl(storagePath);

      // Update the candidate's resume URL in the database
      await supabase
          .from('candidates')
          .update({'resume_url': fileUrl})
          .eq('user_id', userId);

      return fileUrl;
    } catch (e) {
      throw Exception('Error procesando el CV: $e');
    }
  };
});

/// Provider to fetch jobs posted by a specific company
final jobsByCompanyIdProvider = FutureProvider.family<List<Job>, String>((
  ref,
  companyId,
) async {
  final supabase = ref.read(supabaseProvider);
  if (companyId.isEmpty) return [];

  try {
    // Ensure companyId is treated as a string, not parsed as a number
    // When comparing with 'eq', Supabase expects the type to match the column type
    final response = await supabase
        .from('jobs')
        .select(
          '*, users (*, companies (*))',
        ) // Include companies relation data if needed
        .eq(
          'company_id',
          companyId.toString(),
        ) // Explicitly use toString to ensure string comparison
        .order('created_at', ascending: false);

    print('Jobs response for company $companyId: ${response.length} jobs');

    return response.map((job) => Job.fromMap(job)).toList();
  } on FormatException catch (e) {
    // Log the error or handle it appropriately
    print('Invalid company ID format: $e');
    return [];
  } catch (e) {
    // Log the error or handle it appropriately
    print('Error fetching company jobs: $e');
    print('Failed company ID: $companyId (${companyId.runtimeType})');
    return [];
  }
});

/// Provider que expone la función de subida de logo de empresa
final uploadCompanyLogoProvider = Provider((ref) {
  final supabase = ref.read(supabaseProvider);
  Future<String> uploadLogo(Uint8List bytes, String filename) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Empresa no autenticada');
    }

    try {
      final storagePath = '$userId/$filename';
      await supabase.storage
          .from('companylogos')
          .uploadBinary(
            storagePath,
            bytes,
            fileOptions: const FileOptions(upsert: false),
          );

      final publicUrl = supabase.storage
          .from('companylogos')
          .getPublicUrl(storagePath);

      await supabase
          .from('companies')
          .update({'logo': publicUrl})
          .eq('user_id', userId);

      return publicUrl;
    } catch (e) {
      throw Exception('Error procesando el logo: $e');
    }
  }

  return uploadLogo;
});

/// Provider que expone la función de subida de foto de perfil de candidato
final uploadCandidatePhotoProvider = Provider((ref) {
  final supabase = ref.read(supabaseProvider);
  Future<String> uploadPhoto(Uint8List bytes, String filename) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuario no autenticado');
    }

    try {
      final storagePath = '$userId/$filename';
      await supabase.storage
          .from('candidatephotos')
          .uploadBinary(
            storagePath,
            bytes,
            fileOptions: const FileOptions(upsert: false),
          );

      final publicUrl = supabase.storage
          .from('candidatephotos')
          .getPublicUrl(storagePath);

      await supabase
          .from('candidates')
          .update({'photo': publicUrl})
          .eq('user_id', userId);

      return publicUrl;
    } catch (e) {
      throw Exception('Error procesando la foto de perfil: $e');
    }
  }

  return uploadPhoto;
});

// Provider for deleting a job
final deleteJobProvider = FutureProvider.family<bool, String>((
  ref,
  jobId,
) async {
  final supabase = ref.read(supabaseProvider);
  try {
    await supabase.from('jobs').delete().eq('id', jobId);
    return true;
  } catch (e) {
    print('Error deleting job: $e');
    return false;
  }
});

// Provider for fetching a candidate by user ID
final candidateByUserIdProvider = FutureProvider.family<Candidate?, String>((
  ref,
  userId,
) async {
  if (userId.isEmpty) return null;

  final supabase = ref.read(supabaseProvider);
  try {
    final data =
        await supabase
            .from('candidates')
            .select()
            .eq('user_id', userId)
            .single();
    return Candidate.fromJson(data);
  } catch (e) {
    print('Error fetching candidate $userId: $e');
    return null;
  }
});
