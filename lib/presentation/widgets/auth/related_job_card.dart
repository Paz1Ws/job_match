import 'package:flutter/material.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/presentation/screens/jobs/job_detail_screen.dart';
import 'package:job_match/config/util/animations.dart';
import 'package:animate_do/animate_do.dart';

class RelatedJobCard extends StatelessWidget {
  final Job job;
  final bool showBackButton;

  const RelatedJobCard({
    super.key,
    required this.job,
    this.showBackButton = false,
  });

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
      duration: const Duration(milliseconds: 600),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(
                context,
              ).push(ParallaxSlidePageRoute(page: JobDetailScreen(job: job)));
            },
            child: Container(
              padding: const EdgeInsets.all(kPadding20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kRadius12 + kRadius4 / 2),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: kStroke1 * 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.07),
                    spreadRadius: kSpacing4 / 4,
                    blurRadius: kSpacing8,
                    offset: const Offset(0, kSpacing4 / 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BounceIn(
                        duration: const Duration(milliseconds: 700),
                        child: Container(
                          width: kRadius40 + kSpacing4,
                          height: kRadius40 + kSpacing4,
                          decoration: BoxDecoration(
                            color: job.logoBackgroundColor,
                            borderRadius: BorderRadius.circular(
                              kRadius8 + kRadius4 / 2,
                            ),
                          ),
                          child:
                              job.logoAsset.startsWith('assets/')
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      kRadius8 + kRadius4 / 2,
                                    ),
                                    child: Image.asset(
                                      job.logoAsset,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : Icon(
                                    Icons.business,
                                    color: Colors.white,
                                    size: kIconSize24 + kSpacing4 / 2,
                                  ),
                        ),
                      ),
                      const SizedBox(width: kSpacing12 + kSpacing4 / 2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeInLeft(
                              duration: const Duration(milliseconds: 500),
                              child: Text(
                                job.companyName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0,
                                  color: Color(0xFF222B45),
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                            const SizedBox(height: kSpacing4 / 2),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color(0xFFB1B5C3),
                                  size: kIconSize12 + kSpacing4 / 4,
                                ),
                                const SizedBox(width: kSpacing4),
                                FadeInLeft(
                                  delay: const Duration(milliseconds: 100),
                                  duration: const Duration(milliseconds: 400),
                                  child: Text(
                                    job.location,
                                    style: const TextStyle(
                                      color: Color(0xFFB1B5C3),
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (job.isFeatured)
                            FadeIn(
                              delay: const Duration(milliseconds: 200),
                              duration: const Duration(milliseconds: 400),
                              child: Container(
                                margin: const EdgeInsets.only(
                                  bottom: kSpacing4,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: kPadding8,
                                  vertical: kSpacing4 / 2 + kSpacing4 / 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE6EC),
                                  borderRadius: BorderRadius.circular(kRadius4),
                                ),
                                child: const Text(
                                  'Destacado',
                                  style: TextStyle(
                                    color: Color(0xFFFD346E),
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ),
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
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: kSpacing12 + kSpacing8 / 2 + kSpacing4 / 2,
                  ),
                  FadeInDown(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      job.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Color(0xFF222B45),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: kSpacing8 + kSpacing4 / 2),
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      '${job.type} • ${job.salary}',
                      style: const TextStyle(
                        color: Color(0xFFB1B5C3),
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showBackButton)
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.blue,
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).maybePop(),
                tooltip: 'Atrás',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
        ],
      ),
    );
  }
}
