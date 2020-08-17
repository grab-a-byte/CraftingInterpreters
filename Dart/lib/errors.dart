import 'package:Dart/token.dart';

class RuntimeException implements Exception {}

class RuntimeError extends RuntimeException {
  final Token token;
  final String message;
  RuntimeError(this.token, this.message);

  @override
  String toString() {
    return '$message for ${token.type}';
  }
}
