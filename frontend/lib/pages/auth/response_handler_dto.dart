import 'package:travel_mate/model.dart';
import 'package:async_redux/async_redux.dart';

class ResponseHandler {
  String? message;
  dynamic data;
  int? status;

  ResponseHandler({
    this.message,
    this.data,
    this.status,
});

  ResponseHandler.init() {
    message = "";
    status = null;
    // userData;
  }

  factory ResponseHandler.fromJson(Map<String, dynamic> json) {
  return ResponseHandler(
    message: json['detail'] as String,
    status: json['status'] as int,
  );
  }

  ResponseHandler copyWith({
    String? message,
    UserData? userData,
    Event<bool>? isInformed,
  }) {
    return ResponseHandler(
        message: message ?? this.message,
        data: data ?? this.data,
    );
  }

  @override
  String toString() {
    return 'ResponseHandler{message: $message, data: $data, status: $status}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponseHandler &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          data == other.data &&
          status == other.status;

  @override
  int get hashCode => message.hashCode ^ data.hashCode ^ status.hashCode;
}
