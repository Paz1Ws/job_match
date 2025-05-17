import 'package:flutter/material.dart';
import 'dart:async';
import 'package:job_match/config/util/animations.dart';
import 'package:job_match/presentation/screens/homepage/screens/homepage_screen.dart';
import 'package:job_match/presentation/screens/profiles/user_profile.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _opacity = 1.0;
      });
    }

    // Wait for a bit
    await Future.delayed(const Duration(seconds: 2));

    // Fade out before navigating
    if (mounted) {
      setState(() {
        _opacity = 0.0;
      });
    }
    await Future.delayed(const Duration(milliseconds: 600));

    // Navigate to Login screen with fade
    if (mounted) {
      Navigator.of(context).pushReplacement(FadeRoute(page: const HomepageScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 600),
          child: Image.asset(
            'assets/images/job_match.jpg',
            width: 200, // Adjust size as needed
            height: 200, // Adjust size as needed
          ),
        ),
      ),
    );
  }
}
