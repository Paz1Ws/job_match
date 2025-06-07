import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/data/jobs_listener.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/core/domain/models/candidate_model.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/presentation/widgets/homepage/find_job/simple_job_card.dart';
import 'package:job_match/presentation/widgets/homepage/find_job/simple_job_card_list_view.dart';
import 'package:animate_do/animate_do.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({super.key});

  @override
  ConsumerState<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile>
    with JobRealtimeUpdatesMixin {
  bool _initialLoad = true;

  @override
  void initState() {
    super.initState();

    // Initialize the Jobs Listener in post-frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeJobsListener(
        onJobStatusChanged: (job, newStatus) {
          _quietlyRefreshJobs();
        },
        onJobDeadlineReached: (job) {
          _quietlyRefreshJobs();
        },
        onJobCreated: (job) {
          _quietlyRefreshJobs();
        },
        onJobUpdated: (job, oldJob) {
          _quietlyRefreshJobs();
        },
        onJobDeleted: (job) {
          _quietlyRefreshJobs();
        },
      );

      // Set initial load to false after animations complete
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _initialLoad = false;
          });
        }
      });
    });
  }

  // Quiet refresh without animations for real-time updates
  void _quietlyRefreshJobs() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.invalidate(jobsProviderWithCompanyName);
      });
    }
  }

  @override
  void dispose() {
    disposeJobsListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final candidate = ref.watch(candidateProfileProvider);
    final jobsAsync = ref.watch(jobsProviderWithCompanyName);

    if (candidate == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil')),
        body: const Center(child: Text('No se encontró perfil de candidato')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Card
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: _buildProfileHeader(candidate),
            ),

            const SizedBox(height: 20),

            // Skills Section
            FadeInUp(
              duration: const Duration(milliseconds: 700),
              delay: const Duration(milliseconds: 100),
              child: _buildSkillsSection(candidate),
            ),

            const SizedBox(height: 20),

            // Experience Section
            if (candidate.experience != null &&
                candidate.experience!.isNotEmpty)
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                delay: const Duration(milliseconds: 200),
                child: _buildExperienceSection(candidate),
              ),

            const SizedBox(height: 20),

            // Jobs Section with real-time updates
            FadeInUp(
              duration: const Duration(milliseconds: 700),
              delay: const Duration(milliseconds: 300),
              child: _buildJobsSection(jobsAsync),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to edit profile
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildProfileHeader(Candidate candidate) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Photo
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              backgroundImage:
                  candidate.photo != null && candidate.photo!.isNotEmpty
                      ? NetworkImage(candidate.photo!)
                      : null,
              child:
                  candidate.photo == null || candidate.photo!.isEmpty
                      ? Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.blue.shade400,
                      )
                      : null,
            ),

            const SizedBox(height: 16),

            // Name and Main Position
            Text(
              candidate.name ?? 'Nombre no especificado',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            if (candidate.mainPosition != null &&
                candidate.mainPosition!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  candidate.mainPosition!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 12),

            // Location and Contact Info
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  candidate.location ?? 'Ubicación no especificada',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),

            if (candidate.phone != null && candidate.phone!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      candidate.phone!,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

            // Bio
            if (candidate.bio != null && candidate.bio!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  candidate.bio!,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection(Candidate candidate) {
    if (candidate.skills == null || candidate.skills!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Habilidades',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  candidate.skills!.map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        skill,
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceSection(Candidate candidate) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.work_history, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Experiencia',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              candidate.experience!,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobsSection(AsyncValue<List<Map<String, dynamic>>> jobsAsync) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.work_outline, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Empleos Disponibles',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Use the same job list component with real-time updates
            jobsAsync.when(
              loading:
                  () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
              error:
                  (error, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 8),
                          Text('Error cargando empleos: $error'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed:
                                () =>
                                    ref.invalidate(jobsProviderWithCompanyName),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    ),
                  ),
              data: (jobsData) {
                if (jobsData.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.work_off_outlined,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text('No hay empleos disponibles'),
                        ],
                      ),
                    ),
                  );
                }

                // Take only the first 5 jobs for the profile view
                final limitedJobs = jobsData.take(5).toList();

                return Column(
                  children: [
                    // Job cards using the same component as SimpleJobCardListView
                    ...limitedJobs.asMap().entries.map((entry) {
                      final index = entry.key;
                      final jobData = entry.value;
                      final job = Job.fromMap(jobData);

                      // Only animate on initial load, with a subtle staggered effect
                      return _initialLoad
                          ? FadeInUp(
                            duration: const Duration(milliseconds: 300),
                            delay: Duration(milliseconds: index * 50),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: SimpleJobCard(
                                job: job,
                                skipAnimation: false,
                              ),
                            ),
                          )
                          : Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: SimpleJobCard(job: job, skipAnimation: true),
                          );
                    }),

                    // Show "Ver más empleos" button if there are more jobs
                    if (jobsData.length > 5)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: Navigate to full jobs list
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            side: const BorderSide(color: Colors.blue),
                          ),
                          child: Text(
                            'Ver más empleos (${jobsData.length - 5} adicionales)',
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
