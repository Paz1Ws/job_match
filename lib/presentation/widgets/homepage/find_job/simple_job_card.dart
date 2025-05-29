import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/config/util/animations.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/presentation/screens/jobs/job_detail_screen.dart';
import 'package:job_match/core/data/job_match.dart'; // Import for matchResultProvider

class SimpleJobCard extends ConsumerWidget {
  final Job job;

  const SimpleJobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidateId = ref.watch(candidateProfileProvider)?.userId;
    final matchResultAsync =
        (candidateId != null && candidateId.isNotEmpty && job.id.isNotEmpty)
            ? ref.watch(
              matchResultProvider(
                MatchRequestParams(
                  candidateId: candidateId,
                  jobOfferId: job.id,
                ),
              ),
            )
            : null;

    final int fitPercentage =
        matchResultAsync?.asData?.value?.fitScore ??
        0; // Default to 0 if no data
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
                Navigator.of(context).push(
                  ParallaxSlidePageRoute(
                    page: JobDetailScreen(
                      job: job,
                      fitScore: fitPercentage,
                      matchResult: matchResultAsync?.asData?.value,
                    ),
                  ),
                );
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
                          job.logoAsset.startsWith('assets/')
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(kRadius8),
                                child: Image.asset(
                                  job.logoAsset,
                                  fit: BoxFit.contain,
                                ),
                              )
                              : job.logoAsset.startsWith('http')
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(kRadius8),
                                child: Image.network(
                                  job.logoAsset,
                                  fit: BoxFit.contain,
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
                            ),
                        if (job.isFeatured) ...[
                          const SizedBox(height: kSpacing8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kPadding8,
                              vertical: kSpacing4 / 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(kRadius4),
                              border: Border.all(color: Colors.orange.shade200),
                            ),
                            child: Text(
                              'Destacado',
                              style: TextStyle(
                                color: Colors.orange.shade700,
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
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
}
