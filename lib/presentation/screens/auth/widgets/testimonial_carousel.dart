import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:job_match/presentation/screens/auth/widgets/testimonial_card.dart';

class TestimonialCarousel extends StatefulWidget {
  
  const TestimonialCarousel({super.key});

  @override
  State<TestimonialCarousel> createState() => _TestimonialCarouselState();
}

class _TestimonialCarouselState extends State<TestimonialCarousel> {
  final PageController _controller = PageController(
    viewportFraction: 0.55,
    initialPage: 1000, // A large number to simulate infinite scrolling
  );
  double _currentPage = 1000;

  final List<TestimonialData> testimonials = [
    TestimonialData(
      stars: 5,
      text:
          'JobMatch nos ayudó a encontrar ingenieros especializados en proyectos eléctricos y mecánicos. Su plataforma facilitó mucho nuestro proceso de selección.',
      logo: 'assets/images/carze.png',
      name: 'Carze',
    ),
    TestimonialData(
      stars: 5,
      text:
          'Gracias a JobMatch pudimos incorporar médicos especialistas y personal de enfermería altamente calificado. La calidad de los candidatos superó nuestras expectativas.',
      logo: 'assets/images/fresnos.png',
      name: 'Clínica Los Fresnos',
    ),
    TestimonialData(
      stars: 5,
      text:
          'JobMatch nos conectó con conductores especializados en materiales peligrosos y operadores de maquinaria pesada de primer nivel para nuestros 45 años de experiencia.',
      logo: 'assets/images/mcatalan.png',
      name: 'Transportes M. Catalán',
    ),
    TestimonialData(
      stars: 5,
      text:
          'Encontramos técnicos especializados en construcción civil, mecánica eléctrica y redes de comunicación. JobMatch entiende nuestras necesidades técnicas específicas.',
      logo: 'assets/images/dicesa.png',
      name: 'DICESA',
    ),
    TestimonialData(
      stars: 5,
      text:
          'La plataforma nos permitió contactar con profesionales que realmente comprenden los desafíos de la innovación y el desarrollo empresarial en Latinoamérica.',
      logo: 'assets/images/efecto_eureka.png',
      name: 'Efecto Eureka',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheTestimonialImages();
      _startAutoScroll();
    });
  }

  void _precacheTestimonialImages() {
    for (var testimonial in testimonials) {
      precacheImage(AssetImage(testimonial.logo), context);
    }
  }

  void _startAutoScroll() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 2500));
      if (!mounted) break;
      _currentPage += 1;
      _controller.animateToPage(
        _currentPage.toInt(),
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double cardWidth = 370;
    double cardPadding = 24;
    double fontSize = 17;
    double logoSize = 24;
    double nameFontSize = 17;

    if (width < 600) {
      cardWidth = width * 0.8;
      cardPadding = 12;
      fontSize = 14;
      logoSize = 20;
      nameFontSize = 15;
    } else if (width < 900) {
      cardWidth = 300;
      cardPadding = 16;
      fontSize = 15;
      logoSize = 22;
      nameFontSize = 16;
    }

    return SizedBox(
      height: width < 600 ? 180 : 220,
      child: PageView.builder(
        controller: _controller,
        itemBuilder: (context, index) {
          final int realIndex = index % testimonials.length;
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double selectedness = 0.0;
              if (_controller.position.hasContentDimensions) {
                selectedness =
                    ((_controller.page ?? _controller.initialPage) - index)
                        .toDouble();
                selectedness = (1 - (selectedness.abs() * 0.5)).clamp(0.7, 1.0);
              }
              return Center(
                child: Transform.scale(
                  scale: selectedness,
                  child: FadeIn(
                    // Add FadeIn animation here
                    duration: const Duration(milliseconds: 300),
                    child: TestimonialCard(
                      data: testimonials[realIndex],
                      width: cardWidth,
                      padding: cardPadding,
                      fontSize: fontSize,
                      logoSize: logoSize,
                      nameFontSize: nameFontSize,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}