// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'refresh_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RefreshRequestDto _$RefreshRequestDtoFromJson(Map<String, dynamic> json) {
  return _RefreshRequestDto.fromJson(json);
}

/// @nodoc
mixin _$RefreshRequestDto {
  @JsonKey(name: 'refresh_token')
  String get refreshToken => throw _privateConstructorUsedError;

  /// Serializes this RefreshRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RefreshRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RefreshRequestDtoCopyWith<RefreshRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefreshRequestDtoCopyWith<$Res> {
  factory $RefreshRequestDtoCopyWith(
    RefreshRequestDto value,
    $Res Function(RefreshRequestDto) then,
  ) = _$RefreshRequestDtoCopyWithImpl<$Res, RefreshRequestDto>;
  @useResult
  $Res call({@JsonKey(name: 'refresh_token') String refreshToken});
}

/// @nodoc
class _$RefreshRequestDtoCopyWithImpl<$Res, $Val extends RefreshRequestDto>
    implements $RefreshRequestDtoCopyWith<$Res> {
  _$RefreshRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RefreshRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? refreshToken = null}) {
    return _then(
      _value.copyWith(
            refreshToken: null == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RefreshRequestDtoImplCopyWith<$Res>
    implements $RefreshRequestDtoCopyWith<$Res> {
  factory _$$RefreshRequestDtoImplCopyWith(
    _$RefreshRequestDtoImpl value,
    $Res Function(_$RefreshRequestDtoImpl) then,
  ) = __$$RefreshRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'refresh_token') String refreshToken});
}

/// @nodoc
class __$$RefreshRequestDtoImplCopyWithImpl<$Res>
    extends _$RefreshRequestDtoCopyWithImpl<$Res, _$RefreshRequestDtoImpl>
    implements _$$RefreshRequestDtoImplCopyWith<$Res> {
  __$$RefreshRequestDtoImplCopyWithImpl(
    _$RefreshRequestDtoImpl _value,
    $Res Function(_$RefreshRequestDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RefreshRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? refreshToken = null}) {
    return _then(
      _$RefreshRequestDtoImpl(
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RefreshRequestDtoImpl implements _RefreshRequestDto {
  const _$RefreshRequestDtoImpl({
    @JsonKey(name: 'refresh_token') required this.refreshToken,
  });

  factory _$RefreshRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefreshRequestDtoImplFromJson(json);

  @override
  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  @override
  String toString() {
    return 'RefreshRequestDto(refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshRequestDtoImpl &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, refreshToken);

  /// Create a copy of RefreshRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefreshRequestDtoImplCopyWith<_$RefreshRequestDtoImpl> get copyWith =>
      __$$RefreshRequestDtoImplCopyWithImpl<_$RefreshRequestDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RefreshRequestDtoImplToJson(this);
  }
}

abstract class _RefreshRequestDto implements RefreshRequestDto {
  const factory _RefreshRequestDto({
    @JsonKey(name: 'refresh_token') required final String refreshToken,
  }) = _$RefreshRequestDtoImpl;

  factory _RefreshRequestDto.fromJson(Map<String, dynamic> json) =
      _$RefreshRequestDtoImpl.fromJson;

  @override
  @JsonKey(name: 'refresh_token')
  String get refreshToken;

  /// Create a copy of RefreshRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefreshRequestDtoImplCopyWith<_$RefreshRequestDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
