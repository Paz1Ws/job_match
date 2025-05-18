import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClient = Supabase.instance.client;
Future<void> login(String email, String password) async {
  try {
    final AuthResponse res = await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final Session? session = res.session;
    final User? user = res.user;

    if (user != null) {
      // Inicio de sesión exitoso
      print('Usuario autenticado: ${user.email}');
      // Puedes navegar a la siguiente pantalla o cargar datos aquí
    } else {
      // Manejo de caso donde el usuario es null
      print('No se pudo autenticar al usuario.');
    }
  } on AuthException catch (e) {
    // Manejo de errores de autenticación
    print('Error de autenticación: ${e.message}');
  } catch (e) {
    // Manejo de otros errores
    print('Error inesperado: $e');
  }
}

Future<void> signUpWithEmailAndPassword({
  required String email,
  required String password,
  required String role,
}) async {
  try {
    final response = await supabaseClient.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw Exception("Fallo el registro.");
    }

    // Insertar en tabla 'users'
    final insertRes = await supabaseClient.from('users').insert({
      'id': user.id,
      'email': email,
      'role': role,
    });

    if (insertRes.error != null) {
      throw Exception(
        'Error insertando en tabla users: ${insertRes.error!.message}',
      );
    }

    // Guardar sesión si es necesario
    final session = response.session;
    if (session != null) {
      await supabaseClient.auth.setSession(session.refreshToken ?? '');
    }
  } on AuthException catch (e) {
    print('Auth error: ${e.message}');
    rethrow;
  } catch (e) {
    print('Error en signup: $e');
    rethrow;
  }
}
