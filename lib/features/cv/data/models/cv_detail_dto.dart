import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/cv.dart';

import 'cv_skill_dto.dart';
import 'education_entry_dto.dart';
import 'work_history_dto.dart';

part 'cv_detail_dto.freezed.dart';
part 'cv_detail_dto.g.dart';

@freezed
class CvDetailDto with _$CvDetailDto {
  const factory CvDetailDto({
    required String id,
    @JsonKey(name: 'user_id') String? userId,
    String? title,
    @JsonKey(name: 'variant_name') String? variantName,
    @JsonKey(name: 'is_canonical') @Default(false) bool isCanonical,
    @JsonKey(name: 'raw_file_name') String? rawFileName,
    @JsonKey(name: 'mime_type') String? mimeType,
    @JsonKey(name: 'file_size') int? fileSize,
    @JsonKey(name: 'full_name') required String fullName,
    String? email,
    String? phone,
    String? location,
    String? summary,
    @JsonKey(name: 'parse_confidence') @Default(1.0) double parseConfidence,
    @JsonKey(name: 'parsing_notes') @Default([]) List<String> parsingNotes,
    @JsonKey(name: 'work_histories') @Default([]) List<WorkHistoryDto> workHistories,
    @JsonKey(name: 'education_entries') @Default([]) List<EducationEntryDto> educationEntries,
    @Default([]) List<CvSkillDto> skills,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _CvDetailDto;

  factory CvDetailDto.fromJson(Map<String, dynamic> json) =>
      _$CvDetailDtoFromJson(json);
}

extension CvDetailDtoX on CvDetailDto {
  Cv toDomain() {
    return Cv(
      id: id,
      userId: userId,
      title: title,
      variantName: variantName,
      isCanonical: isCanonical,
      rawFileName: rawFileName,
      mimeType: mimeType,
      fileSize: fileSize,
      fullName: fullName,
      email: email,
      phone: phone,
      location: location,
      summary: summary,
      parseConfidence: parseConfidence,
      parsingNotes: parsingNotes,
      workHistories: workHistories.map((e) => e.toDomain()).toList(),
      educationEntries: educationEntries.map((e) => e.toDomain()).toList(),
      skills: skills.map((e) => e.toDomain()).toList(),
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }
}
