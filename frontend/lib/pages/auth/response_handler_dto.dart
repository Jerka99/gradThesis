class ResponseHandler {
  String? description;
  String? detail;

  ResponseHandler({
    this.description,
    this.detail,
});

  ResponseHandler.init({
    this.description = "",
    this.detail = "",
  });

  factory ResponseHandler.fromJson(Map<String, dynamic> json) {
  return ResponseHandler(
  description: json['description'] as String,
  detail: json['detail'] as String,
  );
  }

  ResponseHandler copyWith({
    String? description,
    String? detail,
  }) {
    return ResponseHandler(
        description: description ?? this.description,
        detail: detail ?? this.detail,
    );
  }


  @override
  String toString() {
    return 'ResponseHandler{ description: $description, detail: $detail}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponseHandler &&
          runtimeType == other.runtimeType &&
          description == other.description &&
          detail == other.detail;

  @override
  int get hashCode => description.hashCode ^ detail.hashCode;
}
