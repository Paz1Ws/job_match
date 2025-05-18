import 'package:flutter/material.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/presentation/screens/jobs/job_detail_screen.dart';
import 'package:job_match/config/util/animations.dart';
import 'package:animate_do/animate_do.dart';

class SimpleJobCard extends StatelessWidget {
  final Job job;

  const SimpleJobCard({super.key, required this.job});

  Widget _iconText(
    IconData icon,
    String text,
    BuildContext context, {
    Color? color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: kIconSize14,
          color:
              color ??
              Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
        ),
        const SizedBox(width: kSpacing4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color:
                  color ??
                  Theme.of(
                    context,
                  ).textTheme.bodySmall?.color?.withOpacity(0.9),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getFitColor(int percentage) {
    if (percentage >= 90) return Colors.green.shade700;
    if (percentage >= 75) return Colors.blue.shade700;
    if (percentage >= 60) return Colors.orange.shade700;
    return Colors.grey.shade700;
  }

  @override
  Widget build(BuildContext context) {
    Color fitColor = _getFitColor(job.matchPercentage);
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Stack(
        children: [
          Card(
            elevation: 1.5,
            margin: const EdgeInsets.only(
              bottom: kPadding16,
              left: kSpacing4,
              right: kSpacing4,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kRadius12),
              side: BorderSide(color: Colors.grey.shade200, width: 0.8),
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(
                  context,
                ).push(ParallaxSlidePageRoute(page: JobDetailScreen(job: job)));
              },
              borderRadius: BorderRadius.circular(kRadius12),
              child: Padding(
                padding: const EdgeInsets.all(kPadding16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: job.logoBackgroundColor,
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
                              : Icon(
                                Icons.business,
                                color: Colors.white,
                                size: kIconSize24,
                              ),
                    ),
                    const SizedBox(width: kPadding12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.5,
                              color: Color(0xFF222B45),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: kSpacing4 / 2),
                          Text(
                            job.companyName,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: kSpacing12),
                          Wrap(
                            spacing: kSpacing12 + kSpacing4,
                            runSpacing: kSpacing8,
                            children: [
                              FadeInLeft(
                                duration: const Duration(milliseconds: 400),
                                child: _iconText(
                                  Icons.attach_money,
                                  job.salary,
                                  context,
                                ),
                              ),
                              FadeInLeft(
                                delay: const Duration(milliseconds: 200),
                                duration: const Duration(milliseconds: 400),
                                child: _iconText(
                                  Icons.location_on_outlined,
                                  job.location,
                                  context,
                                ),
                              ),
                              FadeInLeft(
                                delay: const Duration(milliseconds: 300),
                                duration: const Duration(milliseconds: 400),
                                child: _iconText(
                                  Icons.access_time,
                                  job.type,
                                  context,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: kPadding8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kPadding8,
                            vertical: kSpacing4 / 2,
                          ),
                          decoration: BoxDecoration(
                            color: fitColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(kRadius8),
                            border: Border.all(
                              color: fitColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.analytics_outlined,
                                size: kIconSize14,
                                color: fitColor,
                              ),
                              const SizedBox(width: kSpacing4),
                              Text(
                                '${job.matchPercentage}% Fit',
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
