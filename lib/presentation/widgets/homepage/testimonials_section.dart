import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class TestimonialsSection extends StatelessWidget {
  final BoxConstraints constraints;
  final Size size;

  const TestimonialsSection({
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
      child: Column(
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 800),
            child: Column(
              children: [
                Text(
                  'Testimonios de Nuestros Clientes',
                  style: TextStyle(
                    fontSize: isNarrow ? 28 : 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Descubre lo que dicen las empresas que confían en JobMatch para encontrar el mejor talento y hacer crecer sus equipos.',
                  style: TextStyle(
                    fontSize: isNarrow ? 14 : 16,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          isNarrow ? _buildMobileLayout() : _buildDesktopLayout(isTablet),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildTestimonialCard(
          stars: 5,
          title: 'Encontramos el talento perfecto',
          description:
              'JobMatch nos ayudó a encontrar ingenieros especializados en proyectos eléctricos y mecánicos. Su plataforma facilitó mucho nuestro proceso de selección y encontramos profesionales que se adaptan perfectamente a nuestras necesidades técnicas.',
          logo: 'assets/images/carze.png',
          name: 'Carze',
          subtitle: 'Empresa de Ingeniería',
        ),
        const SizedBox(height: 24),
        _buildTestimonialCard(
          stars: 5,
          title: 'Profesionales de la salud excepcionales',
          description:
              'Gracias a JobMatch pudimos incorporar médicos especialistas y personal de enfermería altamente calificado. La calidad de los candidatos superó nuestras expectativas y fortalecieron nuestro equipo médico en Cajamarca.',
          logo: 'assets/images/fresnos.png',
          name: 'Clínica Los Fresnos',
          subtitle: 'Institución de Salud',
        ),
        const SizedBox(height: 24),
        _buildTestimonialCard(
          stars: 5,
          title: 'Conductores y operadores confiables',
          description:
              'Con más de 45 años en transporte, sabemos lo importante que es contar con personal experimentado. JobMatch nos conectó con conductores especializados en materiales peligrosos y operadores de maquinaria pesada de primer nivel.',
          logo: 'assets/images/mcatalan.png',
          name: 'Transportes M. Catalán',
          subtitle: 'Empresa de Transporte',
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: FadeInUp(
            duration: const Duration(milliseconds: 1000),
            child: _buildTestimonialCard(
              stars: 5,
              title: 'Encontramos el talento perfecto',
              description:
                  'JobMatch nos ayudó a encontrar ingenieros especializados en proyectos eléctricos y mecánicos. Su plataforma facilitó mucho nuestro proceso de selección y encontramos profesionales que se adaptan perfectamente a nuestras necesidades técnicas.',
              logo: 'assets/images/carze.png',
              name: 'Carze',
              subtitle: 'Empresa de Ingeniería',
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: FadeInUp(
            duration: const Duration(milliseconds: 1200),
            child: _buildTestimonialCard(
              stars: 5,
              title: 'Profesionales de la salud excepcionales',
              description:
                  'Gracias a JobMatch pudimos incorporar médicos especialistas y personal de enfermería altamente calificado. La calidad de los candidatos superó nuestras expectativas y fortalecieron nuestro equipo médico en Cajamarca.',
              logo: 'assets/images/fresnos.png',
              name: 'Clínica Los Fresnos',
              subtitle: 'Institución de Salud',
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: FadeInUp(
            duration: const Duration(milliseconds: 1400),
            child: _buildTestimonialCard(
              stars: 5,
              title: 'Conductores y operadores confiables',
              description:
                  'Con más de 45 años en transporte, sabemos lo importante que es contar con personal experimentado. JobMatch nos conectó con conductores especializados en materiales peligrosos y operadores de maquinaria pesada de primer nivel.',
              logo: 'assets/images/mcatalan.png',
              name: 'Transportes M. Catalán',
              subtitle: 'Empresa de Transporte',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTestimonialCard({
    required int stars,
    required String title,
    required String description,
    required String logo,
    required String name,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stars
          Row(
            children: List.generate(
              stars,
              (index) => Icon(Icons.star, color: Colors.orange, size: 20),
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          // Description
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          // User info with logo and teal quote mark
          Row(
            children: [
              // Company logo
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(logo, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(width: 12),
              // Name and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              // Teal quote mark
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.format_quote, color: Colors.teal, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
