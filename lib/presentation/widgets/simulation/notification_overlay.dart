import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/config/constants/layer_constants.dart';

class NotificationOverlay extends StatefulWidget {
  final String message;
  final int? fitPercentage;
  final VoidCallback onDismiss;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;

  const NotificationOverlay({
    super.key,
    required this.message,
    this.fitPercentage,
    required this.onDismiss,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
    this.icon = Icons.notifications_active,
  });

  @override
  State<NotificationOverlay> createState() => NotificationOverlayState();
}

class NotificationOverlayState extends State<NotificationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(widget.icon, color: widget.textColor),
                      const SizedBox(width: 8),
                      Text(
                        'Actualización de Trabajo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: widget.textColor,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 18,
                          color: widget.textColor.withOpacity(0.7),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          // First run dismissal animation
                          _controller.reverse().then((_) {
                            widget.onDismiss();
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.message,
                    style: TextStyle(color: widget.textColor.withOpacity(0.9)),
                  ),
                  if (widget.fitPercentage != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          '${widget.fitPercentage}% Match',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getMatchColor(widget.fitPercentage!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(
                        begin: 0,
                        end: widget.fitPercentage! / 100,
                      ),
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
                                  _getMatchColor(widget.fitPercentage!),
                                ),
                                minHeight: 8,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // First run dismissal animation
                          _controller.reverse().then((_) {
                            widget.onDismiss();
                          });
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(
                            color: widget.textColor,
                            fontWeight: FontWeight.bold,
                          ),
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

  Color _getMatchColor(int percentage) {
    if (percentage > 90) return Colors.green.shade600;
    if (percentage > 70) return Colors.blue.shade600;
    if (percentage > 50) return Colors.orange.shade600;
    return Colors.red.shade600;
  }
}

// Helper to show job notifications with proper styling based on type
class JobNotificationHelper {
  static showJobNotification(
    BuildContext context, {
    required String message,
    Color backgroundColor = Colors.white,
    Color textColor = Colors.black87,
    IconData icon = Icons.notifications_active,
    int? fitPercentage,
  }) {
    final overlay = Overlay.of(context);

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder:
          (context) => NotificationOverlay(
            message: message,
            backgroundColor: backgroundColor,
            textColor: textColor,
            icon: icon,
            fitPercentage: fitPercentage,
            onDismiss: () {
              entry.remove();
            },
          ),
    );

    overlay.insert(entry);

    // Auto-dismiss after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (entry.mounted) {
        entry.remove();
      }
    });
  }

  // Specific notification types
  static showJobCreated(BuildContext context, String jobTitle) {
    showJobNotification(
      context,
      message: 'Nuevo trabajo publicado: $jobTitle',
      backgroundColor: Colors.green.shade50,
      textColor: Colors.green.shade900,
      icon: Icons.work_outline,
    );
  }

  static showJobUpdated(
    BuildContext context,
    String jobTitle,
    String updateType,
  ) {
    showJobNotification(
      context,
      message: 'Trabajo actualizado: $jobTitle ($updateType)',
      backgroundColor: Colors.blue.shade50,
      textColor: Colors.blue.shade900,
      icon: Icons.edit_outlined,
    );
  }

  static showJobDeadlineReached(BuildContext context, String jobTitle) {
    showJobNotification(
      context,
      message: 'Fecha límite alcanzada: $jobTitle',
      backgroundColor: Colors.orange.shade50,
      textColor: Colors.orange.shade900,
      icon: Icons.timer_off_outlined,
    );
  }

  static showJobDeleted(BuildContext context, String jobTitle) {
    showJobNotification(
      context,
      message: 'Trabajo eliminado: $jobTitle',
      backgroundColor: Colors.red.shade50,
      textColor: Colors.red.shade900,
      icon: Icons.delete_outline,
    );
  }

  static showJobStatusChanged(
    BuildContext context,
    String jobTitle,
    String newStatus,
  ) {
    Color bgColor, textColor;
    IconData statusIcon;

    switch (newStatus.toLowerCase()) {
      case 'open':
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade900;
        statusIcon = Icons.check_circle_outline;
        break;
      case 'closed':
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade900;
        statusIcon = Icons.cancel_outlined;
        break;
      case 'paused':
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue.shade900;
        statusIcon = Icons.pause_circle_outline;
        break;
      default:
        bgColor = Colors.grey.shade50;
        textColor = Colors.grey.shade900;
        statusIcon = Icons.help_outline;
    }

    showJobNotification(
      context,
      message: '$jobTitle cambió a: ${newStatus.toUpperCase()}',
      backgroundColor: bgColor,
      textColor: textColor,
      icon: statusIcon,
    );
  }
}
