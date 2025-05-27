import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/presentation/screens/auth/widgets/info_card.dart';
import 'package:job_match/presentation/screens/auth/widgets/left_cut_trapezoid_clipper.dart';

class RightSingUpImageInformation extends ConsumerWidget {
  const RightSingUpImageInformation({
    super.key,
    required this.isWide,
    required this.isMedium,
  });

  final bool isWide;
  final bool isMedium;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            ClipPath(
              clipper: LeftCutTrapezoidClipper(),
              child: Image.asset(
                'assets/images/login_background.png',

                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(isWide ? 60.0 : 24.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText(
                                ref
                                    .watch(companiesCountProvider)
                                    .when(
                                      data: (data) => '+$data empresas',
                                      error:
                                          (error, stackTrace) => '0 empresas',
                                      loading: () => '-',
                                    ),
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      isWide ? 48.0 : (isMedium ? 32.0 : 22.0),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                                speed: const Duration(milliseconds: 100),
                              ),
                            ],
                            totalRepeatCount: 1,
                            displayFullTextOnTap: true,
                            stopPauseOnTap: true,
                          ),
                          AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText(
                                ref
                                    .watch(candidatesCountProvider)
                                    .when(
                                      data: (data) => '+$data candidatos',
                                      error:
                                          (error, stackTrace) => '0 candidatos',
                                      loading: () => '-',
                                    ),
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      isWide ? 48.0 : (isMedium ? 32.0 : 22.0),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                                speed: const Duration(milliseconds: 100),
                              ),
                            ],
                            totalRepeatCount: 1,
                            displayFullTextOnTap: true,
                            stopPauseOnTap: true,
                          ),

                          Text(
                            'Esperando el match perfecto.',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  isWide ? 48.0 : (isMedium ? 32.0 : 22.0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isWide ? 60 : 24),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfoCard(
                            title: ref
                                .watch(jobsCountProvider)
                                .when(
                                  data: (data) => data.toString(),
                                  error: (error, stackTrace) => '0',
                                  loading: () => '-',
                                ),
                            subtitle: 'Empleos Activos',
                            icon: Icon(
                              Icons.work_outline,
                              color: Colors.white,
                              size: isWide ? 42 : 32,
                            ),
                          ),
                          const Spacer(),
                          InfoCard(
                            title: ref
                                .watch(companiesCountProvider)
                                .when(
                                  data: (data) => data.toString(),
                                  error: (error, stackTrace) => '0',
                                  loading: () => '-',
                                ),
                            subtitle: 'Empresas',
                            icon: Icon(
                              Icons.location_city,
                              color: Colors.white,
                              size: isWide ? 42 : 32,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Spacer(),
                          InfoCard(
                            title: ref
                                .watch(candidatesCountProvider)
                                .when(
                                  data: (data) => data.toString(),
                                  error: (error, stackTrace) => '0',
                                  loading: () => '-',
                                ),
                            subtitle: 'Nuevos Empleos',
                            icon: Icon(
                              Icons.work_outline,
                              color: Colors.white,
                              size: isWide ? 42 : 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
