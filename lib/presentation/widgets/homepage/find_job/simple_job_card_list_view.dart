import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/presentation/widgets/homepage/find_job/job_filter_provider.dart';
import 'package:job_match/presentation/widgets/homepage/find_job/simple_job_card.dart';

class SimpleJobCardListView extends ConsumerWidget {
  const SimpleJobCardListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(jobsProviderWithCompanyName);
    final jobFilter = ref.watch(jobFilterProvider);

    return jobsAsync.when(
      error: (error, __) {
        // print(error.toString());
        return Center(
        child: Text('Ha ocurrido un error al cargar los trabajos ${error.toString()}')
      );
      },
      loading: () => Center(
        child: const CircularProgressIndicator()
      ),
      data: (data) {
        //* Small filter
        final jobs = data.map((e) => Job.fromMap(e)).where((j) {
          final titleFounded = jobFilter.jobTitleLike == null || j.title.toLowerCase().contains(jobFilter.jobTitleLike!.toLowerCase());
          final companyNameFounded = jobFilter.jobTitleLike == null || j.companyName.toLowerCase().contains(jobFilter.jobTitleLike!.toLowerCase());
          return titleFounded || companyNameFounded;
        });

        return jobs.isNotEmpty ? ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: jobs.map(
            (e) => SimpleJobCard(job: e),
          ).toList(),
        ) :
        const Center(
          child: Text('Sin trabajos a mostrar'),
        );
      }
    );
  }
}
