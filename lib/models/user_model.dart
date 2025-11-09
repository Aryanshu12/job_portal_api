class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final bool? verified;

  UserModel({this.id, this.name, this.email, this.role, this.verified});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String? ?? json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      verified: json['isVerified'] as bool? ?? json['verified'] as bool?,
    );
  }
}
