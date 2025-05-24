import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/config/util/animations.dart';
import 'package:job_match/core/data/auth_request.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCandidate = ref.watch(isCandidateProvider);
    final company = ref.watch(companyProfileProvider);

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: kPadding16),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                FadeThroughPageRoute(page: const HomepageScreen()),
                (route) => false,
              );
            },
            child: Image.asset(
              'assets/images/job_match_black.png',
              width: kIconSize48,
              height: kIconSize48,
            ),
          ),
          Spacer(),

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
            child: CircleAvatar(
              backgroundColor: Colors.blueGrey,
              radius: kRadius20,
              backgroundImage:
                  !isCandidate && company?.logo != null
                      ? NetworkImage(company!.logo!)
                      : null,
              child:
                  !isCandidate && company?.logo != null
                      ? null
                      : const Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
