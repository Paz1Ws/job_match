import 'package:flutter/material.dart';

class Job {
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
}
