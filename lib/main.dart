import 'package:flutter/material.dart';
import 'package:job_match/presentation/screens/dashboard/candidate_dashboard_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CandidateDashboardScreen(), // Changed to CandidateDashboardScreen
    );
  }
}
