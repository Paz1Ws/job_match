import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/config/constants/layer_constants.dart';

class RelatedJobCard extends StatefulWidget {
  final Job job;

  const RelatedJobCard({super.key, required this.job});

  @override
  State<RelatedJobCard> createState() => _RelatedJobCardState();
}

class _RelatedJobCardState extends State<RelatedJobCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: _isHovered ? (Matrix4.identity()..scale(1.01)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kRadius12 + kRadius4 / 2),
          border: Border.all(color: Colors.grey.shade100, width: kStroke1 * 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(_isHovered ? 0.4 : 0.07),
              spreadRadius: kSpacing4 / 4,
              blurRadius: kSpacing8,
              offset: const Offset(0, kSpacing4 / 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(kRadius12 + kRadius4 / 2),
          child: InkWell(
            onTap: () => context.go('/job-details', extra: job),
            borderRadius: BorderRadius.circular(kRadius12 + kRadius4 / 2),
            child: Padding(
              padding: const EdgeInsets.all(kPadding20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: kRadius40 + kSpacing4,
                        height: kRadius40 + kSpacing4,
                        decoration: BoxDecoration(
                          color: job.logoBackgroundColor,
                          borderRadius: BorderRadius.circular(kRadius8 + kRadius4 / 2),
                        ),
                        child: job.logoAsset.startsWith('assets/')
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(kRadius8 + kRadius4 / 2),
                                child: Image.asset(job.logoAsset, fit: BoxFit.cover),
                              )
                            : Icon(
                                Icons.business,
                                color: Colors.white,
                                size: kIconSize24 + kSpacing4 / 2,
                              ),
                      ),
                      const SizedBox(width: kSpacing12 + kSpacing4 / 2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.companyName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                                color: Color(0xFF222B45),
                                letterSpacing: 0.1,
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
                                Text(
                                  job.location,
                                  style: const TextStyle(
                                    color: Color(0xFFB1B5C3),
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (job.isFeatured)
                        Container(
                          margin: const EdgeInsets.only(left: kSpacing4),
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
                    ],
                  ),
                  const SizedBox(height: kSpacing12 + kSpacing8 / 2 + kSpacing4 / 2),
                  Text(
                    job.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Color(0xFF222B45),
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: kSpacing8 + kSpacing4 / 2),
                  Text(
                    '${job.type} • ${job.salary}',
                    style: const TextStyle(
                      color: Color(0xFFB1B5C3),
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}