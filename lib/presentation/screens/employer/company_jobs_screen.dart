import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/core/domain/models/company_model.dart';
import 'package:job_match/presentation/widgets/homepage/find_job/simple_job_card.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/core/data/jobs_listener.dart'; // Add this import

class CompanyJobsScreen extends ConsumerStatefulWidget {
  final String companyId;
  final Company company;
  const CompanyJobsScreen({
    super.key,
    required this.companyId,
    required this.company,
  });

  @override
  ConsumerState<CompanyJobsScreen> createState() => _CompanyJobsScreenState();
}

class _CompanyJobsScreenState extends ConsumerState<CompanyJobsScreen>
    with JobRealtimeUpdatesMixin {
  @override
  void initState() {
    super.initState();

    // Initialize existing provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.companyId.isNotEmpty) {
        ref.invalidate(jobsByCompanyIdProvider(widget.companyId));
      }

      // Initialize the Jobs Listener after the first frame
      // to avoid initialization during build
      initializeJobsListener(
        onJobCreated: (newJob) {
          if (newJob.companyId == widget.companyId) {
            _refreshJobs();
          }
        },
        onJobUpdated: (updatedJob, oldJob) {
          if (updatedJob.companyId == widget.companyId) {
            _refreshJobs();
          }
        },
        onJobDeleted: (deletedJob) {
          if (deletedJob.companyId == widget.companyId) {
            _refreshJobs();
          }
        },
      );
    });
  }

  // Safe refresh without causing build errors
  void _refreshJobs() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.invalidate(jobsByCompanyIdProvider(widget.companyId));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(jobsByCompanyIdProvider(widget.companyId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Empleos Publicados'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshJobs,
            tooltip: 'Actualizar lista',
          ),
        ],
      ),
      body: jobsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshJobs,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
        data: (jobs) {
          if (jobs.isEmpty) {
            return Center(
              child: FadeInUp(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.work_off_outlined,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No has publicado empleos aún',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Comienza publicando tu primera vacante',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  child: Text(
                    '${jobs.length} empleo${jobs.length != 1 ? 's' : ''} publicado${jobs.length != 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      return FadeInUp(
                        delay: Duration(milliseconds: 100 * index),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: SimpleJobCard(
                            job: job,
                            company: widget.company,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    disposeJobsListener();
    super.dispose();
  }
}
