import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/config/constants/layer_constants.dart';

class NotificationOverlay extends StatelessWidget {
  final String message;
  final int? fitPercentage;
  final VoidCallback onDismiss;

  const NotificationOverlay({
    super.key,
    required this.message,
    this.fitPercentage,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: FadeInRight(
        duration: const Duration(milliseconds: 500),
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.notifications_active, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    const Text(
                      'Notificación',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onDismiss,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(message),
                if (fitPercentage != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        '$fitPercentage% Match',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TweenAnimationBuilder<double>(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(begin: 0, end: fitPercentage! / 100),
                    builder: (context, value, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: value,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                fitPercentage! > 90
                                    ? Colors.green.shade600
                                    : fitPercentage! > 70
                                        ? Colors.blue.shade600
                                        : Colors.orange.shade600,
                              ),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
