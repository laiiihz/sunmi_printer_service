class NotImplementException implements Exception {
  final Object? message;
  NotImplementException([this.message]);

  @override
  String toString() {
    return "[NotImpementException]:$message";
  }
}
