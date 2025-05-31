import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/config/util/animations.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/core/domain/models/company_model.dart'; // Add this import
import 'package:job_match/presentation/screens/jobs/job_detail_screen.dart';
import 'package:job_match/presentation/screens/company/company_job_detail_screen.dart';
import 'package:job_match/core/data/job_match.dart';
import 'package:job_match/presentation/widgets/auth/app_identity_bar.dart';

class SimpleJobCard extends ConsumerWidget {
  final Job job;
  final Company? company; // Add company parameter

  const SimpleJobCard({super.key, required this.job, this.company});

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

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Stack(
        children: [
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kRadius12),
              side: BorderSide(color: Colors.grey.shade200, width: 0.8),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(kRadius12),
              onTap: () {
                // Use different detail screen based on user type
                if (isCandidate) {
                  Navigator.of(context).push(
                    ParallaxSlidePageRoute(
                      page: JobDetailScreen(
                        job: job,
                        fitScore: fitPercentage,
                        matchResult: matchResultAsync?.asData?.value,
                      ),
                    ),
                  );
                } else {
                  // For companies, use the company job detail screen
                  Navigator.of(context).push(
                    ParallaxSlidePageRoute(
                      page: CompanyJobDetailScreen(job: job),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(kPadding16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: kRadius40 + kSpacing8,
                      height: kRadius40 + kSpacing8,
                      decoration: BoxDecoration(
                        color: job.logoBackgroundColor ?? Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(kRadius8),
                      ),
                      child:
                          company != null &&
                                  company!.logo != null &&
                                  company!.logo!.isNotEmpty
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(kRadius8),
                                child: Image.network(
                                  company!.logo!,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) => Icon(
                                        Icons.business,
                                        color: Colors.grey.shade600,
                                        size: kIconSize24,
                                      ),
                                ),
                              )
                              : Icon(
                                Icons.business,
                                color: Colors.grey.shade600,
                                size: kIconSize24,
                              ),
                    ),
                    const SizedBox(width: kSpacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Color(0xFF222B45),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: kSpacing4 / 2),
                          Text(
                            job.companyName,
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: kSpacing8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: kSpacing4 / 2),
                              Expanded(
                                child: Text(
                                  job.location,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: kSpacing4),
                          Text(
                            job.type,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: kSpacing8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Only show fit percentage for candidates
                        if (isCandidate)
                          isLoadingMatch
                              ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.grey.shade400,
                                ),
                              )
                              : Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: kPadding8,
                                  vertical: kSpacing4 / 2,
                                ),
                                decoration: BoxDecoration(
                                  color: fitColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(kRadius4),
                                  border: Border.all(
                                    color: fitColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.insights,
                                      color: fitColor,
                                      size: 12,
                                    ),
                                    const SizedBox(width: kSpacing4),
                                    Text(
                                      '$fitPercentage% Fit',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11.0,
                                        color: fitColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kPadding8,
                              vertical: kSpacing4 / 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                job.status,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(kRadius4),
                              border: Border.all(
                                color: _getStatusColor(
                                  job.status,
                                ).withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              _getDisplayStatus(job.status),
                              style: TextStyle(
                                color: _getStatusColor(job.status),
                                fontSize: 11.0,
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
        ],
      ),
    );
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
        return status; // Return original if unknown
    }
  }
}
