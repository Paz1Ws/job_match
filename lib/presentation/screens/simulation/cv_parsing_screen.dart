import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import 'package:job_match/core/data/mock_data.dart';
import 'package:job_match/presentation/screens/simulation/candidate_profile_screen.dart';
import 'dart:async';

class CVParsingScreen extends StatefulWidget {
  const CVParsingScreen({super.key});

  @override
  State<CVParsingScreen> createState() => _CVParsingScreenState();
}

class _CVParsingScreenState extends State<CVParsingScreen>
    with SingleTickerProviderStateMixin {
  bool _showUploadButton = true;
  bool _isLoading = false;
  double _progressValue = 0.0;
  late AnimationController _progressController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _progressController.addListener(() {
      setState(() {
        _progressValue = _progressController.value;
      });
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    if (_isLoading) {
      _timer.cancel();
    }
    super.dispose();
  }

  void _startParsing() {
    setState(() {
      _showUploadButton = false;
      _isLoading = true;
    });

    _progressController.forward();

    // Simulate the parsing with a timer
    _timer = Timer(const Duration(milliseconds: 3000), () {
      // Navigate to profile screen after parsing animation
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:
              (context) => CandidateProfileScreen(
                candidateData: MockCandidate.julioCesarNima,
              ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.white],
          ),
        ),
        child: Center(
          child: FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: Container(
              width: 600,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _showUploadButton ? 'Sube tu CV' : 'Analizando tu CV...',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_showUploadButton)
                    Column(
                      children: [
                        const Text(
                          'Sube tu CV y deja que nuestra IA extraiga automáticamente tus datos y habilidades.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: _startParsing,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.blue.shade200,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.upload_file,
                                  size: 64,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Haz clic para subir',
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Formatos aceptados: PDF, DOCX, RTF',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: Lottie.network(
                            'https://assets10.lottiefiles.com/packages/lf20_mdbdc5l7.json',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: _progressValue,
                            minHeight: 10,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Extrayendo información: ${(_progressValue * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
