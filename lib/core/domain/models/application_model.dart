class Application {
  final String id;
  final String jobId;
  final String userId;
  final String status;
  final DateTime appliedAt;

  Application({
    required this.id,
    required this.jobId,
    required this.userId,
    required this.status,
    required this.appliedAt,
  });

  factory Application.fromJson(Map<String, dynamic> json) => Application(
    id: json['id'] as String,
    jobId: json['job_id'] as String,
    userId: json['user_id'] as String,
    status: json['status'] as String,
    appliedAt: DateTime.parse(json['applied_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'job_id': jobId,
    'user_id': userId,
    'status': status,
    'applied_at': appliedAt.toIso8601String(),
  };
}
