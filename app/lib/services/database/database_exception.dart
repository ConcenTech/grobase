class DatabaseException implements Exception {
  DatabaseException(this.message, {this.error});

  final String message;
  final Object? error;

  @override
  String toString() => 'DatabaseException: $message $error';
}
