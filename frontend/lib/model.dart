import 'user_role.dart';

class UserData{
  String? name;
  String? email;
  UserRole? role;

  UserData({
    this.name,
    this.email,
    this.role
  });

  UserData copyWith({
    String? name,
    String? email,
    UserRole? role
  }){
    return UserData(
        name: name ?? this.name,
        email: email ?? this.email,
        role: role ?? this.role);
    }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserData &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email &&
          role == other.role;

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ role.hashCode;

  @override
  String toString() {
    return 'UserData{name: $name, email: $email, role: $role}';
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'] as String,
      email: json['email'] as String,
      role: userRoleFromJson(json['roles'][0]['name'] as String?),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'role': role,
      };
}