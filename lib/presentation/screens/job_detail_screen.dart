import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';

class JobDetailScreen extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job['title'] ?? 'Detalle del Empleo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['title'] ?? 'Título no disponible',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          job['location'] ?? 'Ubicación no especificada',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.work, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          _getJobTypeLabel(job['job_type']),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    if (job['salary_min'] != null ||
                        job['salary_max'] != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.attach_money,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getSalaryRange(),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Job Description
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Descripción del Puesto',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      job['description'] ?? 'Descripción no disponible',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Required Skills
            if (job['required_skills'] != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Habilidades Requeridas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            (job['required_skills'] as List)
                                .map(
                                  (skill) => Chip(
                                    label: Text(skill.toString()),
                                    backgroundColor: Colors.blue.shade50,
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Job Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detalles del Empleo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Estado', _getStatusLabel(job['status'])),
                    if (job['application_deadline'] != null)
                      _buildDetailRow(
                        'Fecha límite',
                        _formatDate(job['application_deadline']),
                      ),
                    if (job['max_applications'] != null)
                      _buildDetailRow(
                        'Máximo de postulaciones',
                        job['max_applications'].toString(),
                      ),
                    if (job['created_at'] != null)
                      _buildDetailRow(
                        'Fecha de publicación',
                        _formatDate(job['created_at']),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Apply Button (if needed)
            SizedBox(
              width: double.infinity,
              child: Consumer(
                builder: (_, ref, __) {
                  return ElevatedButton(
                    onPressed:
                        job['status'] == 'open'
                            ? () async {
                              //* Handle job application
                              final applyJob = ref.read(applyToJobProvider);
                              await applyJob(job['id']);

                              if(!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Se ha aplicado al trabajo',
                                  ),
                                ),
                              );
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      job['status'] == 'open'
                          ? 'Postular a este empleo'
                          : 'Empleo cerrado',
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _getJobTypeLabel(String? jobType) {
    switch (jobType) {
      case 'full-time':
        return 'Tiempo Completo';
      case 'part-time':
        return 'Medio Tiempo';
      case 'contract':
        return 'Contrato';
      case 'freelance':
        return 'Freelance';
      default:
        return 'No especificado';
    }
  }

  String _getStatusLabel(String? status) {
    switch (status) {
      case 'open':
        return 'Abierto';
      case 'paused':
        return 'Pausado';
      case 'closed':
        return 'Cerrado';
      default:
        return 'No especificado';
    }
  }

  String _getSalaryRange() {
    final min = job['salary_min'];
    final max = job['salary_max'];

    if (min != null && max != null) {
      return 'S/ ${min.toString()} - S/ ${max.toString()}';
    } else if (min != null) {
      return 'Desde S/ ${min.toString()}';
    } else if (max != null) {
      return 'Hasta S/ ${max.toString()}';
    } else {
      return 'Salario no especificado';
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'No especificada';

    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return 'Fecha inválida';
    }
  }
}
