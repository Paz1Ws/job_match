import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/core/domain/models/company_model.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/presentation/screens/jobs/job_apply_dialog.dart';
import 'package:job_match/presentation/widgets/auth/profile_display_elements.dart';
import 'package:job_match/presentation/widgets/auth/related_job_card.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:intl/intl.dart';
import 'package:job_match/core/data/job_match.dart'; // Import for matchResultProvider
import 'package:job_match/core/domain/models/match_result_model.dart'; // Import MatchResult model
import 'package:job_match/presentation/widgets/jobs/match_explanation_card.dart'; // Import the new card
import 'package:job_match/core/data/auth_request.dart'; // For candidateProfileProvider

class JobDetailScreen extends ConsumerWidget {
  final Job job;
  final int? fitScore; // Optional: can be pre-passed from SimpleJobCard
  final MatchResult? matchResult;
  final Company? company; // Optional: can be pre-passed from SimpleJobCard

  const JobDetailScreen({
    super.key,
    required this.job,
    this.fitScore,
    this.matchResult,
    this.company,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use real job data from model
    final String jobTitle =
        job.title.isNotEmpty ? job.title : 'Puesto sin título';
    final String companyName =
        job.companyName.isNotEmpty ? job.companyName : 'Empresa';
    final String jobLocation =
        job.location.isNotEmpty ? job.location : 'Lima, Perú';
    final String jobType = job.type.isNotEmpty ? job.type : 'Tiempo Completo';
    final String jobSalaryMin =
        job.salaryMin.isNotEmpty ? job.salaryMin : 'No especificado';
    final String jobSalaryMax =
        job.salaryMax.isNotEmpty ? job.salaryMax : 'No especificado';
    final String jobSalary =
        jobSalaryMin == jobSalaryMax
            ? jobSalaryMin
            : '$jobSalaryMin - $jobSalaryMax';
    final String jobModality =
        job.modality.isNotEmpty ? job.modality : 'Presencial';
    final String jobDescription =
        job.description.isNotEmpty
            ? job.description
            : 'Descripción del trabajo no disponible.';

    final candidateId = ref.watch(candidateProfileProvider)?.userId;
    final AsyncValue<MatchResult?> matchResultAsync =
        (candidateId != null && candidateId.isNotEmpty && job.id.isNotEmpty)
            ? ref.watch(
              matchResultProvider(
                MatchRequestParams(
                  candidateId: candidateId,
                  jobOfferId: job.id,
                ),
              ),
            )
            : AsyncData(
              matchResult,
            ); // Use pre-passed if available and no live fetch

    final currentMatchResult = matchResultAsync.asData?.value;
    final currentFitScore = currentMatchResult?.fitScore ?? fitScore ?? 0;
    final bool isLoadingMatch = matchResultAsync.isLoading;

    final Color fitColor =
        currentFitScore >= 75
            ? Colors.green.shade700
            : currentFitScore >= 50
            ? Colors.orange.shade700
            : Colors.red.shade700;

    final relatedJobsAsync = ref.watch(jobsProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blue),
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
                    // Company Logo and Title Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left part: Logo and Company Info
                        Expanded(
                          flex: 3,
                          child: Row(
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
                                    (job.companyId != null &&
                                            job.companyId!.isNotEmpty)
                                        ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.network(
                                            company != null &&
                                                    company!.logo != null
                                                ? company!.logo!
                                                : '',
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(
                                                      Icons.business,
                                                      color: Colors.white,
                                                      size: 40,
                                                    ),
                                          ),
                                        )
                                        : Icon(
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
                                        Expanded(
                                          child: Text(
                                            jobLocation,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Add Match Explanation Card here (below company info)
                    const SizedBox(height: kSpacing12),
                    MatchExplanationCard(
                      fitScore: currentFitScore,
                      matchResult: currentMatchResult,
                      isLoading: isLoadingMatch,
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
                        _buildTag(
                          '$currentFitScore% Match',
                          color: fitColor.withOpacity(0.1),
                          textColor: fitColor,
                        ),
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
                length: 2, // Changed from 3 to 2 (removed Company tab)
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      tabs: [Tab(text: 'Descripción'), Tab(text: 'Detalles')],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 300,
                      child: TabBarView(
                        children: [
                          // Description Tab - Using real job description
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
                                    jobDescription,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  if (job.requiredSkills != null &&
                                      job.requiredSkills!.isNotEmpty) ...[
                                    const Text(
                                      'Habilidades Requeridas',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    _buildBulletPoints(job.requiredSkills!),
                                  ],
                                ],
                              ),
                            ),
                          ),

                          // Details Tab - Using real job details
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
                                  _buildDetailItem('Modalidad', jobModality),
                                  _buildDetailItem('Ubicación', jobLocation),
                                  _buildDetailItem('Salario', jobSalary),
                                  if (job.createdAt != null)
                                    _buildDetailItem(
                                      'Fecha de Publicación',
                                      _formatDate(job.createdAt!),
                                    ),
                                  if (job.applicationDeadline != null)
                                    _buildDetailItem(
                                      'Fecha límite',
                                      _formatDate(job.applicationDeadline!),
                                    ),
                                  if (job.maxApplications != null)
                                    _buildDetailItem(
                                      'Máximo de aplicaciones',
                                      job.maxApplications.toString(),
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
                              .where(
                                (j) => j.id != job.id,
                              ) // Filter out the current job
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

                      // Use Job model instead of raw Map data
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: relatedJobs.length,
                        itemBuilder: (context, index) {
                          final relatedJob =
                              relatedJobs[index]; // This is already a Job model
                          return FadeInUp(
                            delay: Duration(milliseconds: 200 * index),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: RelatedJobCard(
                                job: relatedJob, // Pass the Job model directly
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
  Widget _buildTag(String text, {Color? color, Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color ?? Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (textColor ?? Colors.blue.shade800).withOpacity(0.3),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.blue.shade800,
          fontSize: 13,
        ),
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
