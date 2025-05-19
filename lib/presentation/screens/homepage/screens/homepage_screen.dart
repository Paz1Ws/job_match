import 'package:flutter/material.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/config/util/animations.dart';
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
  String? _selectedJob;
  String? _selectedLocation;
  String? _selectedCategory;

  final List<String> _jobOptions = [
    'Diseñador UI/UX',
    'Desarrollador Flutter',
    'Analista de Datos',
    'JobMatch',
    'MercadoTech',
    'Desarrollador Backend',
    'Project Manager',
    'QA Tester',
    'Community Manager',
    'Soporte Técnico',
    'Ingeniero DevOps',
    'Especialista SEO',
  ];

  final List<String> _locationOptions = [
    'Lima',
    'Arequipa',
    'Cusco',
    'Remoto',
    'Trujillo',
    'Piura',
    'Tacna',
    'Huancayo',
    'Chiclayo',
    'Iquitos',
    'Puno',
    'Callao',
  ];

  final List<String> _categoryOptions = [
    'Tecnología',
    'Diseño',
    'Marketing',
    'Administración',
    'Soporte Técnico',
    'Ventas',
    'Recursos Humanos',
    'Finanzas',
    'Legal',
    'Logística',
    'Educación',
    'Salud',
  ];

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
            Row(
              children: [
                FadeInRight(
                  duration: const Duration(milliseconds: 700),
                  child: TextButton(
                    onPressed:
                        () => Navigator.of(
                          context,
                        ).push(SlideUpFadePageRoute(page: const LoginScreen())),
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                FadeInRight(
                  duration: const Duration(milliseconds: 900),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                    ),
                    onPressed:
                        () => Navigator.of(
                          context,
                        ).push(SlideUpFadePageRoute(page: const LoginScreen())),
                    child: const Text('Registrarse'),
                  ),
                ),
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
              const Text(
                '¡Encuentra tu ',
                style: TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'trabajo',
                    speed: const Duration(milliseconds: 100),
                    textStyle: const TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TypewriterAnimatedText(
                    'compañero de trabajo',
                    speed: const Duration(milliseconds: 100),
                    textStyle: const TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                repeatForever: true,
                pause: const Duration(seconds: 2),
                displayFullTextOnTap: true,
                isRepeatingAnimation: true,
              ),
              const Text(
                'soñado hoy!',
                style: TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDropdownField(
                  'Puesto o Empresa',
                  showDivider: true,
                  items: _jobOptions,
                  value: _selectedJob,
                  onChanged: (val) => setState(() => _selectedJob = val),
                ),
                _buildDropdownField(
                  'Selecciona Ubicación',
                  showDivider: true,
                  items: _locationOptions,
                  value: _selectedLocation,
                  onChanged: (val) => setState(() => _selectedLocation = val),
                ),
                _buildDropdownField(
                  'Selecciona Categoría',
                  showDivider: false,
                  items: _categoryOptions,
                  value: _selectedCategory,
                  onChanged: (val) => setState(() => _selectedCategory = val),
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
        ).push(MaterialPageRoute(builder: (context) => const FindJobsScreen()));
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

  Widget _buildDropdownField(
    String hint, {
    bool showDivider = false,
    List<String> items = const [],
    String? value,
    ValueChanged<String?>? onChanged,
  }) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        border:
            showDivider
                ? const Border(
                  right: BorderSide(color: Colors.black12, width: 1),
                )
                : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(
            value ?? hint,
            style: const TextStyle(color: Colors.black54),
          ),
          items:
              items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FadeInLeft(
          duration: Duration(milliseconds: 900),
          child: StatItem(
            icon: Icons.work_outline,
            count: '25,850',
            label: 'Empleos',
          ),
        ),
        SizedBox(width: 60),
        FadeInUp(
          duration: Duration(milliseconds: 900),
          child: StatItem(
            icon: Icons.people_outline,
            count: '10,250',
            label: 'Candidatos',
          ),
        ),
        SizedBox(width: 60),
        FadeInRight(
          duration: Duration(milliseconds: 900),
          child: StatItem(
            icon: Icons.business,
            count: '18,400',
            label: 'Empresas',
          ),
        ),
      ],
    );
  }

  Widget _buildPartnersSection() {
    final logos = {
      PartnerIcon(partnerType: PartnerType.spotify): 'Spotify',
      PartnerIcon(partnerType: PartnerType.slack): 'Slack',
      PartnerIcon(partnerType: PartnerType.adobe): 'Adobe',
      PartnerIcon(partnerType: PartnerType.asana): 'Asana',
      PartnerIcon(partnerType: PartnerType.linear): 'Linear',
    };
    return Container(
      color: Colors.black,
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            logos.entries
                .map(
                  (e) => FadeInUp(
                    duration: const Duration(milliseconds: 900),
                    child: Row(
                      children: [
                        e.key,
                        const SizedBox(width: 20),
                        Text(
                          e.value,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}
