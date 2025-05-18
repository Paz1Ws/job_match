import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/presentation/widgets/auth/app_identity_bar.dart';
import 'package:job_match/presentation/widgets/auth/profile_display_elements.dart';
import 'package:job_match/config/constants/layer_constants.dart';

class JobDetailScreen extends StatelessWidget {
  final Job job;
  const JobDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    const double appIdentityBarHeight = 70.0;
    return Scaffold(
      body: Column(
        children: [
          AppIdentityBar(height: appIdentityBarHeight, indexSelected: 1),
          Expanded(
            child: SingleChildScrollView(child: JobDetailHeader(job: job)),
          ),
        ],
      ),
    );
  }
}

class JobDetailHeader extends StatelessWidget {
  final Job job;
  const JobDetailHeader({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final double bannerHeight = 220.0;
    final double cardOverlap = 70.0;
    final double pageHorizontalPadding = kPadding28 + kSpacing4;

    // Simulación de datos adicionales
    final String companyWebsite = "https://empresa.com";
    final String companyEmail = "contacto@empresa.com";
    final String companyPhone = "(01) 234-5678";
    final String companyFounded = "12 de febrero, 2010";
    final String companyType = "Privada";
    final String companySize = "120-300 empleados";
    final String companyDescription =
        "Empresa líder en el sector de comunicaciones y marketing digital.";

    return Container(
      color: const Color(0xFFF7F8FA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          SizedBox(
            height: bannerHeight,
            width: double.infinity,
            child: Image.asset('assets/images/work.png', fit: BoxFit.cover),
          ),
          // Card principal
          Transform.translate(
            offset: Offset(0, -cardOverlap),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: pageHorizontalPadding),
              child: Container(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header principal
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: kRadius20 + kRadius12,
                          backgroundImage:
                              job.logoAsset.startsWith('assets/')
                                  ? AssetImage(job.logoAsset)
                                  : null,
                          backgroundColor: job.logoBackgroundColor,
                          child:
                              job.logoAsset.startsWith('assets/')
                                  ? null
                                  : Icon(
                                    Icons.business,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                        ),
                        const SizedBox(width: kSpacing20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      job.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.0,
                                        color: Color(0xFF222B45),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  if (job.isFeatured)
                                    const InfoChip(
                                      label: 'Destacado',
                                      backgroundColor: Color(0xFFFFA500),
                                      textColor: Colors.white,
                                    ),
                                  const SizedBox(width: 8.0),
                                  InfoChip(
                                    label: job.type,
                                    backgroundColor: const Color(0xFF3366FF),
                                    textColor: Colors.white,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14.0),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    IconTextRow(
                                      icon: Icons.link,
                                      text: companyWebsite,
                                    ),
                                    SizedBox(width: screenSize.width * 0.04),
                                    IconTextRow(
                                      icon: Icons.phone,
                                      text: companyPhone,
                                    ),
                                    SizedBox(width: screenSize.width * 0.04),
                                    IconTextRow(
                                      icon: Icons.email,
                                      text: companyEmail,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: kSpacing20),
                        Row(
                          children: [
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
                                  'Aplicar Ahora',
                                  style: TextStyle(fontSize: 15),
                                ),
                                onPressed: () => context.push('/job-details/apply', extra: job.title),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
                      child: Row(
                        children: [
                          const Spacer(),
                          Text(
                            'El empleo expira en: ',
                            style: const TextStyle(
                              color: Color(0xFFB1B5C3),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '30 Junio, 2024',
                            style: const TextStyle(
                              color: Color(0xFFFD346E),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Descripción y overview
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Descripción del trabajo (izquierda)
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SectionTitle(
                                text: 'Descripción del Puesto',
                              ),
                              const JustifiedText(
                                text:
                                    'Buscamos un profesional apasionado por las comunicaciones para liderar proyectos de alto impacto en el sector. Deberá gestionar campañas, coordinar equipos y asegurar la coherencia de la imagen institucional. Se valorará experiencia en medios digitales, redacción creativa y manejo de crisis.',
                              ),
                              const SectionTitle(text: 'Responsabilidades'),
                              const BulletPointItem(
                                text:
                                    'Gestionar campañas de comunicación interna y externa.',
                              ),
                              const BulletPointItem(
                                text:
                                    'Coordinar equipos de trabajo multidisciplinarios.',
                              ),
                              const BulletPointItem(
                                text:
                                    'Redactar comunicados, notas de prensa y contenidos digitales.',
                              ),
                              const BulletPointItem(
                                text:
                                    'Supervisar la presencia de la marca en medios y redes sociales.',
                              ),
                              const BulletPointItem(
                                text:
                                    'Desarrollar estrategias para manejo de crisis.',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: kSpacing30 + kSpacing4 / 2),
                        // Overview y contacto empresa (derecha)
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              // Overview
                              Container(
                                padding: kPaddingAll20,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F8FA),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    kRadius12 + kRadius4 / 2,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Resumen del Puesto',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF222B45),
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    Wrap(
                                      runSpacing: 18,
                                      spacing: 32,
                                      children: [
                                        ProfileOverviewItem(
                                          icon: Icons.calendar_today,
                                          label: 'Publicado',
                                          value: '14 Junio, 2024',
                                        ),
                                        ProfileOverviewItem(
                                          icon: Icons.access_time,
                                          label: 'Expira',
                                          value: '30 Junio, 2024',
                                        ),
                                        ProfileOverviewItem(
                                          icon: Icons.school,
                                          label: 'Educación',
                                          value: 'Graduado',
                                        ),
                                        ProfileOverviewItem(
                                          icon: Icons.attach_money,
                                          label: 'Salario',
                                          value: job.salary,
                                        ),
                                        ProfileOverviewItem(
                                          icon: Icons.location_on,
                                          label: 'Ubicación',
                                          value: job.location,
                                        ),
                                        ProfileOverviewItem(
                                          icon: Icons.work,
                                          label: 'Tipo',
                                          value: job.type,
                                        ),
                                        ProfileOverviewItem(
                                          icon: Icons.timeline,
                                          label: 'Experiencia',
                                          value: '5-10 años',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Información de la empresa
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F8FA),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
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
                                        CircleAvatar(
                                          radius: kRadius20 + kRadius4 / 2,
                                          backgroundImage:
                                              job.logoAsset.startsWith(
                                                    'assets/',
                                                  )
                                                  ? AssetImage(job.logoAsset)
                                                  : null,
                                          backgroundColor:
                                              job.logoBackgroundColor,
                                          child:
                                              job.logoAsset.startsWith(
                                                    'assets/',
                                                  )
                                                  ? null
                                                  : Icon(
                                                    Icons.business,
                                                    color: Colors.white,
                                                    size: 22,
                                                  ),
                                        ),
                                        const SizedBox(width: kSpacing12),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                job.companyName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Color(0xFF222B45),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                companyDescription,
                                                style: const TextStyle(
                                                  color: Color(0xFFB1B5C3),
                                                  fontSize: 13,
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
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
                                              SizedBox(height: 4),
                                              Text(
                                                'Fundada:',
                                                style: TextStyle(
                                                  color: Color(0xFFB1B5C3),
                                                  fontSize: 13,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Tipo:',
                                                style: TextStyle(
                                                  color: Color(0xFFB1B5C3),
                                                  fontSize: 13,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Tamaño:',
                                                style: TextStyle(
                                                  color: Color(0xFFB1B5C3),
                                                  fontSize: 13,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Teléfono:',
                                                style: TextStyle(
                                                  color: Color(0xFFB1B5C3),
                                                  fontSize: 13,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Correo:',
                                                style: TextStyle(
                                                  color: Color(0xFFB1B5C3),
                                                  fontSize: 13,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Sitio web:',
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
                                            children: [
                                              const SizedBox(height: 4),
                                              Text(
                                                companyFounded,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFF222B45),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                companyType,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFF222B45),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                companySize,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFF222B45),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                companyPhone,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFF222B45),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                companyEmail,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFF222B45),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                companyWebsite,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFF3366FF),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.facebook,
                                            color: Color(0xFF1877F3),
                                          ),
                                          onPressed: () {},
                                          tooltip: 'Facebook',
                                          splashRadius: 20,
                                          iconSize: 24,
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.alternate_email,
                                            color: Color(0xFF1DA1F2),
                                          ),
                                          onPressed: () {},
                                          tooltip: 'Twitter',
                                          splashRadius: 20,
                                          iconSize: 24,
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.camera_alt,
                                            color: Color(0xFF833AB4),
                                          ),
                                          onPressed: () {},
                                          tooltip: 'Instagram',
                                          splashRadius: 20,
                                          iconSize: 24,
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.ondemand_video,
                                            color: Color(0xFF1976D2),
                                          ),
                                          onPressed: () {},
                                          tooltip: 'YouTube',
                                          splashRadius: 20,
                                          iconSize: 24,
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
          SizedBox(
            height:
                (kPadding20 + kSpacing4) - cardOverlap > 0
                    ? (kPadding20 + kSpacing4) - cardOverlap + kPadding12
                    : kPadding12,
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: kPadding12,
              left: pageHorizontalPadding + kPadding8,
              right: pageHorizontalPadding,
            ),
            child: Row(
              children: [
                const Text(
                  'Compartir este empleo:',
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
        ],
      ),
    );
  }
}
