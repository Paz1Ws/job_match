class NotificationModel {
  final String id;
  final String userId;
  final String message;
  final Map<String, dynamic>? payload;
  final bool read;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.message,
    this.payload,
    required this.read,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        message: json['message'] as String,
        payload: (json['payload'] as Map?)?.cast<String, dynamic>(),
        read: json['read'] as bool,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'message': message,
    if (payload != null) 'payload': payload,
    'read': read,
    'created_at': createdAt.toIso8601String(),
  };
}
