import 'package:flutter/material.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/presentation/screens/jobs/job_detail_screen.dart';

class RelatedJobCard extends StatelessWidget {
  final Job job;

  const RelatedJobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegar a JobDetailScreen al hacer tap en la tarjeta
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => JobDetailScreen(job: job),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(kPadding20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            kRadius12 + kRadius4 / 2,
          ), // kRadius14
          border: Border.all(color: Colors.grey.shade200, width: kStroke1 * 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.07),
              spreadRadius: kSpacing4 / 4, // 1
              blurRadius: kSpacing8,
              offset: const Offset(0, kSpacing4 / 2), // Offset(0,2)
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: kRadius40 + kSpacing4, // 44
                  height: kRadius40 + kSpacing4, // 44
                  decoration: BoxDecoration(
                    color: job.logoBackgroundColor,
                    borderRadius: BorderRadius.circular(
                      kRadius8 + kRadius4 / 2,
                    ), // kRadius10
                  ),
                  child:
                      job.logoAsset.startsWith('assets/')
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                              kRadius8 + kRadius4 / 2,
                            ), // kRadius10
                            child: Image.asset(job.logoAsset, fit: BoxFit.cover),
                          )
                          : Icon(
                            Icons.business,
                            color: Colors.white,
                            size: kIconSize24 + kSpacing4 / 2,
                          ), // kIconSize26
                ),
                const SizedBox(width: kSpacing12 + kSpacing4 / 2), // kSpacing14
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.companyName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0, // Font size kept
                          color: Color(0xFF222B45),
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: kSpacing4 / 2), // kSpacing2
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFFB1B5C3),
                            size: kIconSize12 + kSpacing4 / 4,
                          ), // kIconSize13
                          const SizedBox(width: kSpacing4),
                          Text(
                            job.location,
                            style: const TextStyle(
                              color: Color(0xFFB1B5C3),
                              fontSize: 12.0, // Font size kept
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
                    ), // vertical 3
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE6EC),
                      borderRadius: BorderRadius.circular(kRadius4),
                    ),
                    child: const Text(
                      'Destacado',
                      style: TextStyle(
                        color: Color(0xFFFD346E),
                        fontSize: 10.0, // Font size kept
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: kSpacing12 + kSpacing8 / 2 + kSpacing4 / 2,
            ), // kSpacing18
            Text(
              job.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0, // Font size kept
                color: Color(0xFF222B45),
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: kSpacing8 + kSpacing4 / 2), // kSpacing10
            Text(
              '${job.type} • ${job.salary}',
              style: const TextStyle(
                color: Color(0xFFB1B5C3),
                fontSize: 13.0, // Font size kept
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
