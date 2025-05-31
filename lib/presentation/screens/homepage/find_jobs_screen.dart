import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added
import 'package:job_match/config/constants/layer_constants.dart'; // Added
import 'package:job_match/config/util/animations.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/presentation/screens/auth/screens/login_screen.dart';
import 'package:job_match/presentation/screens/homepage/screens/homepage_screen.dart';
import 'package:job_match/presentation/widgets/auth/app_identity_bar.dart'; // Added for isCandidateProvider
import 'package:job_match/presentation/screens/profiles/user_profile.dart'; // Added
import 'package:job_match/presentation/screens/profiles/company_profile_screen.dart'; // Added
import 'package:job_match/presentation/widgets/homepage/find_job/footer_find_jobs.dart';
import 'package:job_match/presentation/widgets/homepage/find_job/job_filter_sidebar.dart';
import 'package:job_match/presentation/widgets/homepage/find_job/simple_job_card_list_view.dart';
import 'package:job_match/presentation/widgets/homepage/find_job/top_companies.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class FindJobsScreen extends ConsumerWidget {
  const FindJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Create a key to manage the scaffold state (needed for opening drawer)
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = MediaQuery.sizeOf(context);
        final isMobile = size.width < 700;

        return Scaffold(
          key: scaffoldKey,
          // Add drawer for mobile view that contains the filter sidebar
          drawer:
              isMobile
                  ? Drawer(
                    width: size.width * 0.85,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Filtros',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            ),
                            // const Divider(),
                            // Expanded(
                            //   child: SingleChildScrollView(
                            //     child: JobFilterSidebar(),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  )
                  : null,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 80,
                  width: double.infinity,
                  color: Colors.black,
                  child: _buildTopBar(context, ref),
                ),
                FadeInDown(
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    height: isMobile ? 120 : 220,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/find_jobs_background.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.55),
                      child: Center(
                        child: FadeInDown(
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 500),
                          child:
                              isMobile
                                  ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Un match ideal, para una ',
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      AnimatedTextKit(
                                        animatedTexts: [
                                          TypewriterAnimatedText(
                                            'persona',
                                            speed: const Duration(
                                              milliseconds: 100,
                                            ),
                                            textStyle: const TextStyle(
                                              fontSize: 24,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          TypewriterAnimatedText(
                                            'empresa',
                                            speed: const Duration(
                                              milliseconds: 100,
                                            ),
                                            textStyle: const TextStyle(
                                              fontSize: 24,
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
                                          fontSize: 24,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  )
                                  : Row(
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
                                            speed: const Duration(
                                              milliseconds: 100,
                                            ),
                                            textStyle: const TextStyle(
                                              fontSize: 44,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          TypewriterAnimatedText(
                                            'empresa',
                                            speed: const Duration(
                                              milliseconds: 100,
                                            ),
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

                // Filtros y lista de trabajos
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  child:
                      isMobile
                          // En móvil, solo mostramos la lista de trabajos con botón de filtros arriba
                          ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Filtro arriba de la lista de trabajos en mobile
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                    vertical: 8.0,
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        () =>
                                            scaffoldKey.currentState
                                                ?.openDrawer(),
                                    icon: const Icon(Icons.filter_list),
                                    label: const Text('Filtrar resultados'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                FadeInRight(
                                  duration: const Duration(milliseconds: 700),
                                  child: SimpleJobCardListView(),
                                ),
                              ],
                            ),
                          )
                          // En desktop, mantenemos el layout con filtro visible + lista
                          : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Flexible(
                              //   flex: 2,
                              //   fit: FlexFit.loose,
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(16.0),
                              //     child: FadeInLeft(
                              //       duration: const Duration(milliseconds: 700),
                              //       child: JobFilterSidebar(),
                              //     ),
                              //   ),
                              // ),
                              Flexible(
                                flex: 5,
                                fit: FlexFit.loose,
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
      },
    );
  }
}

Widget _buildTopBar(BuildContext context, WidgetRef ref) {
  final candidate = ref.watch(candidateProfileProvider);
  final company = ref.watch(companyProfileProvider);
  final isCandidate = ref.watch(isCandidateProvider);
  final bool isLoggedIn = candidate != null || company != null;
  final size = MediaQuery.sizeOf(context);

  ImageProvider? userImageProvider;
  Widget? fallbackIcon;

  if (isLoggedIn) {
    if (isCandidate &&
        candidate?.photo != null &&
        candidate!.photo!.isNotEmpty) {
      userImageProvider = NetworkImage(candidate.photo!);
    } else if (!isCandidate &&
        company?.logo != null &&
        company!.logo!.isNotEmpty) {
      userImageProvider = NetworkImage(company.logo!);
    }
  }

  if (userImageProvider == null && isLoggedIn) {
    fallbackIcon = Icon(
      isCandidate ? Icons.person : Icons.business,
      color: Colors.white,
      size: kIconSize20,
    );
  }

  return Align(
    alignment: Alignment.center,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Row(
        children: [
          FadeInLeft(
            duration: const Duration(milliseconds: 600),
            child: GestureDetector(
              onTap: () {
                // Add safety check before navigation
                if (!context.mounted) return;

                // Use a slight delay to ensure ink effects complete
                Future.microtask(() {
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      FadeThroughPageRoute(page: const HomepageScreen()),
                      (route) => false,
                    );
                  }
                });
              },
              child: Image.asset(
                'assets/images/job_match_transparent.png',
                width: kIconSize48,
                height: kIconSize48,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const Spacer(),
          FadeInRight(
            duration: const Duration(milliseconds: 600),
            child: FittedBox(
              child:
                  isLoggedIn
                      ? InkWell(
                        onTap: () {
                          if (isCandidate) {
                            Navigator.of(context).push(
                              FadeThroughPageRoute(page: const UserProfile()),
                            );
                          } else {
                            Navigator.of(context).push(
                              FadeThroughPageRoute(
                                page: const CompanyProfileScreen(),
                              ),
                            );
                          }
                        },
                        child: CircleAvatar(
                          radius: kIconSize20,
                          backgroundColor: Colors.blueGrey.shade700,
                          backgroundImage: userImageProvider,
                          child: fallbackIcon,
                        ),
                      )
                      : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
                          ),
                        ),
                        onPressed: () {
                          // Add safety check before navigation
                          if (!context.mounted) return;

                          Future.microtask(() {
                            if (context.mounted) {
                              Navigator.of(context).push(
                                SlideUpFadePageRoute(page: const LoginScreen()),
                              );
                            }
                          });
                        },
                        child: const Text('Registrarse'),
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
