import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/config/util/animations.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/core/domain/models/candidate_model.dart';
import 'package:job_match/presentation/screens/profiles/user_profile.dart';
import 'package:job_match/presentation/widgets/homepage/find_job/footer_find_jobs.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class FindEmployeesScreen extends ConsumerStatefulWidget {
  const FindEmployeesScreen({super.key});

  @override
  ConsumerState<FindEmployeesScreen> createState() =>
      _FindEmployeesScreenState();
}

class _FindEmployeesScreenState extends ConsumerState<FindEmployeesScreen> {
  @override
  Widget build(BuildContext context) {
    // Create a key to manage the scaffold state (needed for opening drawer)
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = MediaQuery.sizeOf(context);
        final isMobile = size.width < 700;

        return Scaffold(
          key: scaffoldKey,
          // Add drawer for mobile view that contains the filter sidebar
          drawer:
              isMobile
                  ? Drawer(
                    width: size.width * 0.85,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Filtros',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            Expanded(
                              child: SingleChildScrollView(
                                child: _buildEmployeeFilterSidebar(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  : null,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: isMobile ? 60 : 80,
                  width: double.infinity,
                  color: Colors.black,
                  child: _buildTopBar(context, isMobile),
                ),
                FadeInDown(
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    height: isMobile ? 150 : 220,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/find_jobs_background.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.55),
                      child: Center(
                        child: FadeInDown(
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 500),
                          child:
                              isMobile
                                  ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Encuentra el ',
                                        style: TextStyle(
                                          fontSize: 26,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      AnimatedTextKit(
                                        animatedTexts: [
                                          TypewriterAnimatedText(
                                            'talento',
                                            speed: const Duration(
                                              milliseconds: 100,
                                            ),
                                            textStyle: const TextStyle(
                                              fontSize: 26,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          TypewriterAnimatedText(
                                            'colaborador',
                                            speed: const Duration(
                                              milliseconds: 100,
                                            ),
                                            textStyle: const TextStyle(
                                              fontSize: 26,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                        ],
                                        totalRepeatCount: 100,
                                        pause: const Duration(seconds: 2),
                                        displayFullTextOnTap: true,
                                      ),
                                      const Text(
                                        'perfecto',
                                        style: TextStyle(
                                          fontSize: 26,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  )
                                  : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Encuentra el ',
                                        style: TextStyle(
                                          fontSize: 44,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      AnimatedTextKit(
                                        animatedTexts: [
                                          TypewriterAnimatedText(
                                            'talento',
                                            speed: const Duration(
                                              milliseconds: 100,
                                            ),
                                            textStyle: const TextStyle(
                                              fontSize: 44,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          TypewriterAnimatedText(
                                            'colaborador',
                                            speed: const Duration(
                                              milliseconds: 100,
                                            ),
                                            textStyle: const TextStyle(
                                              fontSize: 44,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                        ],
                                        totalRepeatCount: 100,
                                        pause: const Duration(seconds: 2),
                                        displayFullTextOnTap: true,
                                      ),
                                      const Text(
                                        ' perfecto',
                                        style: TextStyle(
                                          fontSize: 44,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Filtros y lista de empleados
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  child:
                      isMobile
                          // En móvil, solo mostramos la lista de empleados con botón de filtros arriba
                          ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Filtro arriba de la lista de empleados en mobile
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                    vertical: 8.0,
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        () =>
                                            scaffoldKey.currentState
                                                ?.openDrawer(),
                                    icon: const Icon(Icons.filter_list),
                                    label: const Text('Filtrar candidatos'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                FadeInRight(
                                  duration: const Duration(milliseconds: 700),
                                  child: _buildEmployeeListView(),
                                ),
                              ],
                            ),
                          )
                          // En desktop, mantenemos el layout con filtro visible + lista
                          : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FadeInLeft(
                                    duration: const Duration(milliseconds: 700),
                                    child: _buildEmployeeFilterSidebar(),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FadeInRight(
                                    duration: const Duration(milliseconds: 700),
                                    child: _buildEmployeeListView(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                ),
                FadeInUpBig(
                  duration: const Duration(milliseconds: 800),
                  child: FooterFindJobs(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context, bool isMobile) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16.0 : 24.0,
          vertical: isMobile ? 12.0 : 16.0,
        ),
        child: Row(
          children: [
            FadeInLeft(
              duration: const Duration(milliseconds: 600),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.white),
                    const SizedBox(width: 8),
                    if (!isMobile)
                      Image.asset(
                        'assets/images/job_match_transparent.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            FadeInDown(
              duration: const Duration(milliseconds: 600),
              child: Text(
                isMobile ? 'Buscar Candidatos' : 'Search Employees',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 16 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeFilterSidebar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtros de Búsqueda',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildFilterSection('Experiencia', ['Junior', 'Mid', 'Senior']),
          const SizedBox(height: 16),
          _buildFilterSection('Ubicación', [
            'Lima',
            'Arequipa',
            'Cusco',
            'Remoto',
            'Trujillo',
          ]),
          const SizedBox(height: 16),
          _buildFilterSection('Habilidades', [
            'Flutter',
            'React',
            'Python',
            'Java',
            'JavaScript',
          ]),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...options.map(
          (option) => CheckboxListTile(
            title: Text(option),
            value: false,
            onChanged: (bool? value) {},
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeListView() {
    final candidatesAsync = ref.watch(candidatesProvider);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 700;

    return candidatesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data:
          (candidates) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 8.0 : 0),
                child: Text(
                  '${candidates.length} candidatos encontrados',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: candidates.length,
                itemBuilder: (context, index) {
                  final candidate = candidates[index];
                  return _buildEmployeeCard(candidate, isMobile);
                },
              ),
            ],
          ),
    );
  }

  Widget _buildEmployeeCard(Candidate candidate, bool isMobile) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserProfile(candidateData: candidate),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: isMobile ? 24 : 30,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  candidate.name?.toString().substring(0, 1).toUpperCase() ??
                      'U',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
              SizedBox(width: isMobile ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidate.name ?? 'Nombre no disponible',
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isMobile ? 2 : 4),
                    Text(
                      candidate.experienceLevel ?? 'Nivel no especificado',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: isMobile ? 2 : 4),
                    Text(
                      candidate.location ?? 'Ubicación no especificada',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (candidate.skills != null) ...[
                      SizedBox(height: isMobile ? 6 : 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: isMobile ? 4 : 6,
                        children:
                            candidate.skills!
                                .take(isMobile ? 2 : 3)
                                .map(
                                  (skill) => Chip(
                                    label: Text(
                                      skill.toString(),
                                      style: TextStyle(
                                        fontSize: isMobile ? 10 : 12,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isMobile ? 4 : 8,
                                    ),
                                    backgroundColor: Colors.blue.shade50,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
