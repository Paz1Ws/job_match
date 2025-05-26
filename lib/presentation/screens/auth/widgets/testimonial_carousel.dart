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
          'La búsqueda de proveedores de nuestro sistema web fue clave después de obtener el fondo Mipymes Digitales, además hicieron un gran diagnóstico digital inicial.',
      logo: 'assets/images/mcatalan.png',
      name: 'MCatalan',
    ),
    TestimonialData(
      stars: 5,
      text:
          'Buscamos la asesoría de IncaValley para obtener el fondo de Startup Perú, entendieron rápidamente nuestros objetivos de crecimiento en Latam y fue una gran experiencia el postular con expertos en formulación.',
      logo: 'assets/images/fresnos.png',
      name: 'Fresnos',
    ),
    TestimonialData(
      stars: 5,
      text:
          'Gracias al equipo de consultores se pudo moldear la propuesta de innovación considerando variables que sumaron al proyecto y al Diagnóstico Empresarial.',
      logo: 'assets/images/carze.png',
      name: 'Carze',
    ),
    TestimonialData(
      stars: 5,
      text:
          'El acompañamiento y la experiencia del equipo fue fundamental para lograr nuestros objetivos de innovación.',
      logo: 'assets/images/efecto_eureka.png',
      name: 'Efecto Eureka',
    ),
    TestimonialData(
      stars: 5,
      text:
          'El soporte y la dedicación del equipo nos permitió crecer y mejorar nuestros procesos.',
      logo: 'assets/images/dicesa.png',
      name: 'Dicesa',
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