import 'package:flutter/material.dart';
import 'package:job_match/presentation/widgets/job_match_widget.dart';

class FooterFindJobs extends StatelessWidget {
  const FooterFindJobs({ super.key });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 600) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildFooterColumns(context),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildFooterColumns(context),
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildFooterColumns(BuildContext context) {
    return [
      _buildLogoAndDescription(context),
      _buildCompanyLinks(),
      _buildJobCategories(),
      _buildNewsletterSubscription(),
    ];
  }

  Widget _buildLogoAndDescription(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          JobMatchWidget(),
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
            style: TextStyle(
              color: Colors.white60,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyLinks() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          _TextLink(text: 'Acerca de nosotros'),
          _TextLink(text: 'Nuestro equipo'),
          _TextLink(text: 'Socios'),
          _TextLink(text: 'Para candidatos'),
          _TextLink(text: 'Para empleadores'),
        ],
      ),
    );
  }

  Widget _buildJobCategories() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          _TextLink(text: 'Telecomunicaciones'),
          _TextLink(text: 'Hotelería y Turismo'),
          _TextLink(text: 'Construcción'),
          _TextLink(text: 'Educación'),
          _TextLink(text: 'Servicios Financieros'),
        ],
      ),
    );
  }

  Widget _buildNewsletterSubscription() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Text(
            'Recibe las últimas ofertas de empleo y noticias del sector.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.0,
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
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
          const SizedBox(height: 12.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
              },
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
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          _BottomBar()
        ],
      ),
    );
  }
}

class _TextLink extends StatelessWidget {
  final String text;
  const _TextLink({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () {
        },
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.white70,fontSize: 12.0,
      decoration: TextDecoration.underline,
      decorationColor: Colors.white70
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
                onTap: () {
                },
                child: const Text('Política de Privacidad', style: textStyle,
                ),
              ),
              const SizedBox(width: 16.0),
              InkWell(
                onTap: () {
                },
                child: const Text('Términos y Condiciones', style: textStyle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}