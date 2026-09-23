import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/cv.dart';
import '../../domain/entities/cv_skill.dart';

import 'education_entry_dto.dart';
import 'work_history_dto.dart';

part 'cv_upload_response_dto.freezed.dart';
part 'cv_upload_response_dto.g.dart';

@freezed
class CvContactInfoDto with _$CvContactInfoDto {
  const factory CvContactInfoDto({
    @JsonKey(name: 'full_name') String? fullName,
    String? email,
    String? phone,
    String? location,
    String? summary,
  }) = _CvContactInfoDto;

  factory CvContactInfoDto.fromJson(Map<String, dynamic> json) =>
      _$CvContactInfoDtoFromJson(json);
}

@freezed
class CvUploadParsedDataDto with _$CvUploadParsedDataDto {
  const factory CvUploadParsedDataDto({
    @JsonKey(name: 'contact_info') CvContactInfoDto? contactInfo,
    @JsonKey(name: 'work_history') @Default([]) List<WorkHistoryDto> workHistory,
    @Default([]) List<EducationEntryDto> education,
    @Default([]) List<String> skills,
    @JsonKey(name: 'parse_confidence') double? parseConfidence,
    @JsonKey(name: 'parsing_notes') @Default([]) List<String> parsingNotes,
  }) = _CvUploadParsedDataDto;

  factory CvUploadParsedDataDto.fromJson(Map<String, dynamic> json) =>
      _$CvUploadParsedDataDtoFromJson(json);
}

@freezed
class CvUploadResponseDto with _$CvUploadResponseDto {
  const factory CvUploadResponseDto({
    @JsonKey(name: 'cv_id') String? cvId,
    String? message,
    @JsonKey(name: 'is_canonical') @Default(false) bool isCanonical,
    @JsonKey(name: 'parse_confidence') @Default(1.0) double parseConfidence,
    @JsonKey(name: 'parsing_notes') @Default([]) List<String> parsingNotes,
    @JsonKey(name: 'parsed_data') required CvUploadParsedDataDto parsedData,
  }) = _CvUploadResponseDto;

  factory CvUploadResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CvUploadResponseDtoFromJson(json);
}

extension CvUploadResponseDtoX on CvUploadResponseDto {
  Cv toDomain() {
    final contact = parsedData.contactInfo;
    return Cv(
      id: cvId,
      isCanonical: isCanonical,
      fullName: contact?.fullName ?? 'Unnamed CV',
      email: contact?.email,
      phone: contact?.phone,
      location: contact?.location,
      summary: contact?.summary,
      parseConfidence: parseConfidence, // Top-level parseConfidence is authoritative
      parsingNotes: parsingNotes.isNotEmpty ? parsingNotes : parsedData.parsingNotes,
      workHistories: parsedData.workHistory.map((e) => e.toDomain()).toList(),
      educationEntries: parsedData.education.map((e) => e.toDomain()).toList(),
      // Normalize List<String> skills into List<CvSkill>
      skills: parsedData.skills
          .map((s) => CvSkill(id: null, name: s, category: null))
          .toList(),
    );
  }
}
