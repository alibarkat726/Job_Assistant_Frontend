import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _dio;
  final void Function()? onSessionExpired;

  bool _isRefreshing = false;

  static const _publicPaths = [
    '/auth/register',
    '/auth/login',
    '/auth/refresh',
    '/auth/request-password-reset',
    '/auth/reset-password',
    '/auth/verify-email',
  ];

  AuthInterceptor({
    required TokenStorage tokenStorage,
    required Dio dio,
    this.onSessionExpired,
  })  : _tokenStorage = tokenStorage,
        _dio = dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isPublic = _publicPaths.any((path) => options.path.endsWith(path));

    if (!isPublic) {
      final token = await _tokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isPublic = _publicPaths.any((path) => err.requestOptions.path.endsWith(path));

    if (err.response?.statusCode == 401 && !isPublic && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshToken = await _tokenStorage.getRefreshToken();
        if (refreshToken != null && refreshToken.isNotEmpty) {
          // Dedicated Dio instance for refresh call to avoid interceptor loop
          final refreshDio = Dio(BaseOptions(
            baseUrl: _dio.options.baseUrl,
            headers: {'Content-Type': 'application/json'},
          ));

          final response = await refreshDio.post(
            '/auth/refresh',
            data: {'refresh_token': refreshToken},
          );

          if (response.statusCode == 200 && response.data != null) {
            final newAccessToken = response.data['access_token'] as String;
            final newRefreshToken = response.data['refresh_token'] as String;

            await _tokenStorage.saveTokens(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken,
            );

            // Retry original request with new token
            final originalOptions = err.requestOptions;
            originalOptions.headers['Authorization'] = 'Bearer $newAccessToken';

            final retryResponse = await _dio.fetch(originalOptions);
            _isRefreshing = false;
            return handler.resolve(retryResponse);
          }
        }
      } catch (e) {
        _isRefreshing = false;
        await _tokenStorage.clearTokens();
        onSessionExpired?.call();
        return handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    }

    handler.next(err);
  }
}
