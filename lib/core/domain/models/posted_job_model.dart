import 'package:flutter/material.dart';
import 'package:job_match/core/domain/models/job_model.dart'; // For potential reuse or linking

enum JobStatus { Active, Expired }

class PostedJob {
  final String id;
  final String title;
  final String jobType; // e.g., Full Time, Internship
  final String remainingTime; // e.g., "27 days remaining" or a date
  final JobStatus status;
  final int applicationsCount;
  final bool isSelectedRow; // For UI highlighting as in the image
  final Job jobDetails; // To navigate to JobDetailScreen

  PostedJob({
    required this.id,
    required this.title,
    required this.jobType,
    required this.remainingTime,
    required this.status,
    required this.applicationsCount,
    this.isSelectedRow = false,
    required this.jobDetails,
  });
}
