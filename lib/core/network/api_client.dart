import 'package:dio/dio.dart';
import '../errors/exceptions.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

class ApiClient {
  final Dio dio;

  ApiClient({
    required TokenStorage tokenStorage,
    String? baseUrl,
    void Function()? onSessionExpired,
  }) : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ?? 'http://localhost:8001/api/v1',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    dio.interceptors.add(
      AuthInterceptor(
        tokenStorage: tokenStorage,
        dio: dio,
        onSessionExpired: onSessionExpired,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, handler) {
          final appException = _handleDioException(error);
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: appException,
            ),
          );
        },
      ),
    );
  }

  static AppException _handleDioException(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const NetworkException(
        message: 'Network connection failed. Please check your internet connection.',
        code: 'NETWORK_ERROR',
      );
    }

    final response = error.response;
    if (response != null && response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if (data.containsKey('error') && data['error'] is Map<String, dynamic>) {
        final errorData = data['error'] as Map<String, dynamic>;
        final code = errorData['code'] as String? ?? 'UNKNOWN_ERROR';
        final message = errorData['message'] as String? ?? 'An unexpected error occurred.';
        final details = errorData['details'];
        final statusCode = response.statusCode;

        switch (statusCode) {
          case 400:
            return ServerException(
              message: message,
              code: code,
              details: details,
              statusCode: statusCode,
            );
          case 401:
            return AuthException(
              message: message,
              code: code,
              details: details,
              statusCode: statusCode,
            );
          case 403:
            return AuthException(
              message: message,
              code: code,
              details: details,
              statusCode: statusCode,
            );
          case 422:
            return ValidationException(
              message: message,
              code: code,
              details: details,
              statusCode: statusCode,
            );
          case 429:
            return ServerException(
              message: message,
              code: code,
              details: details,
              statusCode: statusCode,
            );
          default:
            return ServerException(
              message: message,
              code: code,
              details: details,
              statusCode: statusCode,
            );
        }
      }
    }

    return ServerException(
      message: error.message ?? 'An unknown error occurred.',
      code: 'UNKNOWN_SERVER_ERROR',
      statusCode: response?.statusCode,
    );
  }
}
