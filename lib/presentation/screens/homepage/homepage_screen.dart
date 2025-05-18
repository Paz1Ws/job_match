import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_match/presentation/widgets/homepage/home_page_top_bar.dart';
import 'package:job_match/presentation/widgets/homepage/partner_icon.dart';
import 'package:job_match/presentation/widgets/homepage/stat_item.dart';

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
              HomePageTopBar(),
              Spacer(),
              Center(child: _buildHeroSection(context)),
              SizedBox(height: 60),
              _buildStatsSection(),
              Spacer(),
              _buildPartnersSection(),
              SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Column(
      children: [
        const Text(
          '¡Encuentra tu trabajo soñado hoy!',
          style: TextStyle(
            fontSize: 60,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Text(
          'Conectando talento con oportunidad: tu puerta al éxito profesional',
          style: TextStyle(fontSize: 18, color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        Container(
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
              _buildFindJobButton(context),
            ],
          ),
        ),
      ],
    );
  }

  ElevatedButton _buildFindJobButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.go('/homepage/find-job'),
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
      children: const [
        StatItem(icon: Icons.work_outline, count: '25,850', label: 'Empleos'),
        SizedBox(width: 60),
        StatItem(
          icon: Icons.people_outline,
          count: '10,250',
          label: 'Candidatos',
        ),
        SizedBox(width: 60),
        StatItem(icon: Icons.business, count: '18,400', label: 'Empresas'),
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
                  (e) => Row(
                    children: [
                      e.key,
                      const SizedBox(width: 20),
                      Text(
                        e.value,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )
                .toList(),
      ),
    );
  }
}