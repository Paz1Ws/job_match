import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:job_match/core/domain/models/posted_job_model.dart';

// Cliente global
final supabase = Supabase.instance.client;

// 2.1. Candidates
final candidatesProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final res = await supabase.from('candidates').select('*').order('name');
      return res;
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
final createJobProvider = Provider((ref) {
  return (
    int companyId,
    String title,
    String description,
    String location,
    String jobType,
    num? salaryMin,
    num? salaryMax,
    DateTime? applicationDeadline,
    String status, // e.g., 'open', 'paused'
    List<String>? requiredSkills,
    int? maxApplications,
  ) async {
    final Map<String, dynamic> jobData = {
      'company_id': companyId,
      'title': title,
      'description': description,
      'location': location,
      'job_type': jobType,
      'status': status,
      'views_count': 0, // Default views_count to 0 on creation
    };

    if (salaryMin != null) jobData['salary_min'] = salaryMin;
    if (salaryMax != null) jobData['salary_max'] = salaryMax;
    if (applicationDeadline != null) {
      jobData['application_deadline'] = applicationDeadline.toIso8601String();
    }
    if (requiredSkills != null && requiredSkills.isNotEmpty) {
      jobData['required_skills'] = requiredSkills;
    }
    if (maxApplications != null) {
      jobData['max_applications'] = maxApplications;
    }

    final response =
        await Supabase.instance.client
            .from('jobs')
            .insert(jobData)
            .select()
            .single(); // Assuming insert returns the created row

    return PostedJob.fromJson(response);
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
  return (int jobId) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuario no autenticado');

    final response =
        await Supabase.instance.client.from('applications').insert({
          'user_id': userId,
          'job_id': jobId,
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
            .from('profiles')
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
