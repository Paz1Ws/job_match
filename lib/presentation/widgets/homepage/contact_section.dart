import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactSection extends StatefulWidget {
  final BoxConstraints constraints;
  final Size size;

  const ContactSection({
    super.key,
    required this.constraints,
    required this.size,
  });

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  @override
  Widget build(BuildContext context) {
    final isNarrow = widget.constraints.maxWidth < 900;

    return Container(
      child: Stack(
        children: [
          // Gradient spheres background
          Positioned.fill(child: _buildGradientSpheresBackground()),
          // Main content
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isNarrow ? double.infinity : 800,
              ),
              child: _buildContactInfo(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientSpheresBackground() {
    return Stack(
      children: [
        // Large Neon Orange sphere - positioned more inward from top left
        Positioned(
          top: 60,
          left: 100,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFF6B35).withOpacity(0.5), // Neon orange
                  const Color(0xFFFF8C42).withOpacity(0.3),
                  const Color(0xFFFFB347).withOpacity(0.15),
                  const Color(0xFFFF6B35).withOpacity(0.05),
                  Colors.transparent,
                ],
                stops: const [0.1, 0.25, 0.5, 0.75, 1.0],
              ),
            ),
          ),
        ),
        // Large Neon Blue sphere - positioned more inward from bottom right
        Positioned(
          bottom: 60,
          right: 80,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF00D4FF).withOpacity(0.45), // Neon blue
                  const Color(0xFF1E90FF).withOpacity(0.25),
                  const Color(0xFF4169E1).withOpacity(0.12),
                  const Color(0xFF00D4FF).withOpacity(0.04),
                  Colors.transparent,
                ],
                stops: const [0.15, 0.3, 0.6, 0.8, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    final isNarrow = widget.constraints.maxWidth < 900;
    final isMobile = widget.constraints.maxWidth < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FadeInLeft(
          duration: const Duration(milliseconds: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '¿Listo Para Encontrar',
                style: TextStyle(
                  fontSize:
                      isMobile
                          ? 28
                          : isNarrow
                          ? 36
                          : 46,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Tu Próxima Oportunidad?',
                    speed: const Duration(milliseconds: 100),
                    textStyle: TextStyle(
                      fontSize:
                          isMobile
                              ? 28
                              : isNarrow
                              ? 36
                              : 46,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                  ),
                  TypewriterAnimatedText(
                    'El Talento Adecuado?',
                    speed: const Duration(milliseconds: 100),
                    textStyle: TextStyle(
                      fontSize:
                          isMobile
                              ? 28
                              : isNarrow
                              ? 36
                              : 46,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                  ),
                ],
                totalRepeatCount: 100,
                pause: const Duration(seconds: 2),
                displayFullTextOnTap: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FadeInLeft(
          duration: const Duration(milliseconds: 1000),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
            child: Text(
              'En JobMatch estamos aquí para ayudarte. Ya sea que busques el trabajo de tus sueños o necesites encontrar el candidato perfecto para tu empresa, nuestro equipo de expertos está disponible para guiarte en cada paso del proceso.',
              style: TextStyle(
                fontSize: isMobile ? 14 : 15,
                color: Colors.grey.shade600,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Contact items in responsive grid
        _buildContactGrid(isMobile, isNarrow),
      ],
    );
  }

  Widget _buildContactGrid(bool isMobile, bool isNarrow) {
    final contactItems = [
      {
        'icon': Icons.phone,
        'title': 'Llámanos o escríbenos por WhatsApp',
        'info': '+51 976 228 222',
        'action': () => _launchWhatsApp('+51976228222'),
      },
      {
        'icon': Icons.email,
        'title': 'Envíanos un email',
        'info': 'contacto@jobmatch.pe',
        'action': () => _launchEmail('contacto@jobmatch.pe'),
      },
      {
        'icon': Icons.access_time,
        'title': 'Horario de atención',
        'info': '24/7',
        'action': null,
      },
      {
        'icon': Icons.location_on,
        'title': 'Somos de',
        'info': 'Cajamarca, Perú',
        'action': null,
      },
    ];

    if (isMobile) {
      return Column(
        children:
            contactItems.asMap().entries.map((entry) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: entry.key < contactItems.length - 1 ? 24 : 0,
                ),
                child: FadeInLeft(
                  duration: Duration(milliseconds: 1200 + (entry.key * 200)),
                  child: _buildContactItem(
                    icon: entry.value['icon'] as IconData,
                    title: entry.value['title'] as String,
                    info: entry.value['info'] as String,
                    color: Colors.teal,
                    isCentered: true,
                    onTap: entry.value['action'] as VoidCallback?,
                  ),
                ),
              );
            }).toList(),
      );
    } else {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 40,
        runSpacing: 24,
        children:
            contactItems.asMap().entries.map((entry) {
              return SizedBox(
                width: isNarrow ? 300 : 350,
                child: FadeInLeft(
                  duration: Duration(milliseconds: 1200 + (entry.key * 200)),
                  child: _buildContactItem(
                    icon: entry.value['icon'] as IconData,
                    title: entry.value['title'] as String,
                    info: entry.value['info'] as String,
                    color: Colors.teal,
                    isCentered: false,
                    onTap: entry.value['action'] as VoidCallback?,
                  ),
                ),
              );
            }).toList(),
      );
    }
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String info,
    required Color color,
    bool isCentered = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isCentered ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isCentered
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: isCentered ? TextAlign.center : TextAlign.left,
                ),
                const SizedBox(height: 4),
                Text(
                  info,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color:
                        onTap != null
                            ? const Color.fromARGB(255, 11, 117, 210)
                            : Colors.grey.shade700,
                  ),
                  textAlign: isCentered ? TextAlign.center : TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final url = 'https://wa.me/$phoneNumber';
    try {
      await launchUrlString(url);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir WhatsApp'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _launchEmail(String email) async {
    final url =
        'mailto:$email?subject=Consulta desde JobMatch&body=Hola, me gustaría obtener más información sobre JobMatch.';
    try {
      await launchUrlString(url);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir el cliente de correo'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
