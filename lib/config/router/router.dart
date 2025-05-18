import 'package:go_router/go_router.dart';
import 'package:job_match/config/util/go_router_animations.dart';
import 'package:job_match/presentation/screens/auth/screens/login_screen.dart';
import 'package:job_match/presentation/screens/dashboard/employer_dashboard_screen.dart';
import 'package:job_match/presentation/screens/homepage/find_jobs_screen.dart';
import 'package:job_match/presentation/screens/homepage/homepage_screen.dart';
import 'package:job_match/presentation/screens/jobs/job_detail_screen.dart';
import 'package:job_match/presentation/screens/profiles/company_profile_screen.dart';
import 'package:job_match/presentation/screens/profiles/user_profile.dart';
import 'package:job_match/presentation/screens/splash/splash_screen.dart';

import '../../core/domain/models/job_model.dart';

class MainRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => fadeTransitionPage(state, SplashScreen()),
      ),
      GoRoute(
        path: '/homepage',
        pageBuilder: (context, state) => fadeTransitionPage(state, HomepageScreen()),
        routes: [
          GoRoute(
            path: 'find-job',
            builder: (context, state) => FindJobsScreen(),
          )
        ]
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => fadeTransitionPage(state, LoginScreen()),
      ),
      GoRoute(
        path: '/user-profile',
        pageBuilder: (context, state) => fadeTransitionPage(state, UserProfile()),
      ),
      GoRoute(
        path: '/company-profile',
        pageBuilder: (context, state) => fadeTransitionPage(state, CompanyProfileScreen()),
      ),
      GoRoute(
        path: '/job-details',
        pageBuilder: (context, state) {
          final data = state.extra as Job;
          return fadeTransitionPage(state, JobDetailScreen(job: data));
        },
      ),
      GoRoute(
        path: '/employee-dashboard',
        pageBuilder: (context, state) => fadeTransitionPage(state, EmployerDashboardScreen()),
      ),
    ],
  );
}
