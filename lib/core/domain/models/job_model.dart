import 'package:flutter/material.dart';

class Job {
  final String id;
  final String? companyId;
  final String companyName;
  final String description;
  final String location;
  final String title;
  final String type;
  final String salaryMin;
  final String salaryMax;
  final Color logoBackgroundColor;
  final int matchPercentage;
  final String modality;
  final String status;
  final DateTime? createdAt;
  final DateTime? applicationDeadline;
  final List<String>? requiredSkills;
  final int? maxApplications;
  final int viewsCount;

  Job({
    required this.id,
    this.companyId,
    required this.companyName,
    required this.description,
    required this.location,
    required this.title,
    required this.type,
    required this.salaryMin,
    required this.salaryMax,
    required this.logoBackgroundColor,
    required this.matchPercentage,
    required this.modality,
    this.status = 'open',
    this.createdAt,
    this.applicationDeadline,
    this.requiredSkills,
    this.maxApplications,
    this.viewsCount = 0,
  });

  factory Job.fromMap(Map<String, dynamic> map) {
    String safeString(dynamic value, [String defaultValue = '']) {
      if (value == null) return defaultValue;
      return value.toString();
    }

    int safeInt(dynamic value, [int defaultValue = 0]) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    }

    DateTime? safeDateTime(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    List<String>? safeStringList(dynamic value) {
      if (value == null) return null;
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      return null;
    }

    return Job(
      id: safeString(map['id'], '*'),
      companyId: map['company_id']?.toString(),
      companyName: safeString(
        map['users']?['companies']?['company_name'],
        'Empresa',
      ),
      description: safeString(
        map['description'],
        'Descripción del trabajo no disponible.',
      ),
      location: safeString(map['location'], 'Lima, Perú'),
      title: safeString(map['title']),
      type: safeString(map['job_type'], 'Tiempo Completo'),
      salaryMin: safeString(map['salary_min'], 'S/5000'),
      salaryMax: safeString(map['salary_max'], 'S/10000'),

      logoBackgroundColor: Colors.blue.shade100,
      matchPercentage: 80,
      modality: safeString(map['modality'], 'Presencial'),
      status: safeString(map['status'], 'open'),
      createdAt: safeDateTime(map['created_at']),
      applicationDeadline: safeDateTime(map['application_deadline']),
      requiredSkills: safeStringList(map['required_skills']),
      maxApplications:
          map['max_applications'] != null
              ? safeInt(map['max_applications'])
              : null,
      viewsCount: safeInt(map['views_count'], 0),
    );
  }
  Job copyWith({
    String? id,
    String? companyId,
    String? companyName,
    String? description,
    String? location,
    String? title,
    String? type,
    String? salaryMin,
    String? salaryMax,
    Color? logoBackgroundColor,
    int? matchPercentage,
    String? modality,
    String? status,
    DateTime? createdAt,
    DateTime? applicationDeadline,
    List<String>? requiredSkills,
    int? maxApplications,
    int? viewsCount,
  }) {
    return Job(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      description: description ?? this.description,
      location: location ?? this.location,
      title: title ?? this.title,
      type: type ?? this.type,
      salaryMin: salaryMin ?? this.salaryMin,
      salaryMax: salaryMax ?? this.salaryMax,
      logoBackgroundColor: logoBackgroundColor ?? this.logoBackgroundColor,
      matchPercentage: matchPercentage ?? this.matchPercentage,
      modality: modality ?? this.modality,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      applicationDeadline: applicationDeadline ?? this.applicationDeadline,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      maxApplications: maxApplications ?? this.maxApplications,
      viewsCount: viewsCount ?? this.viewsCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'company_id': companyId,
      'title': title,
      'description': description,
      'location': location,
      'job_type': type,
      'salary_min': salaryMin.replaceAll('S/', ''),
      'salary_max': salaryMax.replaceAll('S/', ''),
      'modality': modality,
      'status': status,
      'application_deadline': applicationDeadline?.toIso8601String(),
      'required_skills': requiredSkills,
      'max_applications': maxApplications,
      'views_count': viewsCount,
    };
  }
}
