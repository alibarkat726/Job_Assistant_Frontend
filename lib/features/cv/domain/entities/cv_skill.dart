import 'package:equatable/equatable.dart';

class CvSkill extends Equatable {
  final String? id;
  final String name;
  final String? category;

  const CvSkill({
    this.id,
    required this.name,
    this.category,
  });

  @override
  List<Object?> get props => [id, name, category];
}
