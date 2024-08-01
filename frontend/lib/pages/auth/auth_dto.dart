
import '../../user_role.dart';

class AuthDto{
  String? name;
  String? email;
  String? password;
  String? checkPassword;
  UserRole? role;

  AuthDto({
    this.name,
    this.email,
    this.password,
    this.role,
    this.checkPassword,
  });

  AuthDto copyWith({
    String? name,
    String? email,
    String? password,
    String? checkPassword,
    UserRole? role,
  }){
    return AuthDto(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        checkPassword: checkPassword ?? this.checkPassword,
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
              checkPassword == other.checkPassword &&
              role == other.role;

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ password.hashCode ^ checkPassword.hashCode ^ role.hashCode;

  @override
  String toString() {
    return 'UserData{name: $name, email: $email, password: $password, checkPassword: $checkPassword, role: $role}';
  }

  AuthDto.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        email = json['email'] as String,
        password = json['password'] as String,
        checkPassword = json['checkPassword'] as String,
        role = json['role'] as UserRole;

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'role': userRoleToJson(role),
  };
}