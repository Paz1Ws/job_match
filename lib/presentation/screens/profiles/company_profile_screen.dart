import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/config/util/animations.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/core/data/cv_parsing.dart' show generateRandomMatchPercentage; // Added import
import 'package:job_match/core/domain/models/company_model.dart';
import 'package:job_match/presentation/screens/dashboard/employer_dashboard_screen.dart';
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
    final double bannerHeight = 220.0;
    final double cardOverlap = 70.0;
    final double pageHorizontalPadding = kPadding28 + kSpacing4;

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
                    'assets/images/jobmatch_background.jpg', // Default banner
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
                                    backgroundImage:
                                        company.logo != null
                                            ? NetworkImage(company.logo!)
                                            : const AssetImage(
                                                  'assets/images/job_match.jpg',
                                                )
                                                as ImageProvider,
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
                                          company.companyName ?? 'Company',
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
                                          company.address ?? 'Sin ubicación',
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
                                              InfoChip(
                                                label:
                                                    company.industry ??
                                                    'Tecnología',
                                                backgroundColor: const Color(
                                                  0xFF3366FF,
                                                ),
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
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Empresa guardada',
                                                ),
                                              ),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal:
                                                        kPadding20 + kSpacing4,
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
                                        text: 'Acerca de la Empresa',
                                      ),
                                      JustifiedText(
                                        text:
                                            company.description ??
                                            'Sin descripción disponible',
                                      ),
                                      // Website link if available
                                      if (company.website != null &&
                                          company.website!.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 12,
                                            bottom: 8,
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.language,
                                                color: Colors.blue,
                                                size: 22,
                                              ),
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
                                                    final url = Uri.parse(
                                                      company.website!,
                                                    );
                                                    if (await canLaunchUrl(
                                                      url,
                                                    )) {
                                                      await launchUrl(url);
                                                    }
                                                  },
                                                  child: Text(
                                                    company.website!,
                                                    style: const TextStyle(
                                                      color: Colors.blue,
                                                      decoration:
                                                          TextDecoration
                                                              .underline,
                                                      fontSize: 14,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
                                            borderRadius: BorderRadius.circular(
                                              kRadius12 + kRadius4 / 2,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Información de Contacto',
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
                                                icon: Icons.business,
                                                label: 'Nombre',
                                                value:
                                                    company.companyName ??
                                                    'Company',
                                              ),
                                              ProfileOverviewItem(
                                                icon: Icons.location_on,
                                                label: 'Ubicación',
                                                value:
                                                    company.address ??
                                                    'No disponible',
                                              ),
                                              ProfileOverviewItem(
                                                icon: Icons.phone,
                                                label: 'Teléfono',
                                                value:
                                                    company.phone ??
                                                    'No disponible',
                                              ),
                                              if (company.website != null)
                                                ProfileOverviewItem(
                                                  icon: Icons.language,
                                                  label: 'Sitio Web',
                                                  value:
                                                      company.website ??
                                                      'No disponible',
                                                ),
                                              ProfileOverviewItem(
                                                icon: Icons.category,
                                                label: 'Industria',
                                                value:
                                                    company.industry ??
                                                    'No disponible',
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
            ],
          ),
          // Spacing after the card
          // This SizedBox provides space *below* the visual bottom of the card.
          // The Stack's height will accommodate the banner and the overlapping card.
          // The original spacing logic should still be relevant to the card's visual end.
          SizedBox(
            height:
                (kPadding20 +
                    kSpacing4), // Adjusted to be simpler, space after the entire header block
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
          // "Trabajos Publicados" title
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
                    'Trabajos Publicados',
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
                        ),
                      ),
                    );
                  }

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
                                matchPercentage: generateRandomMatchPercentage(), // Updated
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
