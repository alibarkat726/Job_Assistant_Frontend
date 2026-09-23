import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/cv_skill.dart';

part 'cv_skill_dto.freezed.dart';
part 'cv_skill_dto.g.dart';

@freezed
class CvSkillDto with _$CvSkillDto {
  const factory CvSkillDto({
    String? id,
    required String name,
    String? category,
  }) = _CvSkillDto;

  factory CvSkillDto.fromJson(Map<String, dynamic> json) =>
      _$CvSkillDtoFromJson(json);
}

extension CvSkillDtoX on CvSkillDto {
  CvSkill toDomain() {
    return CvSkill(
      id: id,
      name: name,
      category: category,
    );
  }
}
