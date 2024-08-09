import 'package:travel_mate/model.dart';
import 'package:async_redux/async_redux.dart';

class AuthResponseHandler {
  String? message;
  UserData? userData;

  AuthResponseHandler({
    this.message,
    this.userData,
});

  AuthResponseHandler.init() {
    message = "";
    // userData;
  }

  factory AuthResponseHandler.fromJson(Map<String, dynamic> json) {
  return AuthResponseHandler(
    message: json['detail'] as String,
  );
  }

  AuthResponseHandler copyWith({
    String? message,
    UserData? userData,
    Event<bool>? isInformed,
  }) {
    return AuthResponseHandler(
        message: message ?? this.message,
        userData: userData ?? this.userData,
    );
  }

  @override
  String toString() {
    return 'AuthResponseHandler{message: $message, userData: $userData}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthResponseHandler &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          userData == other.userData;

  @override
  int get hashCode => message.hashCode ^ userData.hashCode;
}
