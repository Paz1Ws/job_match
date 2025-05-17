import 'package:flutter/material.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/presentation/widgets/dashboard/employer/applicant_profile_popup.dart'; // Will be created

class EducationEntry {
  final String degree;
  final String institution;
  final String period; // e.g., "2018 - 2022"
  final String? description;

  EducationEntry({
    required this.degree,
    required this.institution,
    required this.period,
    this.description,
  });
}

class ExperienceEntry {
  final String jobTitle;
  final String companyName;
  final String period; // e.g., "Jan 2020 - Present"
  final String? description;

  ExperienceEntry({
    required this.jobTitle,
    required this.companyName,
    required this.period,
    this.description,
  });
}

class Applicant {
  final String name;
  final String role;
  final String avatarUrl; // Can be a local asset or network URL
  final String experience;
  final String education;
  final String appliedDate;
  final String cvUrl; // For download functionality

  // Detailed information for the popup
  final String? email;
  final String? phone;
  final String? address;
  final int? age;
  final String? currentSalary; // e.g., "$50k - $60k"
  final String? expectedSalary; // e.g., "$70k - $80k"
  final String? biography;
  final List<String> skills;
  final List<EducationEntry> educationHistory;
  final List<ExperienceEntry> workExperience;

  Applicant({
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.experience,
    required this.education,
    required this.appliedDate,
    required this.cvUrl,
    this.email,
    this.phone,
    this.address,
    this.age,
    this.currentSalary,
    this.expectedSalary,
    this.biography,
    this.skills = const [],
    this.educationHistory = const [],
    this.workExperience = const [],
  });
}

class ApplicantCard extends StatelessWidget {
  final Applicant applicant;

  const ApplicantCard({super.key, required this.applicant});

  Widget _buildInfoRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kSpacing4 / 2),
      child: Row(
        children: [
          const Text('• ', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ApplicantProfilePopup(applicant: applicant);
          },
        );
      },
      child: Container(
        width: 280, // Adjust width as needed or make it responsive
        padding: const EdgeInsets.all(kPadding16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kRadius12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: kRadius20 + kRadius4, // 24
                  backgroundColor: Colors.grey.shade200, 
                  backgroundImage: applicant.avatarUrl.isNotEmpty && applicant.avatarUrl.startsWith('assets/')
                      ? AssetImage(applicant.avatarUrl)
                      : applicant.avatarUrl.isNotEmpty
                          ? NetworkImage(applicant.avatarUrl) as ImageProvider
                          : null,
                  child: applicant.avatarUrl.isEmpty
                      ? Icon(Icons.person, size: kIconSize24 + kSpacing4, color: Colors.grey.shade500)
                      : null,
                ),
                const SizedBox(width: kSpacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        applicant.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        applicant.role,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: kSpacing20, thickness: 1, color: Color(0xFFE5E7EB)),
            _buildInfoRow(applicant.experience),
            _buildInfoRow('Education: ${applicant.education}'),
            _buildInfoRow('Applied: ${applicant.appliedDate}'),
            const SizedBox(height: kSpacing12),
            TextButton.icon(
              onPressed: () {
                // Handle CV download
                print('Download CV: ${applicant.cvUrl}');
              },
              icon: Icon(Icons.download_outlined, color: Colors.blue.shade700, size: kIconSize20),
              label: Text(
                'Download Cv',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: kPadding8), // Minimal padding
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
