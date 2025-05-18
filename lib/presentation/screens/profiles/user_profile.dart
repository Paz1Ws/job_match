import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_match/config/config.dart';
import 'dart:math'; // Para generar números aleatorios
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/presentation/screens/dashboard/candidate_dashboard_screen.dart';
import 'package:job_match/presentation/screens/dashboard/employer_dashboard_screen.dart';
import 'package:job_match/presentation/widgets/auth/app_identity_bar.dart';
import 'package:job_match/presentation/widgets/auth/profile_display_elements.dart';
import 'package:job_match/presentation/widgets/auth/related_job_card.dart';
import 'package:job_match/config/constants/layer_constants.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    const double appIdentityBarHeight = 70.0;

    return Scaffold(
      body: Column(
        children: <Widget>[
          AppIdentityBar(height: appIdentityBarHeight, indexSelected: 1),
          Expanded(child: SingleChildScrollView(child: ProfileDetailHeader())),
        ],
      ),
    );
  }
}

class ProfileDetailHeader extends StatelessWidget {
  ProfileDetailHeader({super.key}); // Constructor updated

  final bool isEmployee = false;
  final Random _random = Random();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final double bannerHeight = 220.0;
    final double cardOverlap = 70.0;
    final double pageHorizontalPadding = kPadding28 + kSpacing4;

    // Mock data for related jobs
    final List<Job> relatedJobs = [
      Job(
        logoAsset: 'assets/images/job_match.jpg',
        companyName: 'Innovatech Perú',
        location: 'Lima, Perú',
        title: 'Diseñador Visual Senior',
        type: 'Tiempo Completo',
        salary: 'S/7K - S/9K',
        isFeatured: true,
        logoBackgroundColor: Colors.deepPurple,
        matchPercentage: _random.nextInt(41) + 60,
      ),
      Job(
        logoAsset: 'placeholder_icon',
        companyName: 'Soluciones Web Ágiles',
        location: 'Arequipa, Perú',
        title: 'Desarrollador Front-End',
        type: 'Base Contrato',
        salary: 'S/5K - S/7K',
        logoBackgroundColor: Colors.orange,
        matchPercentage: _random.nextInt(41) + 60,
      ),
      Job(
        logoAsset: 'placeholder_icon',
        companyName: 'Data Corp',
        location: 'Trujillo, Perú',
        title: 'Especialista en Soporte Técnico',
        type: 'Tiempo Completo',
        salary: 'S/4K - S/6K',
        logoBackgroundColor: Colors.green,
        matchPercentage: _random.nextInt(41) + 60,
      ),
      Job(
        logoAsset: 'placeholder_icon',
        companyName: 'Creativos Digitales',
        location: 'Cusco, Perú',
        title: 'Ingeniero de Software',
        type: 'Medio Tiempo',
        salary: 'S/3K - S/5K',
        logoBackgroundColor: Colors.blue,
        matchPercentage: _random.nextInt(41) + 60,
      ),
      Job(
        logoAsset: 'assets/images/job_match.jpg',
        companyName: 'MercadoTech',
        location: 'Lima, Perú',
        title: 'Diseñador de Producto',
        type: 'Tiempo Completo',
        salary: 'S/6K - S/8K',
        logoBackgroundColor: Colors.teal,
        matchPercentage: _random.nextInt(41) + 60,
      ),
      Job(
        logoAsset: 'placeholder_icon',
        companyName: 'Media Interactiva',
        location: 'Piura, Perú',
        title: 'Diseñador de Interacción',
        type: 'Tiempo Completo',
        salary: 'S/4K - S/5K',
        logoBackgroundColor: Colors.red,
        matchPercentage: _random.nextInt(41) + 60,
      ),
    ];

