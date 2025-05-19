import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/presentation/widgets/auth/app_identity_bar.dart';
import 'package:job_match/presentation/widgets/auth/profile_display_elements.dart';
import 'package:job_match/presentation/widgets/auth/related_job_card.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/presentation/screens/dashboard/employer_dashboard_screen.dart'; // For navigation example
import 'package:job_match/config/util/animations.dart';

class CompanyProfileScreen extends StatelessWidget {
  const CompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double appIdentityBarHeight = 70.0;

    return Scaffold(
      body: Column(
        children: <Widget>[
          AppIdentityBar(height: appIdentityBarHeight, onProfileTap: () {}),
          Expanded(child: SingleChildScrollView(child: CompanyProfileHeader())),
        ],
      ),
    );
  }
}

class CompanyProfileHeader extends ConsumerWidget {
  const CompanyProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.sizeOf(context);
    final double bannerHeight = 220.0;
    final double cardOverlap = 70.0;
    final double pageHorizontalPadding = kPadding28 + kSpacing4;

    // Usar jobsProvider para mostrar trabajos relacionados a la empresa
    final jobsAsync = ref.watch(jobsProvider);

    return Container(
      color: const Color(0xFFF7F8FA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FadeInDownBig(
            duration: const Duration(milliseconds: 700),
            child: SizedBox(
              height: bannerHeight,
              width: double.infinity,
              child: Image.asset(
                'assets/images/jobmatch_background.jpg', // Company specific banner
                fit: BoxFit.cover,
              ),
            ),
          ),
          FadeInUp(
            duration: const Duration(milliseconds: 700),
            child: Transform.translate(
              offset: Offset(0, -cardOverlap),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: pageHorizontalPadding,
                ),
                child: Container(
                  padding: const EdgeInsets.all(kPadding28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(kRadius12 + kRadius4),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: kStroke1 * 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.07),
                        spreadRadius: kStroke1,
                        blurRadius: kSpacing8,
                        offset: const Offset(0, kSpacing4 / 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeIn(
                        duration: const Duration(milliseconds: 700),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.blue,
                              ),
                              onPressed: () => Navigator.of(context).maybePop(),
                              tooltip: 'Atrás',
                            ),
                            BounceInDown(
                              duration: const Duration(milliseconds: 900),
                              child: CircleAvatar(
                                radius: kRadius20 + kRadius12,
                                backgroundImage: const AssetImage(
                                  'assets/images/job_match.jpg',
                                ),
                              ),
                            ),
                            const SizedBox(width: kSpacing20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  FadeInLeft(
                                    duration: const Duration(milliseconds: 700),
                                    child: const Text(
                                      'JobMatch Recruiting',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.0,
                                        color: Color(0xFF222B45),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: kSpacing4),
                                  FadeInLeft(
                                    delay: const Duration(milliseconds: 200),
                                    duration: const Duration(milliseconds: 700),
                                    child: const Text(
                                      'Connecting Talent with Opportunity', // Company Tagline
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Color(0xFF6C757D),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: kSpacing12),
                                  FadeInLeft(
                                    delay: const Duration(milliseconds: 300),
                                    duration: const Duration(milliseconds: 700),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          const IconTextRow(
                                            icon: Icons.link,
                                            text: 'www.jobmatch.com',
                                          ),
                                          SizedBox(
                                            width: screenSize.width * 0.03,
                                          ),
                                          const IconTextRow(
                                            icon: Icons.phone,
                                            text: '+51 1 555 0101',
                                          ),
                                          SizedBox(
                                            width: screenSize.width * 0.03,
                                          ),
                                          const IconTextRow(
                                            icon: Icons.email,
                                            text: 'info@jobmatch.com',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: kSpacing20),
                            Row(
                              mainAxisSize:
                                  MainAxisSize.min, // Ensure this is present
                              children: <Widget>[
                                SizedBox(
                                  height: kRadius40 + kSpacing4,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.work_outline,
                                        size: kIconSize20,
                                      ),
                                      label: const Text(
                                        'View Our Jobs',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      onPressed: () {
                                        print('View Our Jobs button tapped');
                                        // Navigate to a screen showing jobs by JobMatch
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange.shade700,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: kPadding20,
                                          vertical: 0,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            kRadius8,
                                          ),
                                        ),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        minimumSize: Size.zero,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: kSpacing12),
                                SizedBox(
                                  height: kRadius40 + kSpacing4,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.dashboard_outlined,
                                        size: kIconSize20,
                                      ),
                                      label: const Text(
                                        'Dashboard',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      onPressed: () {
                                        print(
                                          'Company Dashboard button tapped',
                                        );
                                        Navigator.of(context).push(
                                          FadeThroughPageRoute(
                                            page:
                                                const EmployerDashboardScreen(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF3366FF,
                                        ),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: kPadding20,
                                          vertical: 0,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            kRadius8,
                                          ),
                                        ),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        minimumSize: Size.zero,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeInUp(
                        duration: const Duration(milliseconds: 700),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  SectionTitle(text: 'About JobMatch'),
                                  JustifiedText(
                                    text:
                                        'JobMatch Recruiting is a premier talent acquisition firm dedicated to connecting exceptional candidates with leading companies across various industries. Our mission is to streamline the hiring process, ensuring a perfect match for both employers and job seekers. We leverage cutting-edge technology and a personalized approach to deliver outstanding results.',
                                  ),
                                  SectionTitle(text: 'Our Services'),
                                  BulletPointItem(
                                    text: 'Executive Search and Headhunting.',
                                  ),
                                  BulletPointItem(
                                    text:
                                        'Permanent and Contract Staffing Solutions.',
                                  ),
                                  BulletPointItem(
                                    text:
                                        'Talent Mapping and Market Intelligence.',
                                  ),
                                  BulletPointItem(
                                    text:
                                        'Recruitment Process Outsourcing (RPO).',
                                  ),
                                  BulletPointItem(
                                    text:
                                        'Consultancy on HR and Talent Strategy.',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: kSpacing30 + kSpacing4 / 2),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  FadeInRight(
                                    duration: const Duration(milliseconds: 700),
                                    child: Container(
                                      padding: kPaddingAll20,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F8FA),
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                          width: kStroke1,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          kRadius12 + kRadius4 / 2,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Company Overview',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xFF222B45),
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                kSpacing12 +
                                                kSpacing8 / 2 +
                                                kSpacing4 / 2,
                                          ),
                                          Wrap(
                                            runSpacing:
                                                kSpacing12 +
                                                kSpacing8 / 2 +
                                                kSpacing4 / 2,
                                            spacing: kSpacing30 + kSpacing4 / 2,
                                            children: [
                                              ProfileOverviewItem(
                                                icon: Icons.business_center,
                                                label: 'Industry',
                                                value:
                                                    'Human Resources / Recruiting',
                                              ),
                                              ProfileOverviewItem(
                                                icon: Icons.groups,
                                                label: 'Company Size',
                                                value: '50-100 employees',
                                              ),
                                              ProfileOverviewItem(
                                                icon: Icons.calendar_today,
                                                label: 'Founded',
                                                value: '2015',
                                              ),
                                              ProfileOverviewItem(
                                                icon: Icons.location_city,
                                                label: 'Headquarters',
                                                value: 'Lima, Perú',
                                              ),
                                              ProfileOverviewItem(
                                                icon: Icons.public,
                                                label: 'Focus Areas',
                                                value:
                                                    'Tech, Finance, Marketing',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: kSpacing20 + kSpacing4,
                                  ),
                                  FadeInRight(
                                    delay: const Duration(milliseconds: 200),
                                    duration: const Duration(milliseconds: 700),
                                    child: Container(
                                      // Contact Person / Key Contact
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F8FA),
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                          width: kStroke1,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          kRadius12 + kRadius4 / 2,
                                        ),
                                      ),
                                      padding: kPaddingAll20,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const CircleAvatar(
                                                radius:
                                                    kRadius20 + kRadius4 / 2,
                                                backgroundImage: AssetImage(
                                                  'assets/images/users/user4.webp',
                                                ),
                                              ),
                                              const SizedBox(width: kSpacing12),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: const [
                                                  Text(
                                                    'Ana Torres',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Color(0xFF222B45),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: kSpacing4 / 2,
                                                  ),
                                                  Text(
                                                    'Lead Recruitment Consultant',
                                                    style: TextStyle(
                                                      color: Color(0xFFB1B5C3),
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: kSpacing12 + kSpacing4,
                                          ),
                                          const IconTextRow(
                                            icon: Icons.email_outlined,
                                            text: 'atorres@jobmatch.com',
                                            iconColor: Color(0xFF6C757D),
                                          ),
                                          SizedBox(height: kSpacing8),
                                          const IconTextRow(
                                            icon: Icons.phone_outlined,
                                            text: '+51 1 555 0102',
                                            iconColor: Color(0xFF6C757D),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height:
                (kPadding20 + kSpacing4) - cardOverlap > 0
                    ? (kPadding20 + kSpacing4) - cardOverlap + kPadding12
                    : kPadding12,
          ),
          FadeInLeft(
            duration: const Duration(milliseconds: 700),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: kPadding12,
                left: pageHorizontalPadding + kPadding8,
                right: pageHorizontalPadding,
              ),
              child: Row(
                children: [
                  const Text(
                    'Share this company:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      color: Color(0xFF222B45),
                    ),
                  ),
                  const SizedBox(width: kSpacing12 + kSpacing4),
                  ProfileSocialShareButton(
                    color: const Color(0xFF1877F3),
                    icon: Icons.facebook,
                    label: 'Facebook',
                    onPressed: () {},
                  ),
                  ProfileSocialShareButton(
                    color: const Color(0xFF1DA1F2),
                    icon: Icons.alternate_email,
                    label: 'Twitter',
                    onPressed: () {},
                  ),
                  ProfileSocialShareButton(
                    color: const Color(0xFF0A66C2),
                    icon: Icons.workspaces_outline,
                    label: 'LinkedIn',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          FadeInUp(
            duration: const Duration(milliseconds: 700),
            child: Padding(
              padding: EdgeInsets.only(
                top: kPadding20,
                bottom: kPadding16,
                left: pageHorizontalPadding + kPadding8,
                right: pageHorizontalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Jobs We're Hiring For",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Color(0xFF222B45),
                    ),
                  ),
                ],
              ),
            ),
          ),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 700),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: pageHorizontalPadding),
              child: jobsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
                data: (jobs) {
                  int crossAxisCount = 3;
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      double cardWidth =
                          (constraints.maxWidth -
                              (crossAxisCount - 1) * (kSpacing12 + kSpacing4)) /
                          crossAxisCount;
                      double cardHeight = 180;
                      if (screenSize.width < 900) crossAxisCount = 2;
                      if (screenSize.width < 600) crossAxisCount = 1;
                      cardWidth =
                          (constraints.maxWidth -
                              (crossAxisCount - 1) * (kSpacing12 + kSpacing4)) /
                          crossAxisCount;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: kSpacing12 + kSpacing4,
                          mainAxisSpacing: kSpacing12 + kSpacing4,
                          childAspectRatio: cardWidth / cardHeight,
                        ),
                        itemCount: jobs.length,
                        itemBuilder: (context, index) {
                          final job = jobs[index];
                          return FadeInUp(
                            delay: Duration(milliseconds: 100 * index),
                            child: RelatedJobCard(
                              job: Job(
                                logoAsset: 'assets/images/job_match.jpg',
                                companyName: 'Empresa',
                                location: job['location'] ?? 'Lima, Perú',
                                title: job['title'] ?? '',
                                type: 'Tiempo Completo',
                                salary: 'S/5000',
                                isFeatured: false,
                                logoBackgroundColor: Colors.blue.shade100,
                                matchPercentage: 80,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: kPadding20 + kSpacing4),
        ],
      ),
    );
  }
}

// Demo data for jobs (remove in production)
final List<Job> demoJobs = List.generate(
  6,
  (index) => Job(
    title: 'Software Engineer ${index + 1}',
    location: 'Lima, Perú',
    salary: '\$40,000 - \$60,000',

    logoAsset: 'assets/images/job_match.jpg',
    companyName: 'JobMatch Recruiting',
    type: 'Full-time',
    logoBackgroundColor: Colors.blue.shade100,
    matchPercentage: 75,
  ),
);
