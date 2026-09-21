import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/login_request_dto.dart';
import '../models/refresh_request_dto.dart';
import '../models/register_request_dto.dart';
import '../models/user_dto.dart';
import '../services/auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl({
    required AuthApiService apiService,
    required TokenStorage tokenStorage,
  })  : _apiService = apiService,
        _tokenStorage = tokenStorage;

  @override
  Future<({Failure? failure, User? user})> register({
    required String email,
    required String password,
  }) async {
    try {
      final userDto = await _apiService.register(
        RegisterRequestDto(email: email, password: password),
      );
      return (failure: null, user: userDto.toDomain());
    } catch (e) {
      return (failure: _mapExceptionToFailure(e), user: null);
    }
  }

  @override
  Future<({Failure? failure, User? user})> login({
    required String email,
    required String password,
  }) async {
    try {
      final loginResponse = await _apiService.login(
        LoginRequestDto(email: email, password: password),
      );

      await _tokenStorage.saveTokens(
        accessToken: loginResponse.accessToken,
        refreshToken: loginResponse.refreshToken,
      );

      final userDto = await _apiService.getCurrentUser();
      return (failure: null, user: userDto.toDomain());
    } catch (e) {
      return (failure: _mapExceptionToFailure(e), user: null);
    }
  }

  @override
  Future<({Failure? failure, bool success})> logout() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken != null) {
        try {
          await _apiService.logout(RefreshRequestDto(refreshToken: refreshToken));
        } catch (_) {
          // Ignore remote logout failure, clear local session regardless
        }
      }
      await _tokenStorage.clearTokens();
      return (failure: null, success: true);
    } catch (e) {
      await _tokenStorage.clearTokens();
      return (failure: _mapExceptionToFailure(e), success: true);
    }
  }

  @override
  Future<({Failure? failure, User? user})> getCurrentUser() async {
    try {
      final userDto = await _apiService.getCurrentUser();
      return (failure: null, user: userDto.toDomain());
    } catch (e) {
      return (failure: _mapExceptionToFailure(e), user: null);
    }
  }

  @override
  Future<({Failure? failure, User? user})> restoreSession() async {
    try {
      final accessToken = await _tokenStorage.getAccessToken();
      final refreshToken = await _tokenStorage.getRefreshToken();

      if (accessToken == null && refreshToken == null) {
        return (failure: null, user: null);
      }

      final userDto = await _apiService.getCurrentUser();
      return (failure: null, user: userDto.toDomain());
    } catch (e) {
      await _tokenStorage.clearTokens();
      return (failure: _mapExceptionToFailure(e), user: null);
    }
  }

  Failure _mapExceptionToFailure(Object exception) {
    if (exception is DioException && exception.error is AppException) {
      final appException = exception.error! as AppException;
      return _mapAppException(appException);
    } else if (exception is AppException) {
      return _mapAppException(exception);
    }

    return UnknownFailure(message: exception.toString());
  }

  Failure _mapAppException(AppException exception) {
    if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is AuthException) {
      return AuthFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is NetworkException) {
      return NetworkFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    }

    return ServerFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}
