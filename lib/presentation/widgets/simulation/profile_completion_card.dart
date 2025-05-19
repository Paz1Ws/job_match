import 'package:flutter/material.dart';

class ProfileCompletionCard extends StatelessWidget {
  final double completionPercentage;
  final VoidCallback onAddProject;
  final VoidCallback onAddCertificate;

  const ProfileCompletionCard({
    super.key,
    required this.completionPercentage,
    required this.onAddProject,
    required this.onAddCertificate,
  });

  Color _getColorForPercentage() {
    if (completionPercentage < 60) return Colors.red.shade700;
    if (completionPercentage < 85) return Colors.orange.shade700;
    return Colors.green.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> suggestedActions = [
      if (completionPercentage < 100)
        {
          'icon': Icons.folder_open,
          'label': 'Añadir proyecto',
          'action': onAddProject,
        },
      if (completionPercentage < 100)
        {
          'icon': Icons.verified,
          'label': 'Añadir certificado',
          'action': onAddCertificate,
        },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Completa tu Perfil',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: completionPercentage / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getColorForPercentage(),
              ),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              'Completado: ${completionPercentage.toInt()}%',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (completionPercentage < 100) ...[
              const SizedBox(height: 16),
              const Text(
                'Acciones sugeridas:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              ...suggestedActions.map((action) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(
                      action['icon'] as IconData,
                      color: Colors.blue.shade700,
                      size: 20,
                    ),
                  ),
                  title: Text(action['label'] as String),
                  trailing: ElevatedButton(
                    onPressed: action['action'] as VoidCallback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade50,
                      foregroundColor: Colors.blue.shade700,
                      elevation: 0,
                    ),
                    child: const Text('Añadir'),
                  ),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                );
              }),
            ] else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green.shade50,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green.shade700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '¡Excelente! Has completado tu perfil al 100%',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
