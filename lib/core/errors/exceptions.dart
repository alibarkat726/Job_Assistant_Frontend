class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;
  final int? statusCode;

  const AppException({
    required this.message,
    this.code,
    this.details,
    this.statusCode,
  });

  @override
  String toString() => 'AppException(code: $code, message: $message, statusCode: $statusCode)';
}

class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
    super.details,
    super.statusCode,
  });
}

class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.details,
    super.statusCode,
  });
}

class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.details,
    super.statusCode,
  });
}

class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.details,
    super.statusCode,
  });
}
