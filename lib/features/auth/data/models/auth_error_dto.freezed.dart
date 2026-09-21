// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_error_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthErrorDetailDto _$AuthErrorDetailDtoFromJson(Map<String, dynamic> json) {
  return _AuthErrorDetailDto.fromJson(json);
}

/// @nodoc
mixin _$AuthErrorDetailDto {
  String get code => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  dynamic get details => throw _privateConstructorUsedError;

  /// Serializes this AuthErrorDetailDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthErrorDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthErrorDetailDtoCopyWith<AuthErrorDetailDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthErrorDetailDtoCopyWith<$Res> {
  factory $AuthErrorDetailDtoCopyWith(
    AuthErrorDetailDto value,
    $Res Function(AuthErrorDetailDto) then,
  ) = _$AuthErrorDetailDtoCopyWithImpl<$Res, AuthErrorDetailDto>;
  @useResult
  $Res call({String code, String message, dynamic details});
}

/// @nodoc
class _$AuthErrorDetailDtoCopyWithImpl<$Res, $Val extends AuthErrorDetailDto>
    implements $AuthErrorDetailDtoCopyWith<$Res> {
  _$AuthErrorDetailDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthErrorDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
    Object? details = freezed,
  }) {
    return _then(
      _value.copyWith(
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            details: freezed == details
                ? _value.details
                : details // ignore: cast_nullable_to_non_nullable
                      as dynamic,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthErrorDetailDtoImplCopyWith<$Res>
    implements $AuthErrorDetailDtoCopyWith<$Res> {
  factory _$$AuthErrorDetailDtoImplCopyWith(
    _$AuthErrorDetailDtoImpl value,
    $Res Function(_$AuthErrorDetailDtoImpl) then,
  ) = __$$AuthErrorDetailDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String code, String message, dynamic details});
}

/// @nodoc
class __$$AuthErrorDetailDtoImplCopyWithImpl<$Res>
    extends _$AuthErrorDetailDtoCopyWithImpl<$Res, _$AuthErrorDetailDtoImpl>
    implements _$$AuthErrorDetailDtoImplCopyWith<$Res> {
  __$$AuthErrorDetailDtoImplCopyWithImpl(
    _$AuthErrorDetailDtoImpl _value,
    $Res Function(_$AuthErrorDetailDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthErrorDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
    Object? details = freezed,
  }) {
    return _then(
      _$AuthErrorDetailDtoImpl(
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        details: freezed == details
            ? _value.details
            : details // ignore: cast_nullable_to_non_nullable
                  as dynamic,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthErrorDetailDtoImpl implements _AuthErrorDetailDto {
  const _$AuthErrorDetailDtoImpl({
    required this.code,
    required this.message,
    this.details,
  });

  factory _$AuthErrorDetailDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthErrorDetailDtoImplFromJson(json);

  @override
  final String code;
  @override
  final String message;
  @override
  final dynamic details;

  @override
  String toString() {
    return 'AuthErrorDetailDto(code: $code, message: $message, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthErrorDetailDtoImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.details, details));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    code,
    message,
    const DeepCollectionEquality().hash(details),
  );

  /// Create a copy of AuthErrorDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthErrorDetailDtoImplCopyWith<_$AuthErrorDetailDtoImpl> get copyWith =>
      __$$AuthErrorDetailDtoImplCopyWithImpl<_$AuthErrorDetailDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthErrorDetailDtoImplToJson(this);
  }
}

abstract class _AuthErrorDetailDto implements AuthErrorDetailDto {
  const factory _AuthErrorDetailDto({
    required final String code,
    required final String message,
    final dynamic details,
  }) = _$AuthErrorDetailDtoImpl;

  factory _AuthErrorDetailDto.fromJson(Map<String, dynamic> json) =
      _$AuthErrorDetailDtoImpl.fromJson;

  @override
  String get code;
  @override
  String get message;
  @override
  dynamic get details;

  /// Create a copy of AuthErrorDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthErrorDetailDtoImplCopyWith<_$AuthErrorDetailDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AuthErrorDto _$AuthErrorDtoFromJson(Map<String, dynamic> json) {
  return _AuthErrorDto.fromJson(json);
}

/// @nodoc
mixin _$AuthErrorDto {
  AuthErrorDetailDto get error => throw _privateConstructorUsedError;

  /// Serializes this AuthErrorDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthErrorDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthErrorDtoCopyWith<AuthErrorDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthErrorDtoCopyWith<$Res> {
  factory $AuthErrorDtoCopyWith(
    AuthErrorDto value,
    $Res Function(AuthErrorDto) then,
  ) = _$AuthErrorDtoCopyWithImpl<$Res, AuthErrorDto>;
  @useResult
  $Res call({AuthErrorDetailDto error});

  $AuthErrorDetailDtoCopyWith<$Res> get error;
}

/// @nodoc
class _$AuthErrorDtoCopyWithImpl<$Res, $Val extends AuthErrorDto>
    implements $AuthErrorDtoCopyWith<$Res> {
  _$AuthErrorDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthErrorDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null}) {
    return _then(
      _value.copyWith(
            error: null == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as AuthErrorDetailDto,
          )
          as $Val,
    );
  }

  /// Create a copy of AuthErrorDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthErrorDetailDtoCopyWith<$Res> get error {
    return $AuthErrorDetailDtoCopyWith<$Res>(_value.error, (value) {
      return _then(_value.copyWith(error: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthErrorDtoImplCopyWith<$Res>
    implements $AuthErrorDtoCopyWith<$Res> {
  factory _$$AuthErrorDtoImplCopyWith(
    _$AuthErrorDtoImpl value,
    $Res Function(_$AuthErrorDtoImpl) then,
  ) = __$$AuthErrorDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AuthErrorDetailDto error});

  @override
  $AuthErrorDetailDtoCopyWith<$Res> get error;
}

/// @nodoc
class __$$AuthErrorDtoImplCopyWithImpl<$Res>
    extends _$AuthErrorDtoCopyWithImpl<$Res, _$AuthErrorDtoImpl>
    implements _$$AuthErrorDtoImplCopyWith<$Res> {
  __$$AuthErrorDtoImplCopyWithImpl(
    _$AuthErrorDtoImpl _value,
    $Res Function(_$AuthErrorDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthErrorDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null}) {
    return _then(
      _$AuthErrorDtoImpl(
        error: null == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as AuthErrorDetailDto,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthErrorDtoImpl implements _AuthErrorDto {
  const _$AuthErrorDtoImpl({required this.error});

  factory _$AuthErrorDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthErrorDtoImplFromJson(json);

  @override
  final AuthErrorDetailDto error;

  @override
  String toString() {
    return 'AuthErrorDto(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthErrorDtoImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of AuthErrorDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthErrorDtoImplCopyWith<_$AuthErrorDtoImpl> get copyWith =>
      __$$AuthErrorDtoImplCopyWithImpl<_$AuthErrorDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthErrorDtoImplToJson(this);
  }
}

abstract class _AuthErrorDto implements AuthErrorDto {
  const factory _AuthErrorDto({required final AuthErrorDetailDto error}) =
      _$AuthErrorDtoImpl;

  factory _AuthErrorDto.fromJson(Map<String, dynamic> json) =
      _$AuthErrorDtoImpl.fromJson;

  @override
  AuthErrorDetailDto get error;

  /// Create a copy of AuthErrorDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthErrorDtoImplCopyWith<_$AuthErrorDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
