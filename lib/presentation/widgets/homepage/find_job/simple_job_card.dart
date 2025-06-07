import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/config/util/animations.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/core/domain/models/company_model.dart';
import 'package:job_match/presentation/screens/jobs/job_detail_screen.dart';
import 'package:job_match/presentation/screens/company/company_job_detail_screen.dart';
import 'package:job_match/core/data/job_match.dart';
import 'package:job_match/core/data/jobs_listener.dart';
import 'package:job_match/presentation/widgets/auth/app_identity_bar.dart';
import 'package:job_match/presentation/screens/homepage/find_jobs_screen.dart';

class SimpleJobCard extends ConsumerWidget {
  final Job job;
  final Company? company;
  final bool skipAnimation;

  const SimpleJobCard({
    super.key,
    required this.job,
    this.company,
    this.skipAnimation = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if user is a candidate or a company
    final isCandidate = ref.watch(isCandidateProvider);

    // Only fetch match result for candidates
    final candidateId =
        isCandidate ? ref.watch(candidateProfileProvider)?.userId : null;
    final matchResultAsync =
        (isCandidate &&
                candidateId != null &&
                candidateId.isNotEmpty &&
                job.id.isNotEmpty)
            ? ref.watch(
              matchResultProvider(
                MatchRequestParams(
                  candidateId: candidateId,
                  jobOfferId: job.id,
                ),
              ),
            )
            : null;

    final int fitPercentage = matchResultAsync?.asData?.value?.fitScore ?? 0;
    final bool isLoadingMatch = matchResultAsync?.isLoading ?? false;

    final Color fitColor =
        fitPercentage >= 75
            ? Colors.green.shade700
            : fitPercentage >= 50
            ? Colors.orange.shade700
            : Colors.red.shade700;

    // Check if job is available for application
    final bool isAvailable = JobUtils.isJobApplicationAvailable(job);

    // Check if job is expired (passed deadline)
    final bool isExpired = JobUtils.isJobExpired(job);

    // Main widget content without animation wrapper
    Widget cardContent = Stack(
      children: [
        Card(
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200, width: 0.8),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: ColorFiltered(
            // Apply grayscale filter for unavailable jobs
            colorFilter:
                !isAvailable
                    ? const ColorFilter.matrix([
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0,
                      0,
                      0,
                      1,
                      0,
                    ])
                    : const ColorFilter.mode(
                      Colors.transparent,
                      BlendMode.saturation,
                    ),
            child: InkWell(
              onTap: () {
                if (isCandidate) {
                  Navigator.of(context).push(
                    FadeThroughPageRoute(
                      page: JobDetailScreen(
                        job: job,
                        fitScore: fitPercentage,
                        matchResult: matchResultAsync?.asData?.value,
                        company: company,
                      ),
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                    FadeThroughPageRoute(
                      page: CompanyJobDetailScreen(job: job),
                    ),
                  );
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company and title row
                    Row(
                      children: [
                        // Company logo placeholder
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: job.logoBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              job.companyId != null &&
                                      job.companyId!.isNotEmpty &&
                                      company?.logo != null &&
                                      company!.logo!.isNotEmpty
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      company!.logo!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.business,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                    ),
                                  )
                                  : const Icon(
                                    Icons.business,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job.companyName,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                job.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Job details
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            job.location,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.work_outline,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          job.type,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Salary range
                    if (job.salaryMin.isNotEmpty || job.salaryMax.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            job.salaryMin == job.salaryMax
                                ? job.salaryMin
                                : '${job.salaryMin} - ${job.salaryMax}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),

                    // Match percentage and apply button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (isCandidate) ...[
                          if (isLoadingMatch)
                            Row(
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Calculando...',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: fitColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$fitPercentage% Match',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: fitColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ] else
                          const SizedBox(),
                        if (isAvailable)
                          ElevatedButton(
                            onPressed: () {
                              if (isCandidate) {
                                Navigator.of(context).push(
                                  FadeThroughPageRoute(
                                    page: JobDetailScreen(
                                      job: job,
                                      fitScore: fitPercentage,
                                      matchResult:
                                          matchResultAsync?.asData?.value,
                                      company: company,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(
                                  FadeThroughPageRoute(
                                    page: CompanyJobDetailScreen(job: job),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text(
                              isCandidate ? 'Aplicar' : 'Ver detalles',
                              style: const TextStyle(fontSize: 12),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isExpired ? 'Expirado' : 'No disponible',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
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

        // Status indicator
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(job.status),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_getStatusIcon(job.status), size: 12, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  _getDisplayStatus(job.status),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    // Return the card content directly without animation wrapper
    return cardContent;
  }

  // Helper method to determine color based on job status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.green.shade700;
      case 'closed':
        return Colors.red.shade700;
      case 'paused':
        return Colors.blue.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  // Helper method to translate status to Spanish for display
  String _getDisplayStatus(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return 'Abierto';
      case 'closed':
        return 'Cerrado';
      case 'paused':
        return 'Pausado';
      default:
        return 'Desconocido';
    }
  }

  // Add status icon method
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Icons.check_circle_outline;
      case 'closed':
        return Icons.cancel_outlined;
      case 'paused':
        return Icons.pause_circle_outline;
      default:
        return Icons.help_outline;
    }
  }
}
