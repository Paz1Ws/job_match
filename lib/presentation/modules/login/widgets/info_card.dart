import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon
  });

  final String title;
  final String subtitle;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(50),
            borderRadius: BorderRadius.circular(12.0)
          ),
          child: icon,
          // child: Icon(icon, )
        ),

        const SizedBox(height: 16.0),

        Text(
          title,
          style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }
}