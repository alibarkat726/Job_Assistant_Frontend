import 'package:equatable/equatable.dart';

class WorkHistory extends Equatable {
  final String? id;
  final String company;
  final String role;
  final String? location;
  final String? startDate;
  final String? endDate;
  final bool isCurrent;
  final String? description;

  const WorkHistory({
    this.id,
    required this.company,
    required this.role,
    this.location,
    this.startDate,
    this.endDate,
    this.isCurrent = false,
    this.description,
  });

  @override
  List<Object?> get props => [
        id,
        company,
        role,
        location,
        startDate,
        endDate,
        isCurrent,
        description,
      ];
}
