import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:job_match/presentation/screens/profiles/user_profile.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> signInWithGoogle(BuildContext context, WidgetRef ref) async {
  try {
    final googleSignIn = GoogleSignIn(
      clientId:
          '48275184349-abk3telftjk9v957nc8j14v0cgvoq26q.apps.googleusercontent.com',
      scopes: [
        'email',
        'openid',
        'https://zdvibikloongkbsesogk.supabase.co/auth/v1/callback',
      ],
    );

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final supabase = ref.read(supabaseProvider);

    // Add null checks for idToken and accessToken
    if (googleAuth.idToken == null) {
      throw Exception('Google Sign-In did not return an ID token.');
    }

    final AuthResponse response = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!, // Now checked for null
      accessToken:
          googleAuth.accessToken, // Pass it, Supabase might handle if it's null
    );

    final user = response.user; // user can be used if needed

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserProfile()),
      );
    }
  } catch (e) {
    // Manejo de errores
    print('Error durante el inicio de sesión con Google: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión con Google: $e')),
      );
    }
  }
}
