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
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = MediaQuery.sizeOf(context);
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
                    child: _buildTopBar(context, constraints, size),
                  ),
                  const Spacer(),
                  FadeIn(
                    duration: const Duration(milliseconds: 900),
                    child: Center(
                      child: _buildHeroSection(context, constraints, size),
                    ),
                  ),
                  const SizedBox(height: 40),
                  FadeInUp(
                    duration: const Duration(milliseconds: 900),
                    child: _buildStatsSection(constraints, size),
                  ),
                  const Spacer(),
                  FadeInUpBig(
                    duration: const Duration(milliseconds: 1000),
                    child: _buildPartnersSection(constraints, size),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    BoxConstraints constraints,
    Size size,
  ) {
    final showMenu = constraints.maxWidth < 700;
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: showMenu ? 12.0 : 24.0,
          vertical: showMenu ? 8 : 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElasticInLeft(
              duration: const Duration(milliseconds: 900),
              child: Image.asset(
                'assets/images/job_match_transparent.png',
                width: showMenu ? 50 : 80,
                height: showMenu ? 50 : 80,
              ),
            ),
            if (!showMenu)
              Row(
                children: [
                  _buildTopBarButton('Inicio', selected: true),
                  _buildTopBarButton('Empleos'),
                  _buildTopBarButton('Sobre Nosotros'),
                  _buildTopBarButton('Contáctanos'),
                ],
              ),
            if (showMenu)
              PopupMenuButton<String>(
                icon: Icon(Icons.menu, color: Colors.white),
                itemBuilder:
                    (context) => [
                      PopupMenuItem(value: 'Inicio', child: Text('Inicio')),
                      PopupMenuItem(value: 'Empleos', child: Text('Empleos')),
                      PopupMenuItem(
                        value: 'Sobre Nosotros',
                        child: Text('Sobre Nosotros'),
                      ),
                      PopupMenuItem(
                        value: 'Contáctanos',
                        child: Text('Contáctanos'),
                      ),
                    ],
                onSelected: (value) {},
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

  Widget _buildHeroSection(
    BuildContext context,
    BoxConstraints constraints,
    Size size,
  ) {
    final isNarrow = constraints.maxWidth < 700;
    final headlineFontSize = isNarrow ? 28.0 : 60.0;
    final subtitleFontSize = isNarrow ? 14.0 : 18.0;
    final buttonWidth = isNarrow ? 200.0 : 250.0;
    final buttonHeight = isNarrow ? 55.0 : 75.0;
    final buttonRadius = isNarrow ? 10.0 : 0.0;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding12),
          child: FadeInDownBig(
            duration: const Duration(milliseconds: 900),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Center(
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      TypewriterAnimatedText(
                        '¡Haz match con tu trabajo ideal!',
                        speed: const Duration(milliseconds: 100),
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(
                          fontSize: headlineFontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TypewriterAnimatedText(
                        '¡Haz match con tu colaborador ideal!',
                        speed: const Duration(milliseconds: 100),
                        textAlign: TextAlign.center,

                        textStyle: TextStyle(
                          fontSize: headlineFontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    pause: const Duration(seconds: 2),
                    displayFullTextOnTap: true,
                    isRepeatingAnimation: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding12),
          child: FadeIn(
            duration: const Duration(milliseconds: 1200),
            child: Text(
              'Conectando talento con oportunidad: tu puerta al éxito.',
              style: TextStyle(
                fontSize: subtitleFontSize,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ),
        const SizedBox(height: 40),
        FadeInUp(
          duration: const Duration(milliseconds: 1000),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child:
                isNarrow
                    ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildEmpresaButton(
                          context,
                          buttonWidth,
                          buttonHeight,
                          buttonRadius,
                          isNarrow,
                        ),
                        const SizedBox(height: 10),
                        BounceInRight(
                          duration: const Duration(milliseconds: 900),
                          child: _buildFindJobButton(
                            buttonWidth,
                            buttonHeight,
                            buttonRadius,
                            isNarrow,
                          ),
                        ),
                      ],
                    )
                    : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildEmpresaButton(
                          context,
                          buttonWidth,
                          buttonHeight,
                          buttonRadius,
                          isNarrow,
                        ),
                        BounceInRight(
                          duration: const Duration(milliseconds: 900),
                          child: _buildFindJobButton(
                            buttonWidth,
                            buttonHeight,
                            buttonRadius,
                            isNarrow,
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpresaButton(
    BuildContext context,
    double width,
    double height,
    double radius,
    bool isNarrow,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width, height),
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            topRight: isNarrow ? Radius.circular(10) : Radius.zero,
            bottomRight: isNarrow ? Radius.circular(10) : Radius.zero,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.publish, color: Colors.white),
          const SizedBox(width: 8),
          const Text("Soy Empresa", style: TextStyle(color: Colors.white)),
        ],
      ),
      onPressed:
          () => Navigator.of(context).push(
            SlideUpFadePageRoute(page: const LoginScreen(userType: 'Empresa')),
          ),
    );
  }

  ElevatedButton _buildFindJobButton(
    double width,
    double height,
    double radius,
    bool isNarrow,
  ) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
            topLeft: isNarrow ? Radius.circular(10) : Radius.zero,
            bottomLeft: isNarrow ? Radius.circular(10) : Radius.zero,
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

  Widget _buildStatsSection(BoxConstraints constraints, Size size) {
    final isNarrow = constraints.maxWidth < 700;
    final spacing = isNarrow ? 20.0 : 60.0;
    final iconSize = isNarrow ? 32.0 : 40.0;
    final fontSize = isNarrow ? 16.0 : 20.0;
    return Consumer(
      builder: (__, ref, _) {
        final jobsCount = ref.watch(jobsCountProvider);
        final candidatesCount = ref.watch(candidatesCountProvider);
        final companiesCount = ref.watch(companiesCountProvider);
        if (isNarrow) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  iconSize: iconSize,
                  fontSize: fontSize,
                ),
              ),
              SizedBox(height: spacing),
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
                  iconSize: iconSize,
                  fontSize: fontSize,
                ),
              ),
              SizedBox(height: spacing),
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
                  iconSize: iconSize,
                  fontSize: fontSize,
                ),
              ),
            ],
          );
        } else {
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
                  iconSize: iconSize,
                  fontSize: fontSize,
                ),
              ),
              SizedBox(width: spacing),
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
                  iconSize: iconSize,
                  fontSize: fontSize,
                ),
              ),
              SizedBox(width: spacing),
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
                  iconSize: iconSize,
                  fontSize: fontSize,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildPartnersSection(BoxConstraints constraints, Size size) {
    final isNarrow = constraints.maxWidth < 700;
    return Container(
      color: Colors.black,
      height: isNarrow ? 60 : 100,
      padding: EdgeInsets.symmetric(vertical: isNarrow ? 8 : 15),
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
                padding: EdgeInsets.symmetric(
                  horizontal: isNarrow ? 8.0 : 16.0,
                ),
                child: Image.asset(
                  img,
                  height:
                      img.contains('dicesa')
                          ? (isNarrow ? 20 : 40)
                          : (isNarrow ? 35 : 70),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
