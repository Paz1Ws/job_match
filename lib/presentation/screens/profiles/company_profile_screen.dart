import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/config/util/animations.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/core/data/cv_parsing.dart'
    show generateRandomMatchPercentage; // Added import
import 'package:job_match/core/domain/models/company_model.dart';
import 'package:job_match/presentation/screens/dashboard/employer_dashboard_screen.dart';
import 'package:job_match/presentation/screens/homepage/screens/homepage_screen.dart';
import 'package:job_match/presentation/widgets/auth/app_identity_bar.dart';
import 'package:job_match/presentation/widgets/auth/profile_display_elements.dart';
import 'package:job_match/presentation/widgets/auth/related_job_card.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyProfileScreen extends ConsumerWidget {
  const CompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double appIdentityBarHeight = 70.0;

    // Get company data from provider
    final company = ref.watch(companyProfileProvider);
    if (company == null) {
      // Try to load profile if not in memory
      Future.microtask(() => fetchUserProfile(ref));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          AppIdentityBar(height: appIdentityBarHeight, onProfileTap: () {}),
          Expanded(
            child: SingleChildScrollView(
              child: CompanyProfileHeader(company: company),
            ),
          ),
        ],
      ),
    );
  }
}

class CompanyProfileHeader extends ConsumerWidget {
  final Company company;

  const CompanyProfileHeader({super.key, required this.company});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.sizeOf(context);
    final isMobile = screenSize.width < 700;
    final double bannerHeight = isMobile ? 120.0 : 220.0;
    final double cardOverlap = isMobile ? 40.0 : 70.0;
    final double pageHorizontalPadding =
        (isMobile ? 12.0 : kPadding28) + kSpacing4;

    // Use real company jobs from Supabase
    final jobsAsync = ref.watch(jobsByCompanyIdProvider(company.userId));

