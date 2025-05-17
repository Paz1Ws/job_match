import 'package:flutter/material.dart';
// import 'package:job_match/presentation/screens/dashboard/candidate_dashboard_screen.dart';
import 'package:job_match/presentation/screens/profiles/company_profile_screen.dart';
import 'package:job_match/presentation/screens/splash/splash_screen.dart'; // Import new screen

void main() {
  runApp(const JobMatchApp());
}

class JobMatchApp extends StatelessWidget {
  const JobMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Changed to CompanyProfileScreen for testing
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
