import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/work_history.dart';

part 'work_history_dto.freezed.dart';
part 'work_history_dto.g.dart';

@freezed
class WorkHistoryDto with _$WorkHistoryDto {
  const factory WorkHistoryDto({
    String? id,
    required String company,
    required String role,
    String? location,
    @JsonKey(name: 'start_date') String? startDate,
    @JsonKey(name: 'end_date') String? endDate,
    @JsonKey(name: 'is_current') @Default(false) bool isCurrent,
    String? description,
  }) = _WorkHistoryDto;

  factory WorkHistoryDto.fromJson(Map<String, dynamic> json) =>
      _$WorkHistoryDtoFromJson(json);
}

extension WorkHistoryDtoX on WorkHistoryDto {
  WorkHistory toDomain() {
    return WorkHistory(
      id: id,
      company: company,
      role: role,
      location: location,
      startDate: startDate,
      endDate: endDate,
      isCurrent: isCurrent,
      description: description,
    );
  }
}
