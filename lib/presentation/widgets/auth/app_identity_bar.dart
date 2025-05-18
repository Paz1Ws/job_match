import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/config/util/animations.dart';
import 'package:job_match/presentation/screens/homepage/find_jobs_screen.dart';
import 'package:job_match/presentation/screens/profiles/user_profile.dart';
import 'package:job_match/presentation/screens/profiles/company_profile_screen.dart';

import '../../screens/homepage/screens/homepage_screen.dart';

// Provider to control user type (candidate or company)
final isCandidateProvider = StateProvider<bool>((ref) => true);

class AppIdentityBar extends ConsumerWidget {
  final double height;
  final VoidCallback? onProfileTap;

  const AppIdentityBar({super.key, required this.height, this.onProfileTap});

  Widget _buildNavButton(String text, {required VoidCallback onPressed}) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: Colors.grey[700])),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCandidate = ref.watch(isCandidateProvider);

    return Container(
      height: height,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: kPadding16),
      child: Row(
        children: <Widget>[
          Container(
            padding: kPaddingAll8,
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
                    fontSize: kIconSize18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: kSpacing20 + kSpacing4),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  _buildNavButton(
                    'Home',
                    onPressed: () {
                      Navigator.of(context).push(
                        SlideUpFadePageRoute(page: const HomepageScreen()),
                      );
                    },
                  ),
                  _buildNavButton(
                    'Buscar Empleo',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FindJobsScreen(),
                        ),
                      );
                    },
                  ),
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
            ),
            onPressed: () {},
          ),
          const SizedBox(width: kSpacing8),
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: Colors.grey[700],
              size: kIconSize24 + kSpacing4,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: kSpacing12 + kSpacing4),
          InkWell(
            onTap:
                onProfileTap ??
                () {
                  if (isCandidate) {
                    Navigator.of(
                      context,
                    ).push(SlideUpFadePageRoute(page: const UserProfile()));
                  } else {
                    Navigator.of(context).push(
                      SlideUpFadePageRoute(page: const CompanyProfileScreen()),
                    );
                  }
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
