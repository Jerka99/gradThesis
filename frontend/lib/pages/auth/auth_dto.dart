
import '../../user_role.dart';

class AuthDto{
  String? name;
  String? email;
  String? password;
  UserRole? role;

  AuthDto({
    this.name,
    this.email,
    this.password,
    this.role
  });

  AuthDto copyWith({
    String? name,
    String? email,
    String? password,
    UserRole? role
  }){
    return AuthDto(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        role: role ?? this.role);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AuthDto &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              email == other.email &&
              password == other.password &&
              role == other.role;

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ password.hashCode ^ role.hashCode;

  @override
  String toString() {
    return 'UserData{name: $name, email: $email, password: $password, role: $role}';
  }

  AuthDto.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        email = json['email'] as String,
        password = json['password'] as String,
        role = json['role'] as UserRole;

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'role': role,
  };
}