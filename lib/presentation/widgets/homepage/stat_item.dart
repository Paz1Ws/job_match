import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  final IconData icon;
  final String count;
  final String label;
  final double? iconSize;
  final double? fontSize;

  const StatItem({
    super.key,
    required this.icon,
    required this.count,
    required this.label,
    this.iconSize,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.deepOrange,
          ),
          child: Icon(icon, color: Colors.white, size: iconSize ?? 40),
        ),

        const SizedBox(width: 10),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              count,
              maxLines: 2,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize ?? 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(label, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ],
    );
  }
}
