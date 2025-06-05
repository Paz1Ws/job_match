import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/presentation/screens/auth/screens/login_screen.dart';

class CTASection extends StatelessWidget {
  final BoxConstraints constraints;
  final Size size;

  const CTASection({super.key, required this.constraints, required this.size});

  @override
  Widget build(BuildContext context) {
    final isNarrow = constraints.maxWidth < 900;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: isNarrow ? 20 : 60,
        vertical: isNarrow ? 40 : 60,
      ),
      child: FadeInUp(
        duration: const Duration(milliseconds: 1000),
        child: Container(
          height: isNarrow ? 300 : 400,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 25,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child:
                isNarrow
                    ? _buildMobileLayout(context)
                    : _buildDesktopLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          width: 300,
          height: 200,
          child: Image.asset(
            'assets/images/crossed_arms_coworkers.png',
            fit: BoxFit.fill,
            matchTextDirection: true,
            isAntiAlias: true,
          ),
        ),
        // Content positioned at the top
        Positioned(
          left: 20,
          top: 40,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInLeft(
                duration: const Duration(milliseconds: 1200),
                child: Text(
                  'Crea Un Mejor\nFuturo Para Ti, Para La Comunidad.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInLeft(
                duration: const Duration(milliseconds: 1400),
                child: Text(
                  'Descubre oportunidades laborales \nque se alineen \ncon tus metas profesionales.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                  ),
                  maxLines: 3,
                ),
              ),
              const SizedBox(height: 24),
              FadeInLeft(
                duration: const Duration(milliseconds: 1600),
                child: ElevatedButton(
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
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Buscar Empleo',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Image positioned at the bottom right
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(left: 60, top: 60, bottom: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInLeft(
                  duration: const Duration(milliseconds: 1200),
                  child: Text(
                    'Crea Un Mejor\nFuturo Para Ti, Para La Comunidad.',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FadeInLeft(
                  duration: const Duration(milliseconds: 1400),
                  child: Text(
                    'Descubre oportunidades laborales que se alineen con tus metas profesionales. En JobMatch, te ayudamos a construir la carrera que siempre has soñado.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.5,
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 24),
                FadeInLeft(
                  duration: const Duration(milliseconds: 1600),
                  child: ElevatedButton(
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
                        horizontal: 28,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Buscar Empleo',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Image.asset(
            'assets/images/crossed_arms_coworkers.png',
            fit: BoxFit.fill,
          ),
        ),
        // Content section (left side)
        // Image section (right side)
      ],
    );
  }
}
