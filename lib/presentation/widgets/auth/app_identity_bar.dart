import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_match/config/config.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/presentation/screens/profiles/user_profile.dart';

class AppIdentityBar extends StatelessWidget {
  final double height;
  /// Between 0 and 4
  final int indexSelected;
  const AppIdentityBar({super.key, required this.height, required this.indexSelected});

  Widget _buildNavButton(String text, {required VoidCallback onPressed, bool selected = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: onPressed,
          child: Text(text, style: TextStyle(color: !selected ? Colors.grey[700] : Colors.blueAccent)),
        ),
        Container(
          height: 2,
          width: 40,
          color: selected ? Colors.blueAccent : Colors.transparent,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: kPadding16),
      child: Row(
        children: <Widget>[
          Container(
            padding: kPaddingAll8, // Adjusted from kPaddingAll10
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  'assets/images/job_match.jpg',
                  width: kIconSize24,
                  height: kIconSize24,
                ),
                const SizedBox(width: kSpacing8),
                const Text(
                  'JobMatch',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        kIconSize18, // Using kIconSize for font size as an example
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: kSpacing20 + kSpacing4), // kSpacing24
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  _buildNavButton('Home', onPressed: () {}, selected: indexSelected == 0),

                  _buildNavButton('Buscar Empleo', onPressed: () => context.go('/user-profile'), selected: indexSelected == 1),

                  _buildNavButton('Buscar Empleadores', onPressed: () => context.go('/company-profile'), selected: indexSelected == 2),

                  _buildNavButton('Panel', onPressed: () {
                    print(Config().accountType);
                    if (Config().accountType == AccountType.employee) { context.go('/employee-dashboard'); }
                    else { context.go('/candidate-dashboard'); }
                  }, selected: indexSelected == 3),

                  _buildNavButton('Alertas de Empleo', onPressed: () {}, selected: indexSelected == 4),

                  _buildNavButton('Soporte', onPressed: () {}, selected: indexSelected == 5),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.grey[700],
              size: kIconSize24 + kSpacing4,
            ), // kIconSize28
            onPressed: () {},
          ),
          const SizedBox(width: kSpacing8),
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: Colors.grey[700],
              size: kIconSize24 + kSpacing4, // kIconSize28
            ),
            onPressed: () {},
          ),
          const SizedBox(width: kSpacing12 + kSpacing4), // kSpacing16
          InkWell(
            onTap: () {
              context.go('/user-profile');
            },
            child: const CircleAvatar(
              backgroundColor: Colors.blueGrey,
              radius: kRadius20,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
