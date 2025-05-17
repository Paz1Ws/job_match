import 'package:flutter/material.dart';

class JobMatchWidget extends StatelessWidget {
  const JobMatchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.work, color: Colors.deepOrange),
        SizedBox(width: 8),
        Text('Job Match', style: TextStyle(color: Colors.white, fontSize: 20))
      ],
    );
  }
}