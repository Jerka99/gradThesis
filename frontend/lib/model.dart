import 'user_role.dart';

class UserData{
  String? name;
  String? email;
  UserRole? role;
  int? id;

  UserData({
    this.name,
    this.email,
    this.role,
    this.id
  });

  UserData copyWith({
    String? name,
    String? email,
    UserRole? role,
    int? id,
  }){
    return UserData(
        name: name ?? this.name,
        email: email ?? this.email,
        role: role ?? this.role,
        id: id ?? this.id);
    }

    UserData.init() {
      UserData(name: null, email: null, role: userRoleFromJson(null), id: null);
    }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserData &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email &&
          role == other.role &&
          id == other.id;

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ role.hashCode ^ id.hashCode;

  @override
  String toString() {
    return 'UserData{name: $name, email: $email, role: $role, id $id}';
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'] as String,
      email: json['email'] as String,
      role: userRoleFromJson(json['role']['name'] as String?),
      id: json['id'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'role': role,
        'id': id
      };
}