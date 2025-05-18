import 'package:flutter/material.dart';
import 'package:job_match/config/router/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/config/secrets/supabase_secrets.dart';
// import 'package:job_match/presentation/screens/dashboard/candidate_dashboard_screen.dart';
import 'package:job_match/presentation/screens/profiles/company_profile_screen.dart';
import 'package:job_match/presentation/screens/splash/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import new screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: SUPABASE_URL, anonKey: SUPABASE_ANON_KEY);

  runApp(ProviderScope(child: JobMatchApp()));
}

class JobMatchApp extends StatelessWidget {
  const JobMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: MainRouter.router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange, // Default button color
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
