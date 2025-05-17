import 'package:flutter/material.dart';

class AppliedJob {
  final String companyLogoAsset;
  final String jobTitle;
  final String jobType; // E.g., "Remoto", "Tiempo Completo"
  final String companyName; // Not in image, but good to have
  final String location;
  final String salary;
  final String dateApplied;
  final String status; // E.g., "Activo"
  final Color logoBackgroundColor;
  final bool isHighlighted; // For the "View Details" button style
  final int matchPercentage;

  AppliedJob({
    required this.companyLogoAsset,
    required this.jobTitle,
    required this.jobType,
    required this.companyName,
    required this.location,
    required this.salary,
    required this.dateApplied,
    required this.status,
    required this.logoBackgroundColor,
    this.isHighlighted = false,
    required this.matchPercentage,
  });
}
