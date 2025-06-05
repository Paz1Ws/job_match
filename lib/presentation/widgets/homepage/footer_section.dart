import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class FooterSection extends StatelessWidget {
  final BoxConstraints constraints;
  final Size size;

  const FooterSection({
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
      color: const Color(0xFF1A1A1A),
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 20 : 60,
        vertical: isNarrow ? 40 : 60,
      ),
      child: Column(
        children: [
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            child:
                isNarrow
                    ? _buildMobileFooterContent()
                    : _buildDesktopFooterContent(isTablet),
          ),
          const SizedBox(height: 40),
          _buildFooterBottom(),
        ],
      ),
    );
  }

  Widget _buildMobileFooterContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildJobSection(),
        const SizedBox(height: 32),
        _buildCompanySection(),
        const SizedBox(height: 32),
        _buildJobCategoriesSection(),
        const SizedBox(height: 32),
        _buildNewsletterSection(isMobile: true),
      ],
    );
  }

  Widget _buildDesktopFooterContent(bool isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildJobSection()),
        const SizedBox(width: 40),
        Expanded(flex: 1, child: _buildCompanySection()),
        const SizedBox(width: 40),
        Expanded(flex: 1, child: _buildJobCategoriesSection()),
        const SizedBox(width: 40),
        Expanded(flex: 2, child: _buildNewsletterSection(isMobile: false)),
      ],
    );
  }

  Widget _buildJobSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/job_match_transparent.png',
              width: 36,
              height: 36,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            const Text(
              'JobMatch',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Conectamos el talento con las mejores oportunidades laborales. Encuentra tu trabajo ideal o el candidato perfecto para tu empresa.',
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCompanySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Empresa',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildFooterLink('Acerca de Nosotros'),
        const SizedBox(height: 12),
        _buildFooterLink('Nuestro Equipo'),
        const SizedBox(height: 12),
        _buildFooterLink('Socios'),
        const SizedBox(height: 12),
        _buildFooterLink('Para Candidatos'),
        const SizedBox(height: 12),
        _buildFooterLink('Para Empleadores'),
      ],
    );
  }

  Widget _buildJobCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categorías de Empleo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildFooterLink('Tecnología'),
        const SizedBox(height: 12),
        _buildFooterLink('Marketing & Ventas'),
        const SizedBox(height: 12),
        _buildFooterLink('Construcción'),
        const SizedBox(height: 12),
        _buildFooterLink('Educación'),
        const SizedBox(height: 12),
        _buildFooterLink('Servicios Financieros'),
      ],
    );
  }

  Widget _buildNewsletterSection({required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Newsletter',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Mantente al día con las últimas oportunidades laborales y consejos profesionales.',
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade600),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Correo electrónico',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(4),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Suscribirse',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLink(String text) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildFooterBottom() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade700, width: 1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© Copyright JobMatch 2025. Diseñado por JobMatch Team',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              Row(
                children: [
                  _buildBottomLink('Política de Privacidad'),
                  const SizedBox(width: 20),
                  _buildBottomLink('Términos & Condiciones'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomLink(String text) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 12,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
