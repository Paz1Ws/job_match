import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_match/presentation/widgets/homepage/home_page_top_bar_button.dart';
import 'package:job_match/presentation/widgets/job_match_widget.dart';

class HomePageTopBar extends StatelessWidget {
  const HomePageTopBar({ super.key });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            JobMatchWidget(),
            Row(
              children: [
                HomePageTopBarButton(title: 'Inicio', selected: true),
                HomePageTopBarButton(title: 'Empleos'),
                HomePageTopBarButton(title: 'Sobre Nosotros'),
                HomePageTopBarButton(title: 'Contáctanos'),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text(
                    'Iniciar Sesión',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                  ),
                  onPressed: () => context.go('/login'),
                  child: const Text('Registrarse'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}