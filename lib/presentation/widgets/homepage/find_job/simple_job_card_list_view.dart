import 'package:flutter/material.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/presentation/widgets/homepage/find_job/simple_job_card.dart';

class SimpleJobCardListView extends StatelessWidget {
  const SimpleJobCardListView({super.key});

  @override
  Widget build(BuildContext context) {
    // Mockup jobs for demonstration
    final jobsMockup = [
      Job(
        logoAsset: 'assets/images/job_match.jpg',
        companyName: 'JobMatch Recruiting',
        location: 'Lima, Perú',
        title: 'Especialista en Comunicaciones',
        type: 'Tiempo Completo',
        salary: 'S/5000',
        isFeatured: true,
        logoBackgroundColor: Colors.blue.shade100,
        matchPercentage: 92,
      ),
      Job(
        logoAsset: 'assets/images/job_match.jpg',
        companyName: 'Digital Solutions',
        location: 'Lima, Perú',
        title: 'Content Manager',
        type: 'Full-time',
        salary: 'S/4000',
        isFeatured: false,
        logoBackgroundColor: Colors.orange.shade100,
        matchPercentage: 78,
      ),
      Job(
        logoAsset: 'assets/images/job_match.jpg',
        companyName: 'Global Tech',
        location: 'Remoto',
        title: 'Marketing Specialist',
        type: 'Remoto',
        salary: 'S/4500',
        isFeatured: false,
        logoBackgroundColor: Colors.green.shade100,
        matchPercentage: 65,
      ),
      Job(
        logoAsset: 'assets/images/job_match.jpg',
        companyName: 'Tesla',
        location: 'Arequipa, Perú',
        title: 'Ingeniero de Software',
        type: 'Tiempo Completo',
        salary: 'S/7000',
        isFeatured: true,
        logoBackgroundColor: Colors.red.shade100,
        matchPercentage: 88,
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: jobsMockup.length,
      itemBuilder: (context, index) {
        final job = jobsMockup[index];
        return SimpleJobCard(job: job);
      },
    );
  }
}