    return Container(
      color: const Color(0xFFF7F8FA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none, // Allow card shadow to extend if necessary
            children: <Widget>[
              // Banner Image (Bottom layer)
              FadeInDownBig(
                duration: const Duration(milliseconds: 700),
                child: SizedBox(
                  height: bannerHeight,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/jobmatch_background.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Overlapping Card (Top layer)
              Padding(
                // Position the card to overlap the banner
                padding: EdgeInsets.only(top: bannerHeight - cardOverlap),
                child: FadeInUp(
                  duration: const Duration(milliseconds: 700),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: pageHorizontalPadding,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 12 : kPadding28),
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
                      child:
                          isMobile
                              ? _buildMobileHeader(context)
                              : _buildDesktopHeader(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Spacing after the card
          SizedBox(
            height:
                cardOverlap +
                (kPadding20 +
                    kSpacing4), // Ensure details start below the overlapping card
          ),

          // Profile Details Section for Company
          Padding(
            padding: EdgeInsets.symmetric(horizontal: pageHorizontalPadding),
            child: _buildProfileDetails(context, isMobile: isMobile),
          ),
          const SizedBox(
            height: kPadding20 + kSpacing4,
          ), // Spacing after company details
          // "Trabajos Publicados" title
          FadeInUp(
            duration: const Duration(milliseconds: 700),
            child: Padding(
              padding: EdgeInsets.only(
                top: kPadding20,
                bottom: kPadding16,
                left: pageHorizontalPadding + (isMobile ? 0 : kPadding8),
                right: pageHorizontalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trabajos Publicados',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 18.0 : 20.0,
                      color: Color(0xFF222B45),
                    ),
                    textAlign: isMobile ? TextAlign.center : TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
          // "Trabajos Publicados" grid with real data
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 700),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: pageHorizontalPadding),
              child: jobsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
                data: (jobs) {
                  if (jobs.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Text(
                          'No hay trabajos publicados por esta empresa',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  int crossAxisCount = isMobile ? 1 : 3;
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      if (screenSize.width < 900 && screenSize.width >= 700) {
                        crossAxisCount = 2;
                      }

                      double cardWidth =
                          (constraints.maxWidth -
                              (crossAxisCount - 1) * (kSpacing12 + kSpacing4)) /
                          crossAxisCount;
                      double cardHeight = isMobile ? 200 : 180;

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
                                id: job.id ?? '',
                                logoAsset:
                                    company.logo ??
                                    'assets/images/job_match.jpg',
                                companyName: company.companyName ?? 'Company',
                                location:
                                    job.location ??
                                    company.address ??
                                    'No disponible',
                                title: job.title ?? 'Puesto sin título',
                                type: job.type ?? 'Tiempo Completo',
                                salary: job.salary,
                                isFeatured: job.isFeatured ?? false,
                                logoBackgroundColor: Colors.blue.shade100,
                                matchPercentage:
                                    generateRandomMatchPercentage(),
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

  Widget _buildMobileHeader(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment
              .start, // Changed to start for better alignment if text wraps
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeIn(
          duration: const Duration(milliseconds: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Centered company logo
              Center(
                child: BounceInDown(
                  duration: const Duration(milliseconds: 900),
                  child: CircleAvatar(
                    radius: kRadius20 + kRadius12,
                    backgroundImage:
                        company.logo != null && company.logo!.isNotEmpty
                            ? NetworkImage(company.logo!)
                            : const AssetImage('assets/images/job_match.jpg')
                                as ImageProvider,
                    backgroundColor: Colors.grey.shade200, // Fallback color
                    child:
                        company.logo != null && company.logo!.isNotEmpty
                            ? null
                            : Icon(
                              Icons.business,
                              size: kRadius20 + kRadius12,
                              color: Colors.grey.shade400,
                            ),
                  ),
                ),
              ),
              const SizedBox(height: kSpacing8),
              // Company name and info - centered
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FadeInLeft(
                    duration: const Duration(milliseconds: 700),
                    child: Text(
                      company.companyName ?? 'Nombre no disponible',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Color(0xFF222B45),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: kSpacing4),
                  FadeInLeft(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 700),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            company.address ?? 'Ubicación no especificada',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Color(0xFF6C757D),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: kSpacing8),
                  // Industry chip centered
                  FadeInLeft(
                    delay: const Duration(milliseconds: 300),
                    duration: const Duration(milliseconds: 700),
                    child: Center(
                      child: InfoChip(
                        label: company.industry ?? 'Industria no especificada',
                        backgroundColor: const Color(0xFF3366FF),
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Navigation buttons - centered
        Center(
          child: SizedBox(
            height: kRadius40 + kSpacing4,
            child: Material(
              color: Colors.transparent,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward, size: kIconSize20),
                label: const Text('Dashboard', style: TextStyle(fontSize: 14)),
                onPressed: () {
                  Navigator.of(context).push(
                    FadeThroughPageRoute(page: const EmployerDashboardScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3366FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: kPadding16,
                    vertical: 0,
                  ),
                  textStyle: const TextStyle(fontSize: 14.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kRadius8),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildProfileDetails(context, isMobile: true),
      ],
    );
  }

  Widget _buildDesktopHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Atrás',
        ),
        BounceInDown(
          duration: const Duration(milliseconds: 900),
          child: CircleAvatar(
            radius: kRadius20 + kRadius12,
            backgroundImage:
                company.logo != null && company.logo!.isNotEmpty
                    ? NetworkImage(company.logo!)
                    : const AssetImage('assets/images/job_match.jpg')
                        as ImageProvider,
            backgroundColor: Colors.grey.shade200, // Fallback color
            child:
                company.logo != null && company.logo!.isNotEmpty
                    ? null
                    : Icon(
                      Icons.business,
                      size: kRadius20 + kRadius12,
                      color: Colors.grey.shade400,
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
                child: Text(
                  company.companyName ?? 'Nombre no disponible',
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
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 700),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        company.address ?? 'Ubicación no especificada',
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Color(0xFF6C757D),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
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
                      InfoChip(
                        label: company.industry ?? 'Industria no especificada',
                        backgroundColor: const Color(0xFF3366FF),
                        textColor: Colors.white,
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
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: kRadius40 + kSpacing4,
              height: kRadius40 + kSpacing4,
              decoration: BoxDecoration(
                color: Colors.lightBlue[100],
                borderRadius: BorderRadius.circular(kRadius8),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.bookmark_border,
                  color: Colors.blue,
                  size: kIconSize24 + kSpacing4,
                ),
                onPressed: () {},
                tooltip: 'Guardar',
                iconSize: kIconSize24 + kSpacing4,
              ),
            ),
            const SizedBox(width: kSpacing12 + kSpacing4 / 2),
            SizedBox(
              height: kRadius40 + kSpacing4,
              child: Material(
                color: Colors.transparent,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward, size: kIconSize20),
                  label: const Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      FadeThroughPageRoute(
                        page: const EmployerDashboardScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3366FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: kPadding20 + kSpacing4,
                      vertical: 0,
                    ),
                    textStyle: const TextStyle(fontSize: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kRadius8),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: Size.zero,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileDetails(BuildContext context, {required bool isMobile}) {
    return Flex(
      direction: isMobile ? Axis.vertical : Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          fit: FlexFit.loose,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(text: 'Acerca de la Empresa'),
              JustifiedText(
                text: company.description ?? 'Descripción no disponible.',
              ),
              if (company.website != null && company.website!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.language, color: Colors.blue, size: 22),
                      const SizedBox(width: 8),
                      const Text(
                        'Sitio web:',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: InkWell(
                          onTap: () async {
                            if (company.website != null &&
                                company.website!.isNotEmpty) {
                              final url = Uri.tryParse(company.website!);
                              if (url != null && await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'No se pudo abrir el sitio web: ${company.website}',
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: Text(
                            company.website!,
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        // Espaciador visual solo en desktop/web
        if (!isMobile) const Spacer(),
        Flexible(
          flex: 1,
          fit: FlexFit.loose,
          child: Column(
            crossAxisAlignment:
                isMobile
                    ? CrossAxisAlignment.stretch
                    : CrossAxisAlignment.start,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detalles de la Empresa',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF222B45),
                        ),
                      ),
                      const SizedBox(height: kSpacing12),
                      ProfileOverviewItem(
                        icon: Icons.business,
                        label: 'Nombre',
                        value: company.companyName ?? 'No disponible',
                      ),
                      ProfileOverviewItem(
                        icon: Icons.location_on,
                        label: 'Ubicación',
                        value: company.address ?? 'No disponible',
                      ),
                      ProfileOverviewItem(
                        icon: Icons.phone,
                        label: 'Teléfono',
                        value: company.phone ?? 'No disponible',
                      ),
                      if (company.website != null &&
                          company.website!.isNotEmpty)
                        ProfileOverviewItem(
                          icon: Icons.language,
                          label: 'Sitio Web',
                          value: company.website!,
                        ),
                      ProfileOverviewItem(
                        icon: Icons.category,
                        label: 'Industria',
                        value: company.industry ?? 'No disponible',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
