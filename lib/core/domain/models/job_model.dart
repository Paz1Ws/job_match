import 'package:flutter/material.dart';

class Job {
  final String id;
  final String logoAsset;
  final String companyName;
  final String location;
  final String title;
  final String type;
  final String salary;
  final bool isFeatured;
  final Color logoBackgroundColor;
  final int matchPercentage;

  Job({
    this.id = '*',
    required this.logoAsset,
    required this.companyName,
    required this.location,
    required this.title,
    required this.type,
    required this.salary,
    this.isFeatured = false,
    required this.logoBackgroundColor,
    required this.matchPercentage,
  });

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'] ?? '*',
      logoAsset: 'assets/images/job_match.jpg', //* Default value
      companyName:
          map['users']?['companies']?['company_name'] ?? 'Empresa', //* ...
      location: map['location'] ?? 'Lima, Perú',
      title: map['title'] ?? '',
      type: map['job_type'] ?? 'Tiempo Completo',
      salary: map['salary_range'] ?? 'S/5000',
      isFeatured: map['is_featured'] ?? false,
      logoBackgroundColor: Colors.blue.shade100, //* Default value
      matchPercentage: 80, //* Default value
    );
  }
}
