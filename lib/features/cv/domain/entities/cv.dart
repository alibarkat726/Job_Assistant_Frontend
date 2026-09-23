import 'package:equatable/equatable.dart';
import 'education_entry.dart';
import 'cv_skill.dart';
import 'work_history.dart';

class Cv extends Equatable {
  final String? id;
  final String? userId;
  final String? title;
  final String? variantName;
  final bool isCanonical;
  final String? rawFileName;
  final String? mimeType;
  final int? fileSize;
  final String fullName;
  final String? email;
  final String? phone;
  final String? location;
  final String? summary;
  final double parseConfidence;
  final List<String> parsingNotes;
  final List<WorkHistory> workHistories;
  final List<EducationEntry> educationEntries;
  final List<CvSkill> skills;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Cv({
    this.id,
    this.userId,
    this.title,
    this.variantName,
    this.isCanonical = false,
    this.rawFileName,
    this.mimeType,
    this.fileSize,
    required this.fullName,
    this.email,
    this.phone,
    this.location,
    this.summary,
    this.parseConfidence = 1.0,
    this.parsingNotes = const [],
    this.workHistories = const [],
    this.educationEntries = const [],
    this.skills = const [],
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        variantName,
        isCanonical,
        rawFileName,
        mimeType,
        fileSize,
        fullName,
        email,
        phone,
        location,
        summary,
        parseConfidence,
        parsingNotes,
        workHistories,
        educationEntries,
        skills,
        createdAt,
        updatedAt,
      ];

  Cv copyWith({
    String? id,
    String? userId,
    String? title,
    String? variantName,
    bool? isCanonical,
    String? rawFileName,
    String? mimeType,
    int? fileSize,
    String? fullName,
    String? email,
    String? phone,
    String? location,
    String? summary,
    double? parseConfidence,
    List<String>? parsingNotes,
    List<WorkHistory>? workHistories,
    List<EducationEntry>? educationEntries,
    List<CvSkill>? skills,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Cv(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      variantName: variantName ?? this.variantName,
      isCanonical: isCanonical ?? this.isCanonical,
      rawFileName: rawFileName ?? this.rawFileName,
      mimeType: mimeType ?? this.mimeType,
      fileSize: fileSize ?? this.fileSize,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      summary: summary ?? this.summary,
      parseConfidence: parseConfidence ?? this.parseConfidence,
      parsingNotes: parsingNotes ?? this.parsingNotes,
      workHistories: workHistories ?? this.workHistories,
      educationEntries: educationEntries ?? this.educationEntries,
      skills: skills ?? this.skills,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
