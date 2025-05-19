import 'package:flutter/material.dart';
import 'package:job_match/config/util/animations.dart';
import 'package:job_match/presentation/screens/auth/screens/login_screen.dart';
import 'package:job_match/presentation/widgets/homepage/find_job/footer_find_jobs.dart';
import 'package:job_match/presentation/widgets/homepage/find_job/job_filter_sidebar.dart';
import 'package:job_match/presentation/widgets/homepage/find_job/simple_job_card_list_view.dart';
import 'package:job_match/presentation/widgets/homepage/find_job/top_companies.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class FindJobsScreen extends StatelessWidget {
  const FindJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: double.infinity,
              color: Colors.black,
              child: _buildTopBar(context),
            ),
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              child: Container(
                height: 220,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/find_jobs_background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.55),
                  child: Center(
                    child: FadeInDown(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 500),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Un match ideal, para una ',
                            style: TextStyle(
                              fontSize: 44,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                'persona',
                                speed: const Duration(milliseconds: 100),
                                textStyle: const TextStyle(
                                  fontSize: 44,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              TypewriterAnimatedText(
                                'empresa',
                                speed: const Duration(milliseconds: 100),
                                textStyle: const TextStyle(
                                  fontSize: 44,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                            totalRepeatCount: 100,
                            pause: const Duration(seconds: 2),
                            displayFullTextOnTap: true,
                          ),
                          const Text(
                            'especial',
                            style: TextStyle(
                              fontSize: 44,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            //* Find job list
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FadeInLeft(
                        duration: const Duration(milliseconds: 700),
                        child: JobFilterSidebar(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FadeInRight(
                        duration: const Duration(milliseconds: 700),
                        child: SimpleJobCardListView(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 700),
              child: TopCompanies(),
            ),
            FadeInUpBig(
              duration: const Duration(milliseconds: 800),
              child: FooterFindJobs(),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTopBar(BuildContext context) {
  return Align(
    alignment: Alignment.center,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Row(
        children: [
          FadeInLeft(
            duration: const Duration(milliseconds: 600),
            child: Image.asset(
              'assets/images/job_match_transparent.png',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 100),
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTopBarButton('Inicio', selected: true),
                  _buildTopBarButton('Empleos'),
                  _buildTopBarButton('Sobre Nosotros'),
                  _buildTopBarButton('Contáctanos'),
                ],
              ),
            ),
          ),
          const Spacer(),
          FadeInRight(
            duration: const Duration(milliseconds: 600),
            child: FittedBox(
              child: Row(
                children: [
                  TextButton(
                    onPressed:
                        () => Navigator.of(
                          context,
                        ).push(SlideUpFadePageRoute(page: const LoginScreen())),
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                    ),
                    onPressed:
                        () => Navigator.of(
                          context,
                        ).push(SlideUpFadePageRoute(page: const LoginScreen())),
                    child: const Text('Registrarse'),
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

Widget _buildTopBarButton(String title, {bool selected = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Text(
      title,
      style: TextStyle(color: selected ? Colors.white : Colors.white38),
    ),
  );
}
