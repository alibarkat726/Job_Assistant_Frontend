import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<({Failure? failure, User? user})> register({
    required String email,
    required String password,
  });

  Future<({Failure? failure, User? user})> login({
    required String email,
    required String password,
  });

  Future<({Failure? failure, bool success})> logout();

  Future<({Failure? failure, User? user})> getCurrentUser();

  Future<({Failure? failure, User? user})> restoreSession();
}
