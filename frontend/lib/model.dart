import 'user_role.dart';

class UserData{
  String? userName;
  String? email;
  UserRole? role;

  UserData({
    this.userName,
    this.email,
    this.role});

  UserData copyWith({
    String? userName,
    String? email,
    UserRole? role
  }){
    return UserData(
        userName: userName ?? this.userName,
        email: email ?? this.email,
        role: role ?? this.role);
    }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserData &&
          runtimeType == other.runtimeType &&
          userName == other.userName &&
          email == other.email &&
          role == other.role;

  @override
  int get hashCode => userName.hashCode ^ email.hashCode ^ role.hashCode;

  @override
  String toString() {
    return 'UserData{userName: $userName, email: $email, role: $role}';
  }
}