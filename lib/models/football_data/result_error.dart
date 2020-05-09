class ResultError {
  final String message;

  const ResultError({this.message});

  static ResultError fromJson(dynamic json) {
    return ResultError(message: json['error'] as String);
  }
}
