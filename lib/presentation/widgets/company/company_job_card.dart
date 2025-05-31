import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/config/util/animations.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/core/domain/models/company_model.dart'; // Add this import
import 'package:job_match/presentation/screens/company/company_job_detail_screen.dart';

class CompanyJobCard extends ConsumerWidget {
  final Job job;
  final Company? company; // Add company parameter

  const CompanyJobCard({super.key, required this.job, this.company});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    page: CompanyJobDetailScreen(job: job),
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
                          company != null &&
                                  company!.logo != null &&
                                  company!.logo!.isNotEmpty
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(kRadius8),
                                child: Image.network(
                                  company!.logo!,
                                  fit: BoxFit.contain,
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
                        // Status indicator (Published/Draft)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kPadding8,
                            vertical: kSpacing4 / 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(kRadius4),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Text(
                            'Publicado',
                            style: TextStyle(
                              color: Colors.green.shade700,
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
}
