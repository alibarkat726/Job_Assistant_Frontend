import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

class AuthStateUnauthenticated extends AuthState {
  final String? errorMessage;
  const AuthStateUnauthenticated({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class AuthStateAuthenticating extends AuthState {
  const AuthStateAuthenticating();
}

class AuthStateAuthenticated extends AuthState {
  final User user;
  const AuthStateAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthStateNeedsVerification extends AuthState {
  final User user;
  const AuthStateNeedsVerification(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthStateError extends AuthState {
  final String message;
  final String? code;
  final dynamic details;

  const AuthStateError({
    required this.message,
    this.code,
    this.details,
  });

  @override
  List<Object?> get props => [message, code, details];
}
