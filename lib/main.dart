import 'package:flutter/material.dart';


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
   
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CandidateDashboardScreen(),
    );
  }
}
