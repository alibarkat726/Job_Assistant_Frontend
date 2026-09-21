import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final bool isVerified;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.isVerified,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, isVerified, createdAt];
}
