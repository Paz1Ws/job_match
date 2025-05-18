import 'package:flutter/material.dart';
import 'package:job_match/presentation/screens/homepage/widgets/footer_find_jobs.dart';
import 'package:job_match/presentation/screens/homepage/widgets/home_page_top_bar.dart';
import 'package:job_match/presentation/screens/homepage/widgets/job_filter_sidebar.dart';
import 'package:job_match/presentation/screens/homepage/widgets/simple_job_card_list_view.dart';
import 'package:job_match/presentation/screens/homepage/widgets/top_companies.dart';

class FindJobsScreen extends StatelessWidget {
  const FindJobsScreen({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //* Headers again
            Container(
              color: Colors.black,
              child: Column(
                children: [
                  HomePageTopBar(),
                  const Text('Trabajos', style: TextStyle(fontSize: 50, color: Colors.white)),
                  const SizedBox(height: 10)
                ],
              ),
            ),

            const SizedBox(height: 20),

            //* Find job list
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: JobFilterSidebar(),
                  )
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SimpleJobCardListView(),
                  )
                )
              ],
            ),
          
            TopCompanies(),

            FooterFindJobs()
          ],
        ),
      ),
    );
  }
}