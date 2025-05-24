import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/core/domain/models/candidate_model.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Cliente global
final supabase = Supabase.instance.client;

// 2.1. Candidates
final candidatesProvider = FutureProvider.autoDispose<List<Candidate>>((
  ref,
) async {
  final res = await supabase.from('candidates').select('*').order('name');
  return res.map((e) => Candidate.fromJson(e)).toList();
});

// 2.2. Companies
final companiesProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final res = await supabase.from('companies').select('*');
      return res;
    });

// 2.3. Jobs
final jobsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((
  ref,
) async {
  final res = await supabase
      .from('jobs')
      .select('*')
      .order('created_at', ascending: false);
  return res;
});

final jobsProviderWithCompanyName =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final res = await supabase
          .from('jobs')
          .select('*, users!company_id(companies(company_name))')
          .order('created_at', ascending: false);

      return res;
    });

// 2.4. Applications
final applicationsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final res = await supabase
          .from('applications')
          .select('*')
          .order('applied_at', ascending: false);
      return res;
    });

final jobsCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final response = await Supabase.instance.client.from('jobs').select('id');

  final count = response.length;
  return count;
});

final recentJobsCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final response = await Supabase.instance.client
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
  final response = await Supabase.instance.client
      .from('candidates')
      .select('user_id');

  final count = response.length;
  return count;
});

final companiesCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final response = await Supabase.instance.client
      .from('companies')
      .select('user_id');

  final count = response.length;
  return count;
});

// 📋 CRUD DEMO OPERATIONS

/// 1. Crear una empresa (POST /companies)
/// Permite a un usuario autenticado registrar una nueva empresa.
final createCompanyProvider = Provider((ref) {
  return (String name, String description) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuario no autenticado');

    final response =
        await Supabase.instance.client.from('companies').insert({
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
  return (int companyId, Map<String, dynamic> updates) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuario no autenticado');

    final response =
        await Supabase.instance.client
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
final createJobProvider = Provider<
  Future<Map<String, dynamic>> Function(Map<String, dynamic>)
>((ref) {
  return (Map<String, dynamic> jobData) async {
    try {
      final List<Map<String, dynamic>> insertedData =
          await supabase.from('jobs').insert(jobData).select();

      if (insertedData.isEmpty) {
        throw Exception(
          'Job creation seemingly succeeded, but no data was returned. Review RLS policies on the "jobs" table.',
        );
      }

      return insertedData.first;
    } on PostgrestException catch (e) {
      print(
        'PostgrestException during job creation: ${e.message} (Code: ${e.code}, Details: ${e.details})',
      );
      throw Exception(
        'Database error: "${e.message}". This is likely caused by a server-side trigger (e.g., the "notify_new_job()" function) or an RLS policy on the "jobs" table that incorrectly references a non-existent "profiles" table. Please review your database schema and triggers.',
      );
    } catch (e) {
      // Catch-all for other types of errors.
      print('Unexpected error during job creation: $e');
      throw Exception(
        'An unexpected error occurred while creating the job: $e',
      );
    }
  };
});

/// 4. Actualizar una vacante (PUT /jobs/{id})
/// Permite a una empresa modificar los detalles de una vacante existente.
final updateJobProvider = Provider((ref) {
  return (int jobId, Map<String, dynamic> updates) async {
    final response =
        await Supabase.instance.client
            .from('jobs')
            .update(updates)
            .eq('id', jobId)
            .select();

    return response;
  };
});

/// 5. Postular a una vacante (POST /applications)
/// Permite a un usuario autenticado postularse a una vacante.
final applyToJobProvider = Provider((ref) {
  return (String jobId) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuario no autenticado');

    final response =
        await Supabase.instance.client.from('applications').insert({
          'user_id': userId,
          'job_id': jobId,
          'status': 'pending',
          'applied_at': DateTime.now().toIso8601String(),
        }).select();

    return response;
  };
});

/// 6. Actualizar el perfil de usuario (PUT /profiles/{id})
/// Permite a un usuario autenticado actualizar su perfil.
final updateProfileProvider = Provider((ref) {
  return (Map<String, dynamic> updates) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuario no autenticado');

    final response =
        await Supabase.instance.client
            .from('candidates')
            .update(updates)
            .eq('user_id', userId)
            .select();

    return response;
  };
});

final uploadCvProvider = Provider((ref) {
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
  if (companyId.isEmpty) return [];

  try {
    final response = await supabase
        .from('jobs')
        .select('*')
        .eq('company_id', companyId)
        .order('created_at', ascending: false);

    return response.map((job) => Job.fromMap(job)).toList();
  } catch (e) {
    print('Error fetching company jobs: $e');
    return [];
  }
});

/// Provider que expone la función de subida de logo de empresa
final uploadCompanyLogoProvider = Provider((ref) {
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
