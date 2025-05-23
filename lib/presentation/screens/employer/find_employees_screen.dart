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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: double.infinity,
              color: Colors.black,
              child: _buildTopBar(context),
            ),
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              child: Container(
                height: 220,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/find_jobs_background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.55),
                  child: Center(
                    child: FadeInDown(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 500),
                      child: Row(
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
                                speed: const Duration(milliseconds: 100),
                                textStyle: const TextStyle(
                                  fontSize: 44,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              TypewriterAnimatedText(
                                'colaborador',
                                speed: const Duration(milliseconds: 100),
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
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: Row(
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
  }

  Widget _buildTopBar(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
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
              child: const Text(
                'Search Employees',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
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
          _buildFilterSection('Experiencia', [
            'Sin experiencia',
            'Junior',
            'Mid',
            'Senior',
          ]),
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

    return candidatesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data:
          (candidates) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${candidates.length} candidatos encontrados',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: candidates.length,
                itemBuilder: (context, index) {
                  final candidate = candidates[index];
                  return _buildEmployeeCard(candidate);
                },
              ),
            ],
          ),
    );
  }

  Widget _buildEmployeeCard(Candidate candidate) {
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
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  candidate.name?.toString().substring(0, 1).toUpperCase() ??
                      'U',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidate.name ?? 'Nombre no disponible',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      candidate.experienceLevel ?? 'Nivel no especificado',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      candidate.location ?? 'Ubicación no especificada',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (candidate.skills != null) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children:
                            candidate.skills!
                                .take(3)
                                .map(
                                  (skill) => Chip(
                                    label: Text(
                                      skill.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    backgroundColor: Colors.blue.shade50,
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
