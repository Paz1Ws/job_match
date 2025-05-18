import 'package:flutter/material.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/presentation/widgets/dashboard/employer/applicant_card.dart'; // For Applicant, EducationEntry, ExperienceEntry models

class ApplicantProfilePopup extends StatelessWidget {
  final Applicant applicant;

  const ApplicantProfilePopup({super.key, required this.applicant});

  Widget _buildSectionTitle(String title, {EdgeInsetsGeometry? padding}) {
    return Padding(
      padding:
          padding ?? const EdgeInsets.only(top: kSpacing20, bottom: kSpacing12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF222B45),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String? value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kSpacing4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Icon(icon, size: kIconSize18, color: Colors.grey.shade600),
          if (icon != null) const SizedBox(width: kSpacing8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationEntryWidget(EducationEntry entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kSpacing12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.degree,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF222B45),
            ),
          ),
          Text(
            '${entry.institution} • ${entry.period}',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
          if (entry.description != null && entry.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: kSpacing4),
              child: Text(
                entry.description!,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExperienceEntryWidget(ExperienceEntry entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kSpacing12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.jobTitle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF222B45),
            ),
          ),
          Text(
            '${entry.companyName} • ${entry.period}',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
          if (entry.description != null && entry.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: kSpacing4),
              child: Text(
                entry.description!,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadius12),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: kPadding20,
        vertical: kPadding20 + kSpacing4,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 800, // Max width for the dialog
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          children: [
            // Header Part
            Padding(
              padding: const EdgeInsets.all(kPadding20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: kRadius40,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage:
                        applicant.avatarUrl.isNotEmpty &&
                                applicant.avatarUrl.startsWith('assets/')
                            ? AssetImage(applicant.avatarUrl)
                            : applicant.avatarUrl.isNotEmpty
                            ? NetworkImage(applicant.avatarUrl) as ImageProvider
                            : null,
                    child:
                        applicant.avatarUrl.isEmpty
                            ? Icon(
                              Icons.person,
                              size: kIconSize48,
                              color: Colors.grey.shade500,
                            )
                            : null,
                  ),
                  const SizedBox(width: kSpacing20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          applicant.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        Text(
                          applicant.role,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: kSpacing20),
                  TextButton.icon(
                    icon: Icon(
                      Icons.file_download_outlined,
                      color: Colors.blue.shade700,
                    ),
                    label: Text(
                      'Download CV',
                      style: TextStyle(color: Colors.blue.shade700),
                    ),
                    onPressed: () {
                      /* CV Download Logic */
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kPadding12,
                        vertical: kPadding8,
                      ),
                      side: BorderSide(color: Colors.blue.shade200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kRadius8),
                      ),
                    ),
                  ),
                  const SizedBox(width: kSpacing12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.message_outlined, size: kIconSize18),
                    label: const Text('Message'),
                    onPressed: () {
                      /* Message Logic */
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: kPadding16,
                        vertical: kPadding12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kRadius8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            // Scrollable Content Part
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(kPadding20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(
                      'Contact Information',
                      padding: const EdgeInsets.only(bottom: kSpacing8),
                    ),
                    _buildInfoItem(
                      'Email',
                      applicant.email,
                      icon: Icons.email_outlined,
                    ),
                    _buildInfoItem(
                      'Phone',
                      applicant.phone,
                      icon: Icons.phone_outlined,
                    ),
                    _buildInfoItem(
                      'Address',
                      applicant.address,
                      icon: Icons.location_on_outlined,
                    ),

                    _buildSectionTitle('Basic Information'),
                    _buildInfoItem('Experience', applicant.experience),
                    _buildInfoItem('Age', applicant.age?.toString() ?? 'N/A'),
                    _buildInfoItem('Current Salary', applicant.currentSalary),
                    _buildInfoItem('Expected Salary', applicant.expectedSalary),

                    _buildSectionTitle('Biography'),
                    Text(
                      applicant.biography ?? 'No biography provided.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4B5563),
                        height: 1.5,
                      ),
                    ),

                    _buildSectionTitle('Skills'),
                    Wrap(
                      spacing: kSpacing8,
                      runSpacing: kSpacing8,
                      children:
                          applicant.skills
                              .map(
                                (skill) => Chip(
                                  label: Text(skill),
                                  backgroundColor: Colors.blue.shade50,
                                  labelStyle: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontSize: 13,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: kPadding8,
                                    vertical: kSpacing4,
                                  ),
                                ),
                              )
                              .toList(),
                    ),

                    _buildSectionTitle('Education'),
                    if (applicant.educationHistory.isEmpty)
                      const Text(
                        'No education history provided.',
                        style: TextStyle(color: Colors.grey),
                      )
                    else
                      ...applicant.educationHistory.map(
                        _buildEducationEntryWidget,
                      ),

                    _buildSectionTitle('Experience'),
                    if (applicant.workExperience.isEmpty)
                      const Text(
                        'No work experience provided.',
                        style: TextStyle(color: Colors.grey),
                      )
                    else
                      ...applicant.workExperience.map(
                        _buildExperienceEntryWidget,
                      ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            // Footer Part
            Padding(
              padding: const EdgeInsets.all(kPadding12),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: kPadding20,
                      vertical: kPadding12,
                    ),
                  ),
                  child: const Text('Cerrar', style: TextStyle(fontSize: 15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
