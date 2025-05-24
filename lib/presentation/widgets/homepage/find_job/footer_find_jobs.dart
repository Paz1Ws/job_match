import 'package:flutter/material.dart';
import 'package:job_match/presentation/widgets/homepage/partner_icon.dart';
import 'package:job_match/presentation/widgets/homepage/stat_item.dart';
import 'package:job_match/presentation/widgets/text_link.dart';
import 'package:animate_do/animate_do.dart';

class FooterFindJobs extends StatelessWidget {
  const FooterFindJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 600) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Add this to fix the error
              children: _buildFooterColumns(context),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,

              mainAxisSize: MainAxisSize.min, // Add this to fix the error
              children: _buildFooterColumns(context),
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildFooterColumns(BuildContext context) {
    final columnContents = [
      _buildLogoAndDescriptionColumn(context),
      _buildCompanyLinksColumn(),
      _buildJobCategoriesColumn(),
      _buildNewsletterSubscriptionColumn(),
    ];

    return columnContents.asMap().entries.map((entry) {
      int idx = entry.key;
      Widget columnContent = entry.value;
      // Replace Expanded with Flexible and set fit to loose
      return Flexible(
        fit: FlexFit.loose,
        child: FadeInUp(
          delay: Duration(milliseconds: 150 * idx),
          duration: const Duration(milliseconds: 500),
          child: columnContent,
        ),
      );
    }).toList();
  }

  Widget _buildLogoAndDescriptionColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        // JobMatchWidget(),
        const SizedBox(height: 16.0),
        const SizedBox(
          width: 250.0,
          child: Text(
            'Descubre las mejores oportunidades laborales y encuentra el talento ideal para tu empresa.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.0,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 60),
        const Text(
          '© Copyright Job Match 2025',
          style: TextStyle(color: Colors.white60, fontSize: 12.0),
        ),
      ],
    );
  }

  Widget _buildCompanyLinksColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,

      children: const [
        Text(
          'Compañía',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 8.0),
        TextLink(
          text: 'Acerca de nosotros',
          normalColor: Colors.white70,
          hoverColor: Colors.white,
        ),
        SizedBox(height: 5.0), // Added for spacing
        TextLink(
          text: 'Nuestro equipo',
          normalColor: Colors.white70,
          hoverColor: Colors.white,
        ),
        SizedBox(height: 5.0), // Added for spacing
        TextLink(
          text: 'Socios',
          normalColor: Colors.white70,
          hoverColor: Colors.white,
        ),
        SizedBox(height: 5.0), // Added for spacing
        TextLink(
          text: 'Para candidatos',
          normalColor: Colors.white70,
          hoverColor: Colors.white,
        ),
        SizedBox(height: 5.0), // Added for spacing
        TextLink(
          text: 'Para empleadores',
          normalColor: Colors.white70,
          hoverColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildJobCategoriesColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,

      children: const [
        Text(
          'Categorías de empleo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 8.0),
        TextLink(
          text: 'Telecomunicaciones',
          normalColor: Colors.white70,
          hoverColor: Colors.white,
        ),
        SizedBox(height: 5.0), // Added for spacing
        TextLink(
          text: 'Hotelería y Turismo',
          normalColor: Colors.white70,
          hoverColor: Colors.white,
        ),
        SizedBox(height: 5.0), // Added for spacing
        TextLink(
          text: 'Construcción',
          normalColor: Colors.white70,
          hoverColor: Colors.white,
        ),
        SizedBox(height: 5.0), // Added for spacing
        TextLink(
          text: 'Educación',
          normalColor: Colors.white70,
          hoverColor: Colors.white,
        ),
        SizedBox(height: 5.0), // Added for spacing
        TextLink(
          text: 'Servicios Financieros',
          normalColor: Colors.white70,
          hoverColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildNewsletterSubscriptionColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Newsletter',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 8.0),
        const Text(
          'Recibe las últimas ofertas de empleo y noticias del sector.',
          style: TextStyle(color: Colors.white70, fontSize: 12.0),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          width: double.infinity,
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Tu correo electrónico',
              hintStyle: const TextStyle(color: Colors.white54),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white38),
                borderRadius: BorderRadius.circular(5.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white38),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.orangeAccent),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12.0),
        FadeIn(
          delay: const Duration(milliseconds: 600),
          duration: const Duration(milliseconds: 500),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: const Text(
                'Suscríbete ahora',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        FadeInUp(
          delay: const Duration(milliseconds: 700),
          duration: const Duration(milliseconds: 500),
          child: const _BottomBar(),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.white70,
      fontSize: 12.0,
      decoration: TextDecoration.underline,
      decorationColor: Colors.white70,
    );

    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox.shrink(),
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: const Text('Política de Privacidad', style: textStyle),
              ),
              const SizedBox(width: 16.0),
              InkWell(
                onTap: () {},
                child: const Text('Términos y Condiciones', style: textStyle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
