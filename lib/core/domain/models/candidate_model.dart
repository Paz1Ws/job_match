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
  final String? mainPosition;
  final String? photo;

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
    this.mainPosition,
    this.photo,
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
    mainPosition: json['main_position'] as String?,
    photo: json['photo'] as String?,
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
    if (mainPosition != null) 'main_position': mainPosition,
    if (photo != null) 'photo': photo,
  };
  Candidate copyWith({
    String? userId,
    String? name,
    String? experience,
    String? education,
    List<String>? skills,
    DateTime? parsedAt,
    String? bio,
    String? location,
    String? resumeUrl,
    String? phone,
    String? mainPosition,
    String? photo,
  }) {
    return Candidate(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      parsedAt: parsedAt ?? this.parsedAt,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      phone: phone ?? this.phone,
      mainPosition: mainPosition ?? this.mainPosition,
      photo: photo ?? this.photo,
    );
  }
}
