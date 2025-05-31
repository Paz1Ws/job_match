import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/config/util/animations.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/domain/models/candidate_model.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/presentation/screens/auth/screens/login_screen.dart';
import 'package:job_match/presentation/screens/dashboard/candidate_dashboard_screen.dart';
import 'package:job_match/presentation/screens/homepage/find_jobs_screen.dart';
import 'package:job_match/presentation/widgets/auth/app_identity_bar.dart';
import 'package:job_match/presentation/widgets/auth/profile_display_elements.dart';
import 'package:job_match/presentation/widgets/auth/related_job_card.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UserProfile extends ConsumerStatefulWidget {
  final Candidate? candidateData;

  const UserProfile({super.key, this.candidateData});

  @override
  ConsumerState<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final candidate =
        widget.candidateData ?? ref.watch(candidateProfileProvider);
    final isExternalProfile = widget.candidateData != null;

    if (candidate == null) {
      Future.microtask(() => fetchUserProfile(ref));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = MediaQuery.sizeOf(context);
        final isMobile = screenSize.width < 700;
        const double appIdentityBarHeight = 70.0;

        return Scaffold(
          body: Column(
            children: <Widget>[
              AppIdentityBar(height: appIdentityBarHeight, onProfileTap: () {}),
              Flexible(
                child: SingleChildScrollView(
                  child: ProfileDetailHeader(
                    candidate: candidate,
                    isExternalProfile: isExternalProfile,
                    isMobile: isMobile,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProfileDetailHeader extends ConsumerWidget {
  final Candidate candidate;
  final bool isExternalProfile;
  final bool isMobile;

  const ProfileDetailHeader({
    super.key,
    required this.candidate,
    required this.isExternalProfile,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.sizeOf(context);
    final double bannerHeight = isMobile ? 120.0 : 220.0;
    final double cardOverlap = isMobile ? 40.0 : 70.0;
    final double pageHorizontalPadding =
        (isMobile ? 12.0 : kPadding28) + kSpacing4;
    final jobsAsync = ref.watch(jobsProvider);
    final isCandidate = ref.watch(candidateProfileProvider);

    return Container(
      color: const Color(0xFFF7F8FA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              // Banner (bottom layer of the Stack)
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
              // Card section (top layer of the Stack, translated to overlap)
              Padding(
                padding: EdgeInsets.only(top: bannerHeight),
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
                              ? _buildMobileHeader(context, ref)
                              : _buildDesktopHeader(context, ref),
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

          // Profile Details Section (Bio, Education, Experience, etc.)
          // This section will now be rendered for both mobile and desktop.
          Padding(
            padding: EdgeInsets.symmetric(horizontal: pageHorizontalPadding),
            child: _buildProfileDetails(context, isMobile: isMobile),
          ),
          const SizedBox(
            height: kPadding20 + kSpacing4,
          ), // Added spacing after profile details
          if (isCandidate != null) ...[
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
                      'Trabajos Recomendados',
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
                padding: EdgeInsets.symmetric(
                  horizontal: pageHorizontalPadding,
                ),
                child: jobsAsync.when(
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                  data: (jobs) {
                    int crossAxisCount = 3;
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        double cardWidth =
                            (constraints.maxWidth -
                                (crossAxisCount - 1) *
                                    (kSpacing12 + kSpacing4)) /
                            crossAxisCount;
                        double cardHeight = 180;
                        if (screenSize.width < 900) crossAxisCount = 2;
                        if (screenSize.width < 600) crossAxisCount = 1;
                        cardWidth =
                            (constraints.maxWidth -
                                (crossAxisCount - 1) *
                                    (kSpacing12 + kSpacing4)) /
                            crossAxisCount;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: kSpacing12 + kSpacing4,
                                mainAxisSpacing: kSpacing12 + kSpacing4,
                                childAspectRatio: cardWidth / cardHeight,
                              ),
                          itemCount: jobs.length,
                          itemBuilder: (context, index) {
                            final job =
                                jobs[index]; // This is already a Job model
                            return FadeInUp(
                              delay: Duration(milliseconds: 100 * index),
                              child: RelatedJobCard(
                                job: job, // Pass the Job model directly
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
        ],
      ),
    );
  }

  Widget _buildMobileHeader(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeIn(
          duration: const Duration(milliseconds: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Centrar foto de perfil
              Center(
                child: BounceInDown(
                  duration: const Duration(milliseconds: 900),
                  child: CircleAvatar(
                    radius: kRadius20 + kRadius12,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage:
                        candidate.photo != null && candidate.photo!.isNotEmpty
                            ? NetworkImage(candidate.photo!)
                            : null,
                    child:
                        candidate.photo == null || candidate.photo!.isEmpty
                            ? Icon(
                              Icons.person,
                              size: kRadius20 + kRadius12,
                              color: Colors.grey.shade400,
                            )
                            : null,
                  ),
                ),
              ),
              const SizedBox(height: kSpacing8),
              // Nombre y ubicación centrados
              FadeInLeft(
                duration: const Duration(milliseconds: 700),
                child: Center(
                  child: SelectableText(
                    candidate.name ?? 'Nombre no disponible',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Color(0xFF222B45),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: kSpacing4),
              FadeInLeft(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 700),
                child: Center(
                  child: SelectableText(
                    candidate.mainPosition ?? 'Puesto no especificado',
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFF3366FF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: kSpacing4),
              FadeInLeft(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 700),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      SelectableText(
                        candidate.location ?? 'Ubicación no especificada',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF6C757D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: kSpacing8),
              // Chips de habilidades en wrap centrado
              FadeInLeft(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 700),
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 6,
                    children: [
                      if (candidate.skills != null &&
                          candidate.skills!.isNotEmpty)
                        ...candidate.skills!.map(
                          (skill) => InfoChip(
                            label: skill,
                            backgroundColor: const Color(0xFF3366FF),
                            textColor: Colors.white,
                          ),
                        )
                      else
                        InfoChip(
                          label: "Sin habilidades registradas",
                          backgroundColor: Colors.grey.shade300,
                          textColor: Colors.black87,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Botones centrados: Dashboard y Buscar Empleo
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: kRadius40 + kSpacing4,
              child: Material(
                color: Colors.transparent,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward, size: kIconSize20),
                  label: const Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 14),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      FadeThroughPageRoute(
                        page: const CandidateDashboardScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3366FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: kPadding20,
                      vertical: 0,
                    ),
                    textStyle: const TextStyle(fontSize: 14.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kRadius8),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: Size.zero,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: kRadius40 + kSpacing4,
              child: Material(
                color: Colors.transparent,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.search, size: kIconSize20),
                  label: const Text(
                    'Buscar Empleo',
                    style: TextStyle(fontSize: 14),
                  ),
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(FadeThroughPageRoute(page: const FindJobsScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: kPadding20,
                      vertical: 0,
                    ),
                    textStyle: const TextStyle(fontSize: 14.0),
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
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDesktopHeader(BuildContext context, WidgetRef ref) {
    final isCandidate = ref.watch(candidateProfileProvider);
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
            backgroundColor: Colors.grey.shade200,
            backgroundImage:
                candidate.photo != null && candidate.photo!.isNotEmpty
                    ? NetworkImage(candidate.photo!)
                    : null,
            child:
                candidate.photo == null || candidate.photo!.isEmpty
                    ? Icon(
                      Icons.person,
                      size: kRadius20 + kRadius12,
                      color: Colors.grey.shade400,
                    )
                    : null,
          ),
        ),
        const SizedBox(width: kSpacing20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FadeInLeft(
                duration: const Duration(milliseconds: 700),
                child: SelectableText(
                  candidate.name ?? 'Nombre no disponible',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                    color: Color(0xFF222B45),
                  ),
                ),
              ),
              const SizedBox(height: kSpacing4),
              FadeInLeft(
                delay: const Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 700),
                child: SelectableText(
                  candidate.mainPosition ?? 'Puesto no especificado',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Color(0xFF3366FF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: kSpacing4),
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
                    SelectableText(
                      candidate.location ?? 'Ubicación no especificada',
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Color(0xFF6C757D),
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
                      if (candidate.skills != null &&
                          candidate.skills!.isNotEmpty)
                        ...candidate.skills!.map(
                          (skill) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InfoChip(
                              label: skill,
                              backgroundColor: const Color(0xFF3366FF),
                              textColor: Colors.white,
                            ),
                          ),
                        )
                      else
                        InfoChip(
                          label: "Sin habilidades registradas",
                          backgroundColor: Colors.grey.shade300,
                          textColor: Colors.black87,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: kSpacing20),
        if (isCandidate != null)
          SizedBox(
            height: kRadius40 + kSpacing4,
            child: Material(
              color: Colors.transparent,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward, size: kIconSize20),
                label: const Text('Dashboard', style: TextStyle(fontSize: 15)),
                onPressed: () {
                  Navigator.of(context).push(
                    FadeThroughPageRoute(
                      page: const CandidateDashboardScreen(),
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
    );
  }

  Widget _buildProfileDetails(BuildContext context, {required bool isMobile}) {
    return Flex(
      direction: isMobile ? Axis.vertical : Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          flex: 2,
          fit: FlexFit.loose,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SECCIÓN: PERFIL PROFESIONAL
              FadeInLeft(
                duration: const Duration(milliseconds: 700),
                child: Container(
                  padding: EdgeInsets.all(isMobile ? kPadding16 : kPadding20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(kRadius12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: kSpacing8),
                          const Text(
                            'Perfil Profesional',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF222B45),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: kSpacing12),
                      JustifiedText(
                        text:
                            candidate.bio ??
                            'Información biográfica no disponible',
                      ),
                      const SizedBox(height: kSpacing8),
                      if (candidate.mainPosition != null &&
                          candidate.mainPosition!.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.work_outline,
                                size: 18,
                                color: Colors.blue.shade600,
                              ),
                              const SizedBox(width: kSpacing8),
                              Flexible(
                                child: Text(
                                  'Puesto principal: ${candidate.mainPosition}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: kSpacing12),

              // SECCIÓN: CV
              if (candidate.resumeUrl != null &&
                  candidate.resumeUrl!.contains("http"))
                FadeInLeft(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 700),
                  child: Container(
                    padding: EdgeInsets.all(isMobile ? kPadding16 : kPadding20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(kRadius12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(kPadding12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(kRadius8),
                          ),
                          child: const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: kSpacing12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Curriculum Vitae',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: kSpacing4),
                              InkWell(
                                onTap: () async {
                                  // Aquí se podría implementar la lógica para abrir el PDF
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Abriendo CV...'),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Ver CV',
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    decoration: TextDecoration.underline,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.download_outlined,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            // Aquí se implementaría la descarga
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Descargando CV...'),
                              ),
                            );
                          },
                          tooltip: 'Descargar CV',
                        ),
                      ],
                    ),
                  ),
                ),

              if (candidate.resumeUrl != null &&
                  candidate.resumeUrl!.contains("http"))
                const SizedBox(height: kSpacing12),

              // SECCIÓN: EDUCACIÓN
              FadeInLeft(
                delay: const Duration(milliseconds: 250),
                duration: const Duration(milliseconds: 700),
                child: Container(
                  padding: EdgeInsets.all(isMobile ? kPadding16 : kPadding20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(kRadius12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.school_outlined,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: kSpacing8),
                          const Text(
                            'Educación',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF222B45),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: kSpacing12),
                      Container(
                        padding: const EdgeInsets.all(kPadding12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(kRadius8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              candidate.education ??
                                  'Educación no especificada',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: kSpacing12),

              // SECCIÓN: EXPERIENCIA
              FadeInLeft(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 700),
                child: Container(
                  padding: EdgeInsets.all(isMobile ? kPadding16 : kPadding20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(kRadius12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.work_outline,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: kSpacing8),
                          const Text(
                            'Experiencia Laboral',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF222B45),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: kSpacing12),
                      Container(
                        padding: const EdgeInsets.all(kPadding12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(kRadius8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              candidate.experience ??
                                  'Experiencia no especificada',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: isMobile ? 0 : kSpacing30 + kSpacing4 / 2,
          height: isMobile ? kSpacing12 : 0,
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.loose,
          child: Column(
            children: [
              // PANEL: INFORMACIÓN DE CONTACTO
              FadeInRight(
                duration: const Duration(milliseconds: 700),
                child: Container(
                  padding: EdgeInsets.all(isMobile ? kPadding16 : kPadding20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: kStroke1,
                    ),
                    borderRadius: BorderRadius.circular(kRadius12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Información de Contacto',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF222B45),
                        ),
                      ),
                      const SizedBox(height: kSpacing12),
                      ProfileOverviewItem(
                        icon: Icons.person,
                        label: 'Nombre',
                        value: candidate.name ?? 'No disponible',
                      ),

                      ProfileOverviewItem(
                        icon: Icons.work,
                        label: 'Puesto',
                        value: candidate.mainPosition ?? 'No especificado',
                      ),
                      ProfileOverviewItem(
                        icon: Icons.location_on,
                        label: 'Ubicación',
                        value: candidate.location ?? 'No disponible',
                      ),
                      ProfileOverviewItem(
                        icon: Icons.phone,
                        label: 'Teléfono',
                        value: candidate.phone ?? 'No disponible',
                      ),
                      ProfileOverviewItem(
                        icon: Icons.school,
                        label: 'Educación',
                        value: candidate.education ?? 'No disponible',
                      ),

                      // Agregamos un botón de contacto para facilitar la comunicación
                      const SizedBox(height: kSpacing12),
                      if (candidate.phone != null || candidate.name != null)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              launchUrlString(
                                'https://wa.me/${candidate.phone}',
                              );
                            },
                            icon: const Icon(Icons.email),
                            label: const Text('Contactar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: kSpacing12,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: kSpacing12),

              // PANEL: MATCH CON EMPLEOS
            ],
          ),
        ),
      ],
    );
  }
}
