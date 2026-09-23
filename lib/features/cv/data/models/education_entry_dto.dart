import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/education_entry.dart';

part 'education_entry_dto.freezed.dart';
part 'education_entry_dto.g.dart';

@freezed
class EducationEntryDto with _$EducationEntryDto {
  const factory EducationEntryDto({
    String? id,
    required String institution,
    String? degree,
    @JsonKey(name: 'field_of_study') String? fieldOfStudy,
    @JsonKey(name: 'start_date') String? startDate,
    @JsonKey(name: 'end_date') String? endDate,
  }) = _EducationEntryDto;

  factory EducationEntryDto.fromJson(Map<String, dynamic> json) =>
      _$EducationEntryDtoFromJson(json);
}

extension EducationEntryDtoX on EducationEntryDto {
  EducationEntry toDomain() {
    return EducationEntry(
      id: id,
      institution: institution,
      degree: degree,
      fieldOfStudy: fieldOfStudy,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
