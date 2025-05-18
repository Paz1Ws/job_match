// class UserModel extends UserEntity {
//   UserModel({required super.id, required super.email, required super.name});

//   factory UserModel.fromJson(Map<String, dynamic> map) {
//     return UserModel(
//       id: map['id'] ?? '',
//       email: map['email'] ?? '',
//       name: map['name'] ?? '',
//     );
//   }

//   UserModel copyWith({String? id, String? email, String? name}) {
//     return UserModel(
//       id: id ?? this.id,
//       email: email ?? this.email,
//       name: name ?? this.name,
//     );
//   }
// }

// class UserEntity {
//   final String id;
//   final String email;
//   String name;

//   UserEntity({required this.id, required this.email, required this.name});
// }
