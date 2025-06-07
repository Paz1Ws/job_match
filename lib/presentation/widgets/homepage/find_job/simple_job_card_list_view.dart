import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/data/jobs_listener.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/presentation/widgets/auth/app_identity_bar.dart';
import 'package:job_match/presentation/widgets/homepage/find_job/job_filter_provider.dart';
import 'package:job_match/presentation/widgets/homepage/find_job/simple_job_card.dart';
import 'package:job_match/presentation/screens/homepage/find_jobs_screen.dart';

class SimpleJobCardListView extends ConsumerStatefulWidget {
  final bool initialLoad;
  
  const SimpleJobCardListView({
    super.key, 
    this.initialLoad = true,
  });

  @override
  ConsumerState<SimpleJobCardListView> createState() =>
      _SimpleJobCardListViewState();
}

class _SimpleJobCardListViewState extends ConsumerState<SimpleJobCardListView> {
  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(jobsProviderWithCompanyName);
    final jobFilter = ref.watch(jobFilterProvider);
    final isCandidate = ref.watch(isCandidateProvider);
    final skipAnimations = ref.watch(skipAnimationsProvider);
    final shouldAnimate = widget.initialLoad && !skipAnimations;

    return jobsAsync.when(
      error: (error, __) {
        return const Center(
          child: Text('Error cargando los trabajos'),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (data) {
        // Filter jobs based on user type and job status
        final jobs = data.map((e) => Job.fromMap(e)).where((j) {
          // Title and company name filter
          final titleFounded =
              jobFilter.jobTitleLike == null ||
              j.title.toLowerCase().contains(
                jobFilter.jobTitleLike!.toLowerCase(),
              );
          final companyNameFounded =
              jobFilter.jobTitleLike == null ||
              j.companyName.toLowerCase().contains(
                jobFilter.jobTitleLike!.toLowerCase(),
              );
          
          return titleFounded || companyNameFounded;
        }).toList();

        return jobs.isNotEmpty
            ? ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: jobs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final job = entry.value;
                  
                  // Only animate on initial load, with a subtle staggered effect
                  return shouldAnimate
                      ? FadeInUp(
                          duration: const Duration(milliseconds: 300),
                          delay: Duration(milliseconds: index * 50), // Staggered delay
                          child: SimpleJobCard(
                            job: job,
                            skipAnimation: false,
                          ),
                        )
                      : SimpleJobCard(
                          job: job, 
                          skipAnimation: true,
                        );
                }).toList(),
              )
            : const Center(child: Text('Sin trabajos a mostrar'));
      },
    );
  }
}
