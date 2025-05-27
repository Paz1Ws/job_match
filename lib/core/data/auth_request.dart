import 'package:job_match/core/domain/models/company_model.dart';
import 'package:job_match/core/domain/models/candidate_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClient = Supabase.instance.client;
Future<User> login(String email, String password) async {
  try {
    await signOut(); // Cierra sesión antes de intentar login
    final AuthResponse res = await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final User? user = res.user;

    if (user != null) {
      print('Usuario autenticado: ${user.email}');
      return user;
    } else {
      throw Exception('No se pudo autenticar al usuario.');
    }
  } on AuthException catch (e) {
    print('Error de autenticación: ${e.message}');
    throw Exception('Error de autenticación: Verifica tus credenciales.');
  } catch (e) {
    // Manejo de otros errores
    throw Exception('Error inesperado: $e');
  }
}

Future<void> signOut() async {
  await supabaseClient.auth.signOut();
}

Future<User> signUpWithEmailAndPassword({
  required String email,
  required String password,
  required String role,
}) async {
  try {
    if (supabaseClient.auth.currentSession != null ||
        supabaseClient.auth.currentUser != null) {
      await signOut();
    }
    final response = await supabaseClient.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw Exception("Fallo el registro.");
    }

    // Insertar en tabla 'users'
    await supabaseClient.from('users').insert({
      'id': user.id,
      'email': email,
      'role': role,
    });

    // Guardar sesión si es necesario
    final session = response.session;
    if (session != null) {
      await supabaseClient.auth.setSession(session.refreshToken ?? '');
    }
    return user;
  } catch (e) {
    print('Error en signup: $e');
    rethrow;
  }
}

Future<bool> registerCandidate({
  required String email,
  required String password,
  required String name,
  required String phone,
  required String location,
  required List<String> skills,
  required String education,
  required String experience,
  required String mainPosition,
  String? photo,

  String? bio,
  String? resumeUrl,
}) async {
  try {
    final user = await signUpWithEmailAndPassword(
      email: email,
      password: password,
      role: 'postulante',
    );

    final candidate = Candidate(
      userId: user.id,
      name: name,
      phone: phone,
      location: location,
      skills: skills,
      bio: bio,
      resumeUrl: resumeUrl,
      education: education,
      experience: experience,
      mainPosition: mainPosition,
      photo: photo,
    );

    await supabaseClient.from('candidates').insert(candidate.toJson());

    return true;
  } catch (e) {
    print('Error registering candidate: $e');
    return false;
  }
}

Future<void> registerCompany({
  required String email,
  required String password,
  required String companyName,
  required String phone,
  required String address,
  required String industry,
  String? description,
  String? website,
  String? logo,
}) async {
  try {
    if (supabaseClient.auth.currentSession != null ||
        supabaseClient.auth.currentUser != null) {
      await signOut();
    }
    final user = await signUpWithEmailAndPassword(
      email: email,
      password: password,
      role: 'empresa',
    );

    final company = Company(
      userId: user.id,
      companyName: companyName,
      phone: phone,
      address: address,
      industry: industry,
      description: description,
      website: website,
      logo: logo,
    );

    await supabaseClient.from('companies').insert(company.toJson());
  } catch (e) {
    print('Error registering company: $e');
    rethrow;
  }
}

// Providers to store the authenticated user profile (candidate or company)
final candidateProfileProvider = StateProvider<Candidate?>((ref) => null);
final companyProfileProvider = StateProvider<Company?>((ref) => null);

Future<void> fetchUserProfile(WidgetRef ref) async {
  final user = supabaseClient.auth.currentUser;
  if (user == null) throw Exception('Usuario no autenticado');

  final userId = user.id;

  // Intenta obtener primero el perfil como candidato
  final candidateResponse =
      await supabaseClient
          .from('candidates')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

  if (candidateResponse != null) {
    final candidate = Candidate.fromJson(candidateResponse);
    ref.read(candidateProfileProvider.notifier).state = candidate;
    ref.read(companyProfileProvider.notifier).state = null;
    return;
  }

  // Si no es candidato, intenta obtener como empresa
  final companyResponse =
      await supabaseClient
          .from('companies')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

  if (companyResponse != null) {
    final company = Company.fromJson(companyResponse);
    ref.read(companyProfileProvider.notifier).state = company;
    ref.read(candidateProfileProvider.notifier).state = null;
    return;
  }

  throw Exception('No se encontró perfil de usuario');
}
