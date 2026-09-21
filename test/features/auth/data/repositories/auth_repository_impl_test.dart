import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_assistant/core/errors/exceptions.dart';
import 'package:job_assistant/core/errors/failures.dart';
import 'package:job_assistant/core/storage/token_storage.dart';
import 'package:job_assistant/features/auth/data/models/login_request_dto.dart';
import 'package:job_assistant/features/auth/data/models/login_response_dto.dart';
import 'package:job_assistant/features/auth/data/models/register_request_dto.dart';
import 'package:job_assistant/features/auth/data/models/user_dto.dart';
import 'package:job_assistant/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:job_assistant/features/auth/data/services/auth_api_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthApiService extends Mock implements AuthApiService {}

class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late MockAuthApiService mockApiService;
  late MockTokenStorage mockTokenStorage;
  late AuthRepositoryImpl repository;

  const tUserDto = UserDto(
    id: '3fa85f64-5717-4562-b3fc-2c963f66afa6',
    email: 'user@example.com',
    isVerified: true,
    createdAt: '2026-09-08T12:00:00Z',
  );

  const tLoginResponseDto = LoginResponseDto(
    accessToken: 'access_token_abc',
    refreshToken: 'refresh_token_xyz',
    tokenType: 'bearer',
    expiresIn: 900,
  );

  const tEmail = 'user@example.com';
  const tPassword = 'Password123!';

  setUpAll(() {
    registerFallbackValue(const LoginRequestDto(email: tEmail, password: tPassword));
    registerFallbackValue(const RegisterRequestDto(email: tEmail, password: tPassword));
  });

  setUp(() {
    mockApiService = MockAuthApiService();
    mockTokenStorage = MockTokenStorage();
    repository = AuthRepositoryImpl(
      apiService: mockApiService,
      tokenStorage: mockTokenStorage,
    );
  });

  group('login', () {
    test('should save tokens and return domain User on successful login', () async {
      when(() => mockApiService.login(any())).thenAnswer((_) async => tLoginResponseDto);
      when(() => mockTokenStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async {});
      when(() => mockApiService.getCurrentUser()).thenAnswer((_) async => tUserDto);

      final result = await repository.login(email: tEmail, password: tPassword);

      expect(result.failure, isNull);
      expect(result.user?.id, equals(tUserDto.id));
      expect(result.user?.email, equals(tUserDto.email));
      expect(result.user?.isVerified, isTrue);

      verify(() => mockApiService.login(const LoginRequestDto(email: tEmail, password: tPassword))).called(1);
      verify(() => mockTokenStorage.saveTokens(
            accessToken: 'access_token_abc',
            refreshToken: 'refresh_token_xyz',
          )).called(1);
      verify(() => mockApiService.getCurrentUser()).called(1);
    });

    test('should return ServerFailure when 400 Bad Request occurs', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        error: const ServerException(
          message: 'Invalid payload format',
          code: 'BAD_REQUEST',
          statusCode: 400,
        ),
      );

      when(() => mockApiService.login(any())).thenThrow(dioException);

      final result = await repository.login(email: tEmail, password: tPassword);

      expect(result.user, isNull);
      expect(result.failure, isA<ServerFailure>());
      expect(result.failure?.code, equals('BAD_REQUEST'));
      expect(result.failure?.message, equals('Invalid payload format'));
    });

    test('should return AuthFailure when 401 Unauthorized occurs', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        error: const AuthException(
          message: 'Invalid credentials',
          code: 'UNAUTHENTICATED',
          statusCode: 401,
        ),
      );

      when(() => mockApiService.login(any())).thenThrow(dioException);

      final result = await repository.login(email: tEmail, password: tPassword);

      expect(result.user, isNull);
      expect(result.failure, isA<AuthFailure>());
      expect(result.failure?.code, equals('UNAUTHENTICATED'));
    });

    test('should return AuthFailure when 403 Forbidden occurs', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        error: const AuthException(
          message: 'Permission denied',
          code: 'PERMISSION_DENIED',
          statusCode: 403,
        ),
      );

      when(() => mockApiService.login(any())).thenThrow(dioException);

      final result = await repository.login(email: tEmail, password: tPassword);

      expect(result.user, isNull);
      expect(result.failure, isA<AuthFailure>());
      expect(result.failure?.code, equals('PERMISSION_DENIED'));
    });

    test('should return ServerFailure when 404 Not Found occurs', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        error: const ServerException(
          message: 'Endpoint not found',
          code: 'NOT_FOUND',
          statusCode: 404,
        ),
      );

      when(() => mockApiService.login(any())).thenThrow(dioException);

      final result = await repository.login(email: tEmail, password: tPassword);

      expect(result.user, isNull);
      expect(result.failure, isA<ServerFailure>());
      expect(result.failure?.code, equals('NOT_FOUND'));
    });

    test('should return ServerFailure when 409 Conflict occurs', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        error: const ServerException(
          message: 'Resource conflict',
          code: 'ALREADY_EXISTS',
          statusCode: 409,
        ),
      );

      when(() => mockApiService.login(any())).thenThrow(dioException);

      final result = await repository.login(email: tEmail, password: tPassword);

      expect(result.user, isNull);
      expect(result.failure, isA<ServerFailure>());
      expect(result.failure?.code, equals('ALREADY_EXISTS'));
    });

    test('should return ValidationFailure when 422 Unprocessable Entity occurs', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        error: const ValidationException(
          message: 'Validation failed',
          code: 'VALIDATION_ERROR',
          statusCode: 422,
          details: [
            {'loc': ['body', 'email'], 'msg': 'value is not a valid email'}
          ],
        ),
      );

      when(() => mockApiService.login(any())).thenThrow(dioException);

      final result = await repository.login(email: tEmail, password: tPassword);

      expect(result.user, isNull);
      expect(result.failure, isA<ValidationFailure>());
      expect(result.failure?.code, equals('VALIDATION_ERROR'));
      expect(result.failure?.details, isNotNull);
    });

    test('should return ServerFailure when 429 Too Many Requests occurs', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        error: const ServerException(
          message: 'Rate limit exceeded. Try again in 15 minutes.',
          code: 'ACCOUNT_LOCKED',
          statusCode: 429,
        ),
      );

      when(() => mockApiService.login(any())).thenThrow(dioException);

      final result = await repository.login(email: tEmail, password: tPassword);

      expect(result.user, isNull);
      expect(result.failure, isA<ServerFailure>());
      expect(result.failure?.code, equals('ACCOUNT_LOCKED'));
    });

    test('should return ServerFailure when 500 Internal Server Error occurs', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        error: const ServerException(
          message: 'Internal server error',
          code: 'INTERNAL_SERVER_ERROR',
          statusCode: 500,
        ),
      );

      when(() => mockApiService.login(any())).thenThrow(dioException);

      final result = await repository.login(email: tEmail, password: tPassword);

      expect(result.user, isNull);
      expect(result.failure, isA<ServerFailure>());
      expect(result.failure?.code, equals('INTERNAL_SERVER_ERROR'));
    });
  });

  group('restoreSession', () {
    test('should restore session if tokens exist and me endpoint succeeds', () async {
      when(() => mockTokenStorage.getAccessToken()).thenAnswer((_) async => 'valid_access_token');
      when(() => mockTokenStorage.getRefreshToken()).thenAnswer((_) async => 'valid_refresh_token');
      when(() => mockApiService.getCurrentUser()).thenAnswer((_) async => tUserDto);

      final result = await repository.restoreSession();

      expect(result.failure, isNull);
      expect(result.user?.id, equals(tUserDto.id));
    });

    test('should return null user if no stored tokens exist', () async {
      when(() => mockTokenStorage.getAccessToken()).thenAnswer((_) async => null);
      when(() => mockTokenStorage.getRefreshToken()).thenAnswer((_) async => null);

      final result = await repository.restoreSession();

      expect(result.failure, isNull);
      expect(result.user, isNull);
    });

    test('should clear tokens if getCurrentUser fails during restoration', () async {
      when(() => mockTokenStorage.getAccessToken()).thenAnswer((_) async => 'invalid_access_token');
      when(() => mockTokenStorage.getRefreshToken()).thenAnswer((_) async => 'invalid_refresh_token');
      when(() => mockApiService.getCurrentUser()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/me'),
          error: const AuthException(message: 'Token expired', code: 'UNAUTHENTICATED'),
        ),
      );
      when(() => mockTokenStorage.clearTokens()).thenAnswer((_) async {});

      final result = await repository.restoreSession();

      expect(result.user, isNull);
      verify(() => mockTokenStorage.clearTokens()).called(1);
    });
  });
}
