import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class TopCompanies extends StatelessWidget {
  const TopCompanies({super.key});

  @override
  Widget build(BuildContext context) {
    final companyCards = [
      const _CompanyCard(
        companyName: 'Instagram',
        description:
            'Encuentra tu próximo desafío creativo y conecta con millones de usuarios.',
        openJobs: 8,
        icon: Icons.camera_alt,
      ),
      const _CompanyCard(
        companyName: 'Tesla',
        description:
            'Únete a la vanguardia de la innovación en energía sostenible y tecnología automotriz.',
        openJobs: 18,
        icon: Icons.electric_car,
      ),
      const _CompanyCard(
        companyName: 'McDonald\'s',
        description:
            'Desarrolla tu carrera en una de las marcas de restaurantes más reconocidas a nivel mundial.',
        openJobs: 12,
        icon: Icons.restaurant,
      ),
      const _CompanyCard(
        companyName: 'Apple',
        description:
            'Sé parte de la creación de productos y servicios que inspiran y transforman la vida de las personas.',
        openJobs: 9,
        icon: Icons.apple,
      ),
    ];

    // Detectar si estamos en modo móvil basado en ancho de pantalla
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
      color: const Color(0xFFEBF5F4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 500),
            child: Text(
              'Empresas Destacadas',
              style: TextStyle(
                fontSize: isMobile ? 28.0 : 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          FadeInDown(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 500),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 60.0),
              child: Text(
                'Descubre las mejores oportunidades laborales en las empresas líderes del mercado.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 12.0 : 14.0,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),

          // En móvil: mostrar con scroll horizontal
          if (isMobile)
            SizedBox(
              height: 280, // Altura fija para el contenedor en mobile
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                itemCount: companyCards.length,
                itemBuilder: (context, index) {
                  return FadeInUp(
                    delay: Duration(milliseconds: 150 * index + 300),
                    duration: const Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 220, // Ancho fijo para las tarjetas en scroll
                        child: companyCards[index],
                      ),
                    ),
                  );
                },
              ),
            )
          // En desktop: mostrar en fila
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(companyCards.length, (index) {
                return FadeInUp(
                  delay: Duration(milliseconds: 150 * index + 300),
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: companyCards[index],
                  ),
                );
              }),
            ),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final String companyName;
  final String description;
  final int openJobs;
  final IconData icon;

  const _CompanyCard({
    required this.companyName,
    required this.description,
    required this.openJobs,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48.0),
          const SizedBox(height: 8.0),
          Text(
            companyName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12.0),
          Text(
            description,
            style: const TextStyle(fontSize: 12.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18.0),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Text(
              '$openJobs ofertas de empleo',
              style: const TextStyle(fontSize: 10.0, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }
}
