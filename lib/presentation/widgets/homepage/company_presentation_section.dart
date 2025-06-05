import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:job_match/presentation/screens/auth/screens/login_screen.dart';

class CompanyPresentationSection extends StatelessWidget {
  final BoxConstraints constraints;
  final Size size;

  const CompanyPresentationSection({
    super.key,
    required this.constraints,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final isNarrow = constraints.maxWidth < 900;
    final isTablet = constraints.maxWidth < 1200;

    return Container(
      width: double.infinity,
      color: Colors.grey.shade50,
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 20 : 60,
        vertical: isNarrow ? 60 : 100,
      ),
      child:
          isNarrow
              ? _buildMobileLayout(context)
              : _buildDesktopLayout(isTablet, context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildImageSection(isMobile: true),
        const SizedBox(height: 40),
        _buildContentSection(isMobile: true, context: context),
        const SizedBox(height: 60),
        _buildStatsCards(isMobile: true),
      ],
    );
  }

  Widget _buildDesktopLayout(bool isTablet, BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: isTablet ? 1 : 1,
              child: _buildImageSection(isMobile: false),
            ),
            SizedBox(width: isTablet ? 40 : 80),
            Expanded(
              flex: isTablet ? 1 : 1,
              child: _buildContentSection(isMobile: false, context: context),
            ),
          ],
        ),
        const SizedBox(height: 80),
        _buildStatsCards(isMobile: false),
      ],
    );
  }

  Widget _buildImageSection({required bool isMobile}) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 1000),
      child: Container(
        height: isMobile ? 250 : 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/presentation_coworkers.webp',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'JobMatch',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection({
    required bool isMobile,
    required BuildContext context,
  }) {
    return FadeInRight(
      duration: const Duration(milliseconds: 1000),
      child: Column(
        crossAxisAlignment:
            isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          // Animated title with RotateAnimatedText
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Encuentra el ',
                style: TextStyle(
                  fontSize: isMobile ? 28 : 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                  height: 1.2,
                ),
              ),
              FittedBox(
                fit: BoxFit.fill,
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: isMobile ? 28 : 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    height: 1.2,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      FadeAnimatedText('TALENTO'),
                      FadeAnimatedText('CANDIDATO'),
                    ],
                    repeatForever: true,
                    pause: const Duration(milliseconds: 800),
                  ),
                ),
              ),
            ],
          ),
          Text(
            'ideal, hoy mismo',
            style: TextStyle(
              fontSize: isMobile ? 28 : 48,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
              height: 1.2,
            ),
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
          ),
          const SizedBox(height: 24),
          Text(
            'Somos JobMatch, una plataforma innovadora que revoluciona la forma de conectar empresas con talento excepcional. Nuestro equipo se dedica a crear vínculos duraderos entre organizaciones que buscan crecer y profesionales que desean desarrollar su potencial al máximo.',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: Colors.grey.shade600,
              height: 1.6,
            ),
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment:
                isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Registrarme',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards({required bool isMobile}) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1200),
      child:
          isMobile
              ? Column(
                children: [
                  _buildStatCard(
                    '2+',
                    'Años de experiencia',
                    'Conectando empresas con profesionales talentosos, construyendo puentes hacia el éxito mutuo en el mercado laboral.',
                  ),
                  const SizedBox(height: 24),
                  _buildStatCard(
                    '98%',
                    'Satisfacción del cliente',
                    'Nuestros clientes confían en nosotros para encontrar exactamente lo que buscan, ya sea talento excepcional o la oportunidad perfecta.',
                  ),
                  const SizedBox(height: 24),
                  _buildStatCard(
                    '24/7',
                    'Soporte disponible',
                    'Estamos aquí cuando nos necesites. Nuestro equipo está comprometido a brindarte asistencia en cada paso de tu proceso.',
                  ),
                ],
              )
              : Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      '2+',
                      'Años de experiencia',
                      'Conectando empresas con profesionales talentosos, construyendo puentes hacia el éxito mutuo en el mercado laboral.',
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildStatCard(
                      '98%',
                      'Satisfacción del cliente',
                      'Nuestros clientes confían en nosotros para encontrar exactamente lo que buscan, ya sea talento excepcional o la oportunidad perfecta.',
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildStatCard(
                      '24/7',
                      'Soporte disponible',
                      'Estamos aquí cuando nos necesites. Nuestro equipo está comprometido a brindarte asistencia en cada paso de tu proceso.',
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildStatCard(String number, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
