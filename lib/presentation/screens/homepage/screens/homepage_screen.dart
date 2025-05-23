import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/config/util/animations.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/presentation/screens/auth/screens/login_screen.dart';
import 'package:job_match/presentation/screens/homepage/find_jobs_screen.dart';
import 'package:job_match/presentation/widgets/homepage/partner_icon.dart';
import 'package:job_match/presentation/widgets/homepage/stat_item.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final List<String> _partnerImages = [
    'assets/images/mcatalan.png',
    'assets/images/fresnos.png',
    'assets/images/carze.png',
    'assets/images/efecto_eureka.png',
    'assets/images/dicesa.png',
  ];

  final PageController _carouselController = PageController(
    viewportFraction: 0.3,
    initialPage: 1000,
  );
  int _currentPage = 1000;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) break;
      _currentPage++;
      _carouselController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/homepage_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 800),
                child: _buildTopBar(context),
              ),
              const Spacer(),
              FadeIn(
                duration: const Duration(milliseconds: 900),
                child: Center(child: _buildHeroSection(context)),
              ),
              const SizedBox(height: 40),
              FadeInUp(
                duration: const Duration(milliseconds: 900),
                child: _buildStatsSection(),
              ),
              const Spacer(),
              FadeInUpBig(
                duration: const Duration(milliseconds: 1000),
                child: _buildPartnersSection(),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElasticInLeft(
              duration: const Duration(milliseconds: 900),
              child: Image.asset(
                'assets/images/job_match_transparent.png',
                width: 80,
                height: 80,
              ),
            ),
            Row(
              children: [
                _buildTopBarButton('Inicio', selected: true),
                _buildTopBarButton('Empleos'),
                _buildTopBarButton('Sobre Nosotros'),
                _buildTopBarButton('Contáctanos'),
              ],
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

  Widget _buildHeroSection(BuildContext context) {
    return Column(
      children: [
        FadeInDownBig(
          duration: const Duration(milliseconds: 900),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Haz match con tu trabajo ideal!',
                    speed: const Duration(milliseconds: 100),
                    textStyle: const TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TypewriterAnimatedText(
                    'Haz match con tu colaborador ideal!',
                    speed: const Duration(milliseconds: 100),
                    textStyle: const TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                pause: const Duration(seconds: 2),
                displayFullTextOnTap: true,
                isRepeatingAnimation: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        FadeIn(
          duration: const Duration(milliseconds: 1200),
          child: const Text(
            'Conectando talento con oportunidad: tu puerta al éxito profesional',
            style: TextStyle(fontSize: 18, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 40),
        FadeInUp(
          duration: const Duration(milliseconds: 1000),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Row(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(250, 75),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.publish, color: Colors.white),
                      const Text(
                        "Soy Empresa",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed:
                      () => Navigator.of(context).push(
                        SlideUpFadePageRoute(
                          page: const LoginScreen(userType: 'Empresa'),
                        ),
                      ),
                ),

                BounceInRight(
                  duration: const Duration(milliseconds: 900),
                  child: _buildFindJobButton(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ElevatedButton _buildFindJobButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
      },
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(200, 75),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 10),
          Text('Buscar Empleo', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Consumer(
      builder: (__, ref, _) {
        final jobsCount = ref.watch(jobsCountProvider);
        final candidatesCount = ref.watch(candidatesCountProvider);
        final companiesCount = ref.watch(companiesCountProvider);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            FadeInUp(
              duration: Duration(milliseconds: 900),
              child: StatItem(
                icon: Icons.work_outline,
                count: jobsCount.when(
                  data: (data) => data.toString(),
                  error: (error, stackTrace) => '0',
                  loading: () => '-',
                ),
                label: 'Empleos',
              ),
            ),

            SizedBox(width: 60),

            FadeInUp(
              duration: Duration(milliseconds: 900),
              child: StatItem(
                icon: Icons.people_outline,
                count: candidatesCount.when(
                  data: (data) => data.toString(),
                  error: (error, stackTrace) => '0',
                  loading: () => '-',
                ),
                label: 'Candidatos',
              ),
            ),

            SizedBox(width: 60),

            FadeInUp(
              duration: Duration(milliseconds: 900),
              child: StatItem(
                icon: Icons.business,
                count: companiesCount.when(
                  data: (data) => data.toString(),
                  error: (error, stackTrace) => '0',
                  loading: () => '-',
                ),
                label: 'Empresas',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPartnersSection() {
    return Container(
      color: Colors.black,
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          -1,
          0,
          0,
          0,
          255,
          0,
          -1,
          0,
          0,
          255,
          0,
          0,
          -1,
          0,
          255,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: PageView.builder(
          controller: _carouselController,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final img = _partnerImages[index % _partnerImages.length];
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Image.asset(
                  img,
                  height: img.contains('dicesa') ? 40 : 70,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
