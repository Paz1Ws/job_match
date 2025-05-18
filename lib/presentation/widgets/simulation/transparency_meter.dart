import 'package:flutter/material.dart';
import 'dart:math' as math;

class TransparencyMeter extends StatelessWidget {
  final double score;

  const TransparencyMeter({super.key, required this.score});

  Color _getColorForScore() {
    if (score < 60) return Colors.red.shade700;
    if (score < 85) return Colors.orange.shade700;
    return Colors.green.shade700;
  }

  String _getMessageForScore() {
    if (score < 60) return 'Perfil básico';
    if (score < 85) return 'Perfil sólido';
    if (score < 100) return 'Perfil destacado';
    return 'Perfil completo';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Transparencia del Perfil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              width: 180,
              child: CustomPaint(
                painter: TransparencyArcPainter(
                  score: score,
                  color: _getColorForScore(),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${score.toInt()}%',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: _getColorForScore(),
                        ),
                      ),
                      Text(
                        _getMessageForScore(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              score >= 100
                  ? '¡Excelente! Tu perfil está completamente transparente.'
                  : 'Añade más detalles para mejorar tu transparencia.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransparencyArcPainter extends CustomPainter {
  final double score;
  final Color color;

  TransparencyArcPainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.45;
    final arcAngle = (score / 100) * 2 * math.pi * 0.8;

    // Draw background arc
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.2,
      math.pi * 1.6,
      false,
      backgroundPaint,
    );

    // Draw progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.2,
      arcAngle,
      false,
      progressPaint,
    );

    // Draw ticks
    final tickPaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i <= 10; i++) {
      final angle = math.pi * 0.2 + (i / 10) * math.pi * 1.6;
      final tickLength = i % 5 == 0 ? 10.0 : 5.0;
      final outerPoint = Offset(
        center.dx + (radius + 5) * math.cos(angle),
        center.dy + (radius + 5) * math.sin(angle),
      );
      final innerPoint = Offset(
        center.dx + (radius - tickLength) * math.cos(angle),
        center.dy + (radius - tickLength) * math.sin(angle),
      );
      
      canvas.drawLine(innerPoint, outerPoint, tickPaint);
      
      if (i % 5 == 0) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${i * 10}',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 10,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final textOffset = Offset(
          center.dx + (radius - 25) * math.cos(angle) - textPainter.width / 2,
          center.dy + (radius - 25) * math.sin(angle) - textPainter.height / 2,
        );
        
        textPainter.paint(canvas, textOffset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant TransparencyArcPainter oldDelegate) {
    return oldDelegate.score != score || oldDelegate.color != color;
  }
}
