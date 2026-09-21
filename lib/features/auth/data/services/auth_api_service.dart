import '../../../../core/network/api_client.dart';
import '../models/login_request_dto.dart';
import '../models/login_response_dto.dart';
import '../models/refresh_request_dto.dart';
import '../models/register_request_dto.dart';
import '../models/user_dto.dart';

abstract class AuthApiService {
  Future<UserDto> register(RegisterRequestDto request);
  Future<LoginResponseDto> login(LoginRequestDto request);
  Future<LoginResponseDto> refreshToken(RefreshRequestDto request);
  Future<void> logout(RefreshRequestDto request);
  Future<UserDto> getCurrentUser();
}

class AuthApiServiceImpl implements AuthApiService {
  final ApiClient _apiClient;

  AuthApiServiceImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<UserDto> register(RegisterRequestDto request) async {
    final response = await _apiClient.dio.post(
      '/auth/register',
      data: request.toJson(),
    );
    return UserDto.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<LoginResponseDto> login(LoginRequestDto request) async {
    final response = await _apiClient.dio.post(
      '/auth/login',
      data: request.toJson(),
    );
    return LoginResponseDto.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<LoginResponseDto> refreshToken(RefreshRequestDto request) async {
    final response = await _apiClient.dio.post(
      '/auth/refresh',
      data: request.toJson(),
    );
    return LoginResponseDto.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> logout(RefreshRequestDto request) async {
    await _apiClient.dio.post(
      '/auth/logout',
      data: request.toJson(),
    );
  }

  @override
  Future<UserDto> getCurrentUser() async {
    final response = await _apiClient.dio.get('/auth/me');
    return UserDto.fromJson(response.data as Map<String, dynamic>);
  }
}
