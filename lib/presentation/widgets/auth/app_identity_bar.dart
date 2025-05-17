import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/presentation/screens/profiles/user_profile.dart';

class AppIdentityBar extends StatelessWidget {
  final double height;
  const AppIdentityBar({super.key, required this.height});

  Widget _buildNavButton(String text, {required VoidCallback onPressed}) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: Colors.grey[700])),
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
                  _buildNavButton('Home', onPressed: () {}),
                  _buildNavButton('Buscar Empleo', onPressed: () {}),
                  _buildNavButton('Buscar Empleadores', onPressed: () {}),
                  _buildNavButton('Panel', onPressed: () {}),
                  _buildNavButton('Alertas de Empleo', onPressed: () {}),
                  _buildNavButton('Soporte', onPressed: () {}),
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
