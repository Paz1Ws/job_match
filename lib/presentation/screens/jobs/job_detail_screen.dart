import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/presentation/screens/jobs/job_apply_dialog.dart';
import 'package:job_match/presentation/widgets/auth/profile_display_elements.dart';
import 'package:job_match/presentation/widgets/auth/related_job_card.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:intl/intl.dart';
import 'package:job_match/core/data/cv_parsing.dart'
    show generateRandomMatchPercentage; // Added import

class JobDetailScreen extends ConsumerWidget {
  final Job job;
  final String fit;

  const JobDetailScreen({super.key, required this.job, required this.fit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use job data with fallbacks for null values
    final String jobTitle =
        job.title.isNotEmpty ? job.title : 'Puesto sin título';
    final String companyName =
        job.companyName.isNotEmpty ? job.companyName : 'Empresa';
    final String jobLocation =
        job.location.isNotEmpty ? job.location : 'Lima, Perú';
    final String jobType = job.type.isNotEmpty ? job.type : 'Tiempo Completo';
    final String jobSalary =
        job.salary.isNotEmpty ? job.salary : 'Salario no especificado';

    // Fetch related jobs data
    final relatedJobsAsync = ref.watch(jobsProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blue),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Compartir trabajo')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Trabajo guardado')));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: FadeInLeft(
                duration: const Duration(milliseconds: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company Logo and Title
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: job.logoBackgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                              job.logoAsset.startsWith('assets/')
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      job.logoAsset,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : job.logoAsset.startsWith('http')
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      job.logoAsset,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : const Icon(
                                    Icons.business,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                companyName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    jobLocation,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Job Title
                    Text(
                      jobTitle,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Job Tags
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildTag(jobType),
                        _buildTag(jobSalary),
                        _buildTag('$fit% Match'),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Apply Button
                    _buildApplyButton(context),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Job Tabs Section
            FadeInUp(
              duration: const Duration(milliseconds: 400),
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Descripción'),
                        Tab(text: 'Empresa'),
                        Tab(text: 'Detalles'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 300,
                      child: TabBarView(
                        children: [
                          // Description Tab
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Descripción del Empleo',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    // Use a default description if not available
                                    'Esta empresa está buscando profesionales talentosos para unirse a su equipo. '
                                    'El candidato ideal debe tener habilidades de comunicación efectivas, capacidad para '
                                    'trabajar en equipo y resolver problemas de manera creativa.',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Responsabilidades',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildBulletPoints([
                                    'Desarrollar y mantener aplicaciones de software',
                                    'Colaborar con equipos multidisciplinarios',
                                    'Implementar soluciones tecnológicas innovadoras',
                                    'Participar en reuniones de planificación y revisión',
                                  ]),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Requisitos',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildBulletPoints([
                                    'Experiencia de 2+ años en desarrollo de software',
                                    'Conocimiento sólido de arquitecturas modernas',
                                    'Habilidades de comunicación efectiva',
                                    'Capacidad para trabajar en equipo',
                                  ]),
                                ],
                              ),
                            ),
                          ),

                          // Company Tab
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Sobre la Empresa',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'Información sobre $companyName y su cultura, valores y misión empresarial. Esta empresa se dedica a proporcionar soluciones innovadoras en su sector.',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Cultura de la Empresa',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildBulletPoints([
                                    'Ambiente colaborativo y diverso',
                                    'Enfoque en innovación y crecimiento',
                                    'Valoramos el equilibrio trabajo-vida personal',
                                    'Oportunidades de desarrollo profesional',
                                  ]),
                                ],
                              ),
                            ),
                          ),

                          // Details Tab
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Detalles del Puesto',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  _buildDetailItem('Tipo de empleo', jobType),
                                  _buildDetailItem('Ubicación', jobLocation),
                                  _buildDetailItem('Salario', jobSalary),
                                  _buildDetailItem(
                                    'Fecha de Publicación',
                                    _formatDate(
                                      DateTime.now().subtract(
                                        const Duration(days: 3),
                                      ),
                                    ),
                                  ),
                                  _buildDetailItem(
                                    'Fecha límite',
                                    _formatDate(
                                      DateTime.now().add(
                                        const Duration(days: 27),
                                      ),
                                    ),
                                  ),
                                  _buildDetailItem(
                                    'Experiencia requerida',
                                    '2-5 años',
                                  ),
                                  _buildDetailItem(
                                    'Educación requerida',
                                    'Grado universitario',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Related Jobs Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Empleos Relacionados',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // List of related jobs
                  relatedJobsAsync.when(
                    loading:
                        () => const Center(child: CircularProgressIndicator()),
                    error:
                        (error, stack) => Center(child: Text('Error: $error')),
                    data: (jobs) {
                      // Filter out current job and limit to relevant related jobs
                      final relatedJobs =
                          jobs
                              .where((j) => j['title'].toString().isNotEmpty)
                              .take(3)
                              .toList();

                      if (relatedJobs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No hay trabajos relacionados disponibles',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      // Use existing RelatedJobCard but with real data
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: relatedJobs.length,
                        itemBuilder: (context, index) {
                          final relatedJob = relatedJobs[index];
                          return FadeInUp(
                            delay: Duration(milliseconds: 200 * index),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: RelatedJobCard(
                                job: Job(
                                  logoAsset:
                                      'assets/images/job_match.jpg', // Default
                                  companyName:
                                      relatedJob['company_name'] ?? 'Empresa',
                                  location:
                                      relatedJob['location'] ?? 'Lima, Perú',
                                  title:
                                      relatedJob['title'] ??
                                      'Puesto sin título',
                                  type:
                                      relatedJob['job_type'] ??
                                      'Tiempo Completo',
                                  salary:
                                      relatedJob['salary_min'] != null &&
                                              relatedJob['salary_max'] != null
                                          ? 'S/${relatedJob['salary_min']} - S/${relatedJob['salary_max']}'
                                          : 'Salario no especificado',
                                  isFeatured:
                                      relatedJob['is_featured'] ?? false,
                                  logoBackgroundColor: Colors.blue.shade100,
                                  matchPercentage:
                                      generateRandomMatchPercentage(), // Updated
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => _showApplyDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'APLICAR AHORA',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // Helper methods
  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.blue.shade800, fontSize: 13),
      ),
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showApplyDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'APLICAR AHORA',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward),
        ],
      ),
    );
  }

  Widget _buildBulletPoints(List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          points.map((point) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  void _showApplyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => JobApplyDialog(jobTitle: job.title, jobId: job.id),
    );
  }
}