    return Container(
      color: const Color(
        0xFFF7F8FA,
      ), // Background for the whole scrollable content
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Banner Image Container
          SizedBox(
            height: bannerHeight,
            width: double.infinity,
            child: Image.asset(
              'assets/images/profile_background.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          // Profile Card Container (overlaps the banner)
          Transform.translate(
            offset: Offset(0, -cardOverlap), // Pulls the card up
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: pageHorizontalPadding),
              child: Container(
                // This is the white container for profile details
                padding: const EdgeInsets.all(kPadding28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(kRadius12 + kRadius4),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: kStroke1 * 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.07),
                      spreadRadius: kStroke1,
                      blurRadius: kSpacing8,
                      offset: const Offset(0, kSpacing4 / 2),
                    ),
                  ],
                ),
                child: Column(
                  // Existing content of the white card starts here
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const CircleAvatar(
                          radius: kRadius20 + kRadius12,
                          backgroundImage: AssetImage(
                            'assets/images/job_match.jpg',
                          ),
                        ),
                        const SizedBox(width: kSpacing20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  const Expanded(
                                    child: Text(
                                      'Especialista en Comunicaciones',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.0,
                                        color: Color(0xFF222B45),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: kSpacing8 + kSpacing4 / 2,
                                  ),
                                  const InfoChip(
                                    label: 'Tiempo Completo',
                                    backgroundColor: Color(0xFFFFA500),
                                    textColor: Colors.white,
                                  ),
                                  const SizedBox(width: kSpacing8),
                                  const InfoChip(
                                    label: 'Remoto',
                                    backgroundColor: Color(0xFF3366FF),
                                    textColor: Colors.white,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: kSpacing12 + kSpacing4 / 2,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    const IconTextRow(
                                      icon: Icons.link,
                                      text: 'www.julionima.com/portafolio',
                                    ),
                                    SizedBox(width: screenSize.width * 0.04),
                                    const IconTextRow(
                                      icon: Icons.phone,
                                      text: '+51 912 345 678',
                                    ),
                                    SizedBox(width: screenSize.width * 0.04),
                                    const IconTextRow(
                                      icon: Icons.email,
                                      text: 'julio.nima@email.com',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: kSpacing20),
                        Row(
                          children: <Widget>[
                            Container(
                              width: kRadius40 + kSpacing4,
                              height: kRadius40 + kSpacing4,
                              decoration: BoxDecoration(
                                color: Colors.lightBlue[100],
                                borderRadius: BorderRadius.circular(kRadius8),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.bookmark_border,
                                  color: Colors.blue,
                                  size: kIconSize24 + kSpacing4,
                                ),
                                onPressed: () {},
                                tooltip: 'Guardar',
                                iconSize: kIconSize24 + kSpacing4,
                              ),
                            ),
                            const SizedBox(width: kSpacing12 + kSpacing4 / 2),
                            SizedBox(
                              height: kRadius40 + kSpacing4,
                              child: ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  size: kIconSize20,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Ir a panel',
                                  style: TextStyle(fontSize: 15),
                                ),
                                onPressed: () {
                                  if (Config().accountType == AccountType.employee) { context.go('/employee-dashboard'); }
                                  else { context.go('/candidate-dashboard'); }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3366FF),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: kPadding20 + kSpacing4,
                                    vertical: 0,
                                  ),
                                  textStyle: const TextStyle(fontSize: 15.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      kRadius8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SectionTitle(text: 'Perfil Profesional'),
                              JustifiedText(
                                text:
                                    'Comunicador social con más de 8 años de experiencia en gestión de comunicación interna y externa, relaciones públicas y manejo de crisis. Experto en redacción, storytelling y estrategias digitales para fortalecer la imagen institucional y el engagement de audiencias. Proactivo, creativo y con excelentes habilidades interpersonales.',
                              ),
                              SectionTitle(text: 'Responsabilidades y Logros'),
                              BulletPointItem(
                                text:
                                    'Diseño e implementación de campañas de comunicación corporativa.',
                              ),
                              BulletPointItem(
                                text:
                                    'Gestión de redes sociales y medios digitales para empresas nacionales e internacionales.',
                              ),
                              BulletPointItem(
                                text:
                                    'Redacción de notas de prensa, discursos y contenidos institucionales.',
                              ),
                              BulletPointItem(
                                text:
                                    'Organización de eventos y ruedas de prensa exitosas.',
                              ),
                              BulletPointItem(
                                text:
                                    'Desarrollo de estrategias de comunicación de crisis.',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: kSpacing30 + kSpacing4 / 2),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Container(
                                padding: kPaddingAll20,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F8FA),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: kStroke1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    kRadius12 + kRadius4 / 2,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Características del Perfil',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF222B45),
                                      ),
                                    ),
                                    const SizedBox(
                                      height:
                                          kSpacing12 +
                                          kSpacing8 / 2 +
                                          kSpacing4 / 2,
                                    ),
                                    Wrap(
                                      runSpacing:
                                          kSpacing12 +
                                          kSpacing8 / 2 +
                                          kSpacing4 / 2,
                                      spacing: kSpacing30 + kSpacing4 / 2,
                                      children: const [
                                        ProfileOverviewItem(
                                          icon: Icons.person,
                                          label: 'Nivel',
                                          value: 'Senior',
                                        ),
                                        ProfileOverviewItem(
                                          icon: Icons.language,
                                          label: 'Idiomas',
                                          value: 'Español, Inglés (Avanzado)',
                                        ),
                                        ProfileOverviewItem(
                                          icon: Icons.school,
                                          label: 'Educación',
                                          value:
                                              'Lic. en Ciencias de la Comunicación',
                                        ),
                                        ProfileOverviewItem(
                                          icon: Icons.attach_money,
                                          label: 'Aspiración Salarial',
                                          value: 'S/6,000-8,000/mes',
                                        ),
                                        ProfileOverviewItem(
                                          icon: Icons.location_on,
                                          label: 'Ubicación',
                                          value: 'Lima, Perú',
                                        ),
                                        ProfileOverviewItem(
                                          icon: Icons.work,
                                          label: 'Modalidad',
                                          value: 'Remoto / Presencial',
                                        ),
                                        ProfileOverviewItem(
                                          icon: Icons.timeline,
                                          label: 'Experiencia',
                                          value: '8 años',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: kSpacing20 + kSpacing4),
                              // Información de contacto de Julio Cesar Nima
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F8FA),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: kStroke1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    kRadius12 + kRadius4 / 2,
                                  ),
                                ),
                                padding: kPaddingAll20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          radius: kRadius20 + kRadius4 / 2,
                                          backgroundImage: AssetImage(
                                            'assets/images/job_match.jpg',
                                          ),
                                        ),
                                        const SizedBox(width: kSpacing12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              'Julio Cesar Nima',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Color(0xFF222B45),
                                              ),
                                            ),
                                            SizedBox(height: kSpacing4 / 2),
                                            Text(
                                              'Especialista en Comunicaciones',
                                              style: TextStyle(
                                                color: Color(0xFFB1B5C3),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: kSpacing12 + kSpacing4,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              SizedBox(height: kSpacing4),
                                              Text(
                                                'Teléfono:',
                                                style: TextStyle(
                                                  color: Color(0xFFB1B5C3),
                                                  fontSize: 13,
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    kSpacing8 + kSpacing4 / 2,
                                              ),
                                              Text(
                                                'Correo:',
                                                style: TextStyle(
                                                  color: Color(0xFFB1B5C3),
                                                  fontSize: 13,
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    kSpacing8 + kSpacing4 / 2,
                                              ),
                                              Text(
                                                'Sitio web:',
                                                style: TextStyle(
                                                  color: Color(0xFFB1B5C3),
                                                  fontSize: 13,
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    kSpacing8 + kSpacing4 / 2,
                                              ),
                                              Text(
                                                'LinkedIn:',
                                                style: TextStyle(
                                                  color: Color(0xFFB1B5C3),
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              SizedBox(height: kSpacing4),
                                              Text(
                                                '+51 912 345 678',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFF222B45),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    kSpacing8 + kSpacing4 / 2,
                                              ),
                                              Text(
                                                'julio.nima@email.com',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFF222B45),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    kSpacing8 + kSpacing4 / 2,
                                              ),
                                              Text(
                                                'www.julionima.com',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFF3366FF),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    kSpacing8 + kSpacing4 / 2,
                                              ),
                                              Text(
                                                'linkedin.com/in/julionima',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFF3366FF),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: kSpacing12 + kSpacing4,
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.facebook,
                                            color: Color(0xFF1877F3),
                                          ),
                                          onPressed: () {},
                                          tooltip: 'Facebook',
                                          splashRadius: kRadius20,
                                          iconSize: kIconSize24,
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.alternate_email,
                                            color: Color(0xFF1DA1F2),
                                          ),
                                          onPressed: () {},
                                          tooltip: 'Twitter',
                                          splashRadius: kRadius20,
                                          iconSize: kIconSize24,
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.camera_alt,
                                            color: Color(0xFF833AB4),
                                          ),
                                          onPressed: () {},
                                          tooltip: 'Instagram',
                                          splashRadius: kRadius20,
                                          iconSize: kIconSize24,
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.ondemand_video,
                                            color: Color(0xFF1976D2),
                                          ),
                                          onPressed: () {},
                                          tooltip: 'YouTube',
                                          splashRadius: kRadius20,
                                          iconSize: kIconSize24,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Spacing after the card, adjust if needed.
          // The original vertical padding was (kPadding20 + kSpacing4).
          // Since the card is pulled up by cardOverlap, we might need less or different spacing here.
          // If cardOverlap is 70 and original top padding for next section was ~32 (kPadding28+kSpacing4),
          // the effective space created by pulling up is 70.
          // The next section starts after this.
          SizedBox(
            height:
                (kPadding20 + kSpacing4) - cardOverlap > 0
                    ? (kPadding20 + kSpacing4) - cardOverlap + kPadding12
                    : kPadding12,
          ),

          Padding(
            padding: EdgeInsets.only(
              // top: kPadding28 + kSpacing4, // Original top padding
              bottom: kPadding12,
              left:
                  pageHorizontalPadding +
                  kPadding8, // Adjusted to align with card or be consistent
              right: pageHorizontalPadding,
            ),
            child: Row(
              children: [
                const Text(
                  'Compartir este perfil:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                    color: Color(0xFF222B45),
                  ),
                ),
                const SizedBox(width: kSpacing12 + kSpacing4),
                ProfileSocialShareButton(
                  color: const Color(0xFF1877F3),
                  icon: Icons.facebook,
                  label: 'Facebook',
                  onPressed: () {},
                ),
                ProfileSocialShareButton(
                  color: const Color(0xFF1DA1F2),
                  icon: Icons.alternate_email,
                  label: 'Twitter',
                  onPressed: () {},
                ),
                ProfileSocialShareButton(
                  color: const Color(0xFFE60023),
                  icon: Icons.push_pin,
                  label: 'Pinterest',
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: kPadding20, // Adjusted top padding
              bottom: kPadding16,
              left: pageHorizontalPadding + kPadding8, // Adjusted to align
              right: pageHorizontalPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trabajos Relacionados',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Color(0xFF222B45),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF3366FF),
                      ),
                      onPressed: () {},
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kRadius8),
                        ),
                      ),
                    ),
                    const SizedBox(width: kSpacing8),
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF3366FF),
                      ),
                      onPressed: () {},
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kRadius8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: pageHorizontalPadding,
            ), // Add horizontal padding to the GridView's parent
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 3;
                // Adjusted cardWidth calculation to use constraints.maxWidth which is now correctly padded
                double cardWidth =
                    (constraints.maxWidth -
                        (crossAxisCount - 1) * (kSpacing12 + kSpacing4)) /
                    crossAxisCount;
                double cardHeight = 180;

                if (screenSize.width < 900) crossAxisCount = 2;
                if (screenSize.width < 600) crossAxisCount = 1;
                cardWidth =
                    (constraints.maxWidth -
                        (crossAxisCount - 1) * (kSpacing12 + kSpacing4)) /
                    crossAxisCount;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: kSpacing12 + kSpacing4,
                    mainAxisSpacing: kSpacing12 + kSpacing4,
                    childAspectRatio: cardWidth / cardHeight,
                  ),
                  itemCount: relatedJobs.length,
                  itemBuilder: (context, index) {
                    return RelatedJobCard(job: relatedJobs[index]);
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: kPadding20 + kSpacing4,
          ), // Add some padding at the bottom
        ],
      ),
    );
  }
}
