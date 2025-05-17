import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.textSize,
  });

  final String title;
  final String subtitle;
  final Icon icon;
  final int? textSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(50),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: icon,
        ),

        const SizedBox(height: 24.0),

        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white70,
            fontSize: (textSize ?? 16).toDouble(),
          ),
        ),
      ],
    );
  }
}
