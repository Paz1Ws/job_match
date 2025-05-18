class Candidate {
  final String userId;
  final String? name;
  final String? experience;
  final String? education;
  final List<String>? skills;
  final DateTime? parsedAt;
  final String? bio;
  final String? location;
  final String? resumeUrl;
  final String? phone;
  final String? experienceLevel; // Debe ser 'Junior', 'Mid' o 'Senior'

  Candidate({
    required this.userId,
    this.name,
    this.experience,
    this.education,
    this.skills,
    this.parsedAt,
    this.bio,
    this.location,
    this.resumeUrl,
    this.phone,
    this.experienceLevel,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) => Candidate(
    userId: json['user_id'] as String,
    name: json['name'] as String?,
    experience: json['experience'] as String?,
    education: json['education'] as String?,
    skills: (json['skills'] as List?)?.map((e) => e as String).toList(),
    parsedAt:
        json['parsed_at'] != null ? DateTime.parse(json['parsed_at']) : null,
    bio: json['bio'] as String?,
    location: json['location'] as String?,
    resumeUrl: json['resume_url'] as String?,
    phone: json['phone'] as String?,
    experienceLevel: json['experience_level'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    if (name != null) 'name': name,
    if (experience != null) 'experience': experience,
    if (education != null) 'education': education,
    if (skills != null) 'skills': skills,
    if (parsedAt != null) 'parsed_at': parsedAt!.toIso8601String(),
    if (bio != null) 'bio': bio,
    if (location != null) 'location': location,
    if (resumeUrl != null) 'resume_url': resumeUrl,
    if (phone != null) 'phone': phone,
    if (experienceLevel != null) 'experience_level': experienceLevel,
  };
}
