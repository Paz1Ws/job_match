import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_match/presentation/screens/homepage/widgets/home_page_top_bar.dart';
import 'package:job_match/presentation/screens/homepage/widgets/partner_icon.dart';
import 'package:job_match/presentation/screens/homepage/widgets/stat_item.dart';

class HomepageScreen extends StatelessWidget {
  const HomepageScreen({super.key});

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

          //* content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomePageTopBar(),
              Spacer(),
              Center(child: _buildHeroSection(context)),
              SizedBox(height: 40),
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
            fontSize: 50,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        const Text(
          'Conectando talento con oportunidad: tu puerta al éxito profesional',
          style: TextStyle(fontSize: 14, color: Colors.white70),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 30),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDropdownField('Puesto o Empresa', showDivider: true),
              _buildDropdownField('Selecciona Ubicación', showDivider: true),
              _buildDropdownField('Selecciona Categoría', showDivider: false),

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

  Widget _buildDropdownField(String hint, {bool showDivider = false}) {
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
          hint: Text(hint, style: const TextStyle(color: Colors.black54)),
          items: const [],
          onChanged: (value) {},
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
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            logos.entries
                .map(
                  (e) => Row(
                    children: [
                      e.key,
                      const SizedBox(width: 5),
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