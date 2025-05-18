import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Cliente global
final supabase = Supabase.instance.client;

// 2.1. Profiles
final profilesProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>(
  (ref) async {
    final res = await supabase
        .from('profiles')
        .select('user_id, name, experience, education, skills, parsed_at')
        .order('name');
    return res;
  },
);

// 2.2. Companies
final companiesProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final res = await supabase
          .from('companies')
          .select('user_id, company_name, description, logo');
      return res;
    });

// 2.3. Jobs
final jobsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((
  ref,
) async {
  final res = await supabase
      .from('jobs')
      .select('id, company_id, title, description, created_at')
      .order('created_at', ascending: false);
  return res;
});

// 2.4. Applications
final applicationsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final res = await supabase
          .from('applications')
          .select('id, job_id, user_id, status, applied_at')
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
  return (int companyId, String title, String description) async {
    final response =
        await Supabase.instance.client.from('jobs').insert({
          'company_id': companyId,
          'title': title,
          'description': description,
        }).select();

    return response;
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
