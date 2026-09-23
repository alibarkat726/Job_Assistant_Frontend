import 'package:freezed_annotation/freezed_annotation.dart';

part 'cv_draft_update_request_dto.freezed.dart';
part 'cv_draft_update_request_dto.g.dart';

@freezed
class CvDraftWorkHistoryItemDto with _$CvDraftWorkHistoryItemDto {
  const factory CvDraftWorkHistoryItemDto({
    required String company,
    required String role,
    @JsonKey(name: 'is_current') @Default(false) bool isCurrent,
    String? description,
  }) = _CvDraftWorkHistoryItemDto;

  factory CvDraftWorkHistoryItemDto.fromJson(Map<String, dynamic> json) =>
      _$CvDraftWorkHistoryItemDtoFromJson(json);
}

@freezed
class CvDraftUpdateRequestDto with _$CvDraftUpdateRequestDto {
  const factory CvDraftUpdateRequestDto({
    @JsonKey(name: 'full_name') required String fullName,
    String? summary,
    @JsonKey(name: 'work_history')
    @Default([])
    List<CvDraftWorkHistoryItemDto> workHistory,
  }) = _CvDraftUpdateRequestDto;

  factory CvDraftUpdateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CvDraftUpdateRequestDtoFromJson(json);
}
