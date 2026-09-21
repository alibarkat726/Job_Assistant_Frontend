import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import '../providers/auth_providers.dart';
import 'auth_state.dart';

class AuthController extends Notifier<AuthState> {
  late final AuthRepository _repository;

  @override
  AuthState build() {
    _repository = ref.watch(authRepositoryProvider);
    // Trigger session restoration on startup asynchronously
    Future.microtask(() => restoreSession());
    return const AuthStateInitial();
  }

  Future<void> restoreSession() async {
    final result = await _repository.restoreSession();
    if (result.user != null) {
      if (result.user!.isVerified) {
        state = AuthStateAuthenticated(result.user!);
      } else {
        state = AuthStateNeedsVerification(result.user!);
      }
    } else {
      state = const AuthStateUnauthenticated();
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = const AuthStateAuthenticating();
    final result = await _repository.login(email: email, password: password);

    if (result.user != null) {
      if (result.user!.isVerified) {
        state = AuthStateAuthenticated(result.user!);
      } else {
        state = AuthStateNeedsVerification(result.user!);
      }
      return true;
    } else {
      final failure = result.failure;
      state = AuthStateError(
        message: failure?.message ?? 'Login failed. Please try again.',
        code: failure?.code,
        details: failure?.details,
      );
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
  }) async {
    state = const AuthStateAuthenticating();
    final result = await _repository.register(email: email, password: password);

    if (result.user != null) {
      if (!result.user!.isVerified) {
        state = AuthStateNeedsVerification(result.user!);
      } else {
        state = AuthStateAuthenticated(result.user!);
      }
      return true;
    } else {
      final failure = result.failure;
      state = AuthStateError(
        message: failure?.message ?? 'Registration failed. Please try again.',
        code: failure?.code,
        details: failure?.details,
      );
      return false;
    }
  }

  Future<void> logout() async {
    state = const AuthStateAuthenticating();
    await _repository.logout();
    state = const AuthStateUnauthenticated();
  }

  void handleSessionExpired() {
    state = const AuthStateUnauthenticated(
      errorMessage: 'Session expired. Please log in again.',
    );
  }
}
