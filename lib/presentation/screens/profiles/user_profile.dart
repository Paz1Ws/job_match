import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/config/util/animations.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/domain/models/candidate_model.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/presentation/screens/dashboard/candidate_dashboard_screen.dart';
import 'package:job_match/presentation/widgets/auth/app_identity_bar.dart';
import 'package:job_match/presentation/widgets/auth/profile_display_elements.dart';
import 'package:job_match/presentation/widgets/auth/related_job_card.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/core/domain/models/job_model.dart';

class UserProfile extends ConsumerWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double appIdentityBarHeight = 70.0;

    // Cargar el perfil si aún no está cargado
    final candidate = ref.watch(candidateProfileProvider);
    if (candidate == null) {
      // Intentar cargar el perfil si no está en memoria
      Future.microtask(() => fetchUserProfile(ref));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          AppIdentityBar(height: appIdentityBarHeight, onProfileTap: () {}),
          Expanded(
            child: SingleChildScrollView(
              child: ProfileDetailHeader(candidate: candidate),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileDetailHeader extends ConsumerWidget {
  final Candidate candidate;
  const ProfileDetailHeader({super.key, required this.candidate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.sizeOf(context);
    final double bannerHeight = 220.0;
    final double cardOverlap = 70.0;
    final double pageHorizontalPadding = kPadding28 + kSpacing4;
    final jobsAsync = ref.watch(jobsProvider);

    return Container(
      color: const Color(0xFFF7F8FA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              // Banner (bottom layer of the Stack)
              FadeInDownBig(
                duration: const Duration(milliseconds: 700),
                child: SizedBox(
                  height: bannerHeight,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/profile_background.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Card section (top layer of the Stack, translated to overlap)
              Padding(
                padding: EdgeInsets.only(
                  top: bannerHeight,
                ), // Position after banner
                child: FadeInUp(
                  duration: const Duration(milliseconds: 700),
                  child: Transform.translate(
                    offset: Offset(0, -cardOverlap), // Translate upwards
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: pageHorizontalPadding,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(kPadding28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            kRadius12 + kRadius4,
                          ),
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
                                    onPressed:
                                        () => Navigator.of(context).maybePop(),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        FadeInLeft(
                                          duration: const Duration(
                                            milliseconds: 700,
                                          ),
                                          child: Text(
                                            candidate.name ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22.0,
                                              color: Color(0xFF222B45),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: kSpacing8),
                                        FadeInLeft(
                                          delay: const Duration(
                                            milliseconds: 200,
                                          ),
                                          duration: const Duration(
                                            milliseconds: 700,
                                          ),
                                          child: Text(
                                            candidate.location ?? '',
                                            style: const TextStyle(
                                              fontSize: 15.0,
                                              color: Color(0xFF6C757D),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: kSpacing12),
                                        FadeInLeft(
                                          delay: const Duration(
                                            milliseconds: 300,
                                          ),
                                          duration: const Duration(
                                            milliseconds: 700,
                                          ),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                if (candidate.skills != null)
                                                  ...candidate.skills!.map(
                                                    (skill) => Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            right: 8.0,
                                                          ),
                                                      child: InfoChip(
                                                        label: skill,
                                                        backgroundColor:
                                                            const Color(
                                                              0xFF3366FF,
                                                            ),
                                                        textColor: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: kSpacing20),
                                  FadeInRight(
                                    duration: const Duration(milliseconds: 700),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          width: kRadius40 + kSpacing4,
                                          height: kRadius40 + kSpacing4,
                                          decoration: BoxDecoration(
                                            color: Colors.lightBlue[100],
                                            borderRadius: BorderRadius.circular(
                                              kRadius8,
                                            ),
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.bookmark_border,
                                              color: Colors.blue,
                                              size: kIconSize24 + kSpacing4,
                                            ),
                                            onPressed: () {
                                              print(
                                                'Bookmark button tapped in UserProfile',
                                              );
                                            },
                                            tooltip: 'Guardar',
                                            iconSize: kIconSize24 + kSpacing4,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: kSpacing12 + kSpacing4 / 2,
                                        ),
                                        SizedBox(
                                          height: kRadius40 + kSpacing4,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: ElevatedButton.icon(
                                              icon: const Icon(
                                                Icons.arrow_forward,
                                                size: kIconSize20,
                                              ),
                                              label: const Text(
                                                'Dashboard',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              onPressed: () {
                                                print(
                                                  'Dashboard button tapped in UserProfile',
                                                );
                                                Navigator.of(context).push(
                                                  FadeThroughPageRoute(
                                                    page:
                                                        const CandidateDashboardScreen(),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(
                                                  0xFF3366FF,
                                                ),
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal:
                                                          kPadding20 +
                                                          kSpacing4,
                                                      vertical: 0,
                                                    ),
                                                textStyle: const TextStyle(
                                                  fontSize: 15.0,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        kRadius8,
                                                      ),
                                                ),
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                minimumSize: Size.zero,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SectionTitle(
                                          text: 'Perfil Profesional',
                                        ),
                                        JustifiedText(
                                          text: candidate.bio ?? '',
                                        ),
                                        // --- CV LINK SECTION ---
                                        if (candidate.resumeUrl != null &&
                                            candidate.resumeUrl!.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 12,
                                              bottom: 8,
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.picture_as_pdf,
                                                  color: Colors.red,
                                                  size: 22,
                                                ),
                                                const SizedBox(width: 8),
                                                const Text(
                                                  'Link al CV:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Flexible(
                                                  child: SelectableText(
                                                    candidate.resumeUrl!,
                                                    style: const TextStyle(
                                                      color: Colors.blue,
                                                      decoration:
                                                          TextDecoration
                                                              .underline,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        // --- END CV LINK SECTION ---
                                        const SectionTitle(text: 'Educación'),
                                        Text(candidate.education ?? ''),
                                        const SectionTitle(text: 'Experiencia'),
                                        Text(candidate.experience ?? ''),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: kSpacing30 + kSpacing4 / 2,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        FadeInRight(
                                          duration: const Duration(
                                            milliseconds: 700,
                                          ),
                                          child: Container(
                                            padding: kPaddingAll20,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF7F8FA),
                                              border: Border.all(
                                                color: Colors.grey.shade200,
                                                width: kStroke1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    kRadius12 + kRadius4 / 2,
                                                  ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Características del Perfil',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Color(0xFF222B45),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: kSpacing12,
                                                ),
                                                ProfileOverviewItem(
                                                  icon: Icons.person,
                                                  label: 'Nivel',
                                                  value:
                                                      candidate
                                                          .experienceLevel ??
                                                      '',
                                                ),
                                                ProfileOverviewItem(
                                                  icon: Icons.location_on,
                                                  label: 'Ubicación',
                                                  value:
                                                      candidate.location ?? '',
                                                ),
                                                ProfileOverviewItem(
                                                  icon: Icons.school,
                                                  label: 'Educación',
                                                  value:
                                                      candidate.education ?? '',
                                                ),
                                                ProfileOverviewItem(
                                                  icon: Icons.work,
                                                  label: 'Experiencia',
                                                  value:
                                                      candidate.experience ??
                                                      '',
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
              ),
            ],
          ),
          // Spacing after the card (original SizedBox)
          SizedBox(
            height:
                (kPadding20 + kSpacing4) - cardOverlap > 0
                    ? (kPadding20 + kSpacing4) - cardOverlap + kPadding12
                    : kPadding12,
          ),
          // "Compartir este perfil" section
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
                    'Compartir este perfil:',
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
                    color: const Color(0xFFE60023),
                    icon: Icons.push_pin,
                    label: 'Pinterest',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          // "Trabajos Relacionados" title
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
                    'Trabajos Relacionados',
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
          // "Trabajos Relacionados" grid
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
                                logoAsset:
                                    'assets/images/job_match.jpg', // Example
                                companyName: job['company_name'] ?? 'Empresa',
                                location: job['location'] ?? 'Lima, Perú',
                                title: job['title'] ?? '',
                                type: job['job_type'] ?? 'Tiempo Completo',
                                salary: job['salary_range'] ?? 'S/5000',
                                isFeatured: job['is_featured'] ?? false,
                                logoBackgroundColor:
                                    Colors.blue.shade100, // Example
                                matchPercentage: 80, // Example
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
