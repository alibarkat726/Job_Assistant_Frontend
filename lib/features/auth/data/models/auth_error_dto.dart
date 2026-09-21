import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_error_dto.freezed.dart';
part 'auth_error_dto.g.dart';

@freezed
class AuthErrorDetailDto with _$AuthErrorDetailDto {
  const factory AuthErrorDetailDto({
    required String code,
    required String message,
    dynamic details,
  }) = _AuthErrorDetailDto;

  factory AuthErrorDetailDto.fromJson(Map<String, dynamic> json) => _$AuthErrorDetailDtoFromJson(json);
}

@freezed
class AuthErrorDto with _$AuthErrorDto {
  const factory AuthErrorDto({
    required AuthErrorDetailDto error,
  }) = _AuthErrorDto;

  factory AuthErrorDto.fromJson(Map<String, dynamic> json) => _$AuthErrorDtoFromJson(json);
}
