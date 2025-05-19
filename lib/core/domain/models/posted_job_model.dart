import 'package:flutter/material.dart';
import 'package:job_match/core/domain/models/job_model.dart'; // For potential reuse or linking

enum JobStatus { Active, Expired }

class PostedJob {
  final String id;
  final String? companyId;
  final String title;
  final String? description;
  final DateTime? createdAt;
  final String? location;
  final String? jobType; // 'full-time', 'part-time', 'contract', 'freelance'
  final num? salaryMin;
  final num? salaryMax;
  final DateTime? applicationDeadline;
  final String status; // 'open', 'closed', 'paused'
  final List<String>? requiredSkills;
  final int? maxApplications;
  final int viewsCount;

  PostedJob({
    required this.id,
    this.companyId,
    required this.title,
    this.description,
    this.createdAt,
    this.location,
    this.jobType,
    this.salaryMin,
    this.salaryMax,
    this.applicationDeadline,
    required this.status,
    this.requiredSkills,
    this.maxApplications,
    required this.viewsCount,
  });

  factory PostedJob.fromJson(Map<String, dynamic> json) => PostedJob(
    id: json['id'] as String,
    companyId: json['company_id'] as String?,
    title: json['title'] as String,
    description: json['description'] as String?,
    createdAt:
        json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
    location: json['location'] as String?,
    jobType: json['job_type'] as String?,
    salaryMin: json['salary_min'] as num?,
    salaryMax: json['salary_max'] as num?,
    applicationDeadline:
        json['application_deadline'] != null
            ? DateTime.parse(json['application_deadline'] as String)
            : null,
    status: json['status'] as String,
    requiredSkills:
        (json['required_skills'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
    maxApplications: json['max_applications'] as int?,
    viewsCount: json['views_count'] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    if (companyId != null) 'company_id': companyId,
    'title': title,
    if (description != null) 'description': description,
    if (location != null) 'location': location,
    if (jobType != null) 'job_type': jobType,
    if (salaryMin != null) 'salary_min': salaryMin,
    if (salaryMax != null) 'salary_max': salaryMax,
    if (applicationDeadline != null)
      'application_deadline': applicationDeadline!.toIso8601String(),
    'status': status,
    if (requiredSkills != null) 'required_skills': requiredSkills,
    if (maxApplications != null) 'max_applications': maxApplications,
  };
}
