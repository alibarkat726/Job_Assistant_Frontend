// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_error_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthErrorDetailDtoImpl _$$AuthErrorDetailDtoImplFromJson(
  Map<String, dynamic> json,
) => _$AuthErrorDetailDtoImpl(
  code: json['code'] as String,
  message: json['message'] as String,
  details: json['details'],
);

Map<String, dynamic> _$$AuthErrorDetailDtoImplToJson(
  _$AuthErrorDetailDtoImpl instance,
) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
  'details': instance.details,
};

_$AuthErrorDtoImpl _$$AuthErrorDtoImplFromJson(Map<String, dynamic> json) =>
    _$AuthErrorDtoImpl(
      error: AuthErrorDetailDto.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthErrorDtoImplToJson(_$AuthErrorDtoImpl instance) =>
    <String, dynamic>{'error': instance.error};
