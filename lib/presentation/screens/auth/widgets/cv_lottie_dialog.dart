import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CVLottieDialog extends StatefulWidget {
  const CVLottieDialog({super.key});

  @override
  State<CVLottieDialog> createState() => _CVLottieDialogState();
}

class _CVLottieDialogState extends State<CVLottieDialog> {
  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset(
                'assets/animations/cv_lottie.json',
                width: 250,
                height: 250,
                repeat: true, // Keep repeating until dialog is closed
              ),
            ),
            const Text(
              'Leyendo Datos...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}