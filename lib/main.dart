import 'package:flutter/material.dart';
import 'package:job_match/presentation/modules/homepage/screens/homepage_screen.dart';

void main() {
  runApp(const JobMatchApp());
}

class JobMatchApp extends StatelessWidget {
  const JobMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white
          )
        )
      ),
      home: const HomepageScreen()
    );
  }
}
