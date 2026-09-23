import 'package:equatable/equatable.dart';

class EducationEntry extends Equatable {
  final String? id;
  final String institution;
  final String? degree;
  final String? fieldOfStudy;
  final String? startDate;
  final String? endDate;

  const EducationEntry({
    this.id,
    required this.institution,
    this.degree,
    this.fieldOfStudy,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
        id,
        institution,
        degree,
        fieldOfStudy,
        startDate,
        endDate,
      ];
}
