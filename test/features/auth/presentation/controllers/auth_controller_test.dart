import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_assistant/core/errors/failures.dart';
import 'package:job_assistant/features/auth/domain/entities/user.dart';
import 'package:job_assistant/features/auth/domain/repositories/auth_repository.dart';
import 'package:job_assistant/features/auth/presentation/controllers/auth_state.dart';
import 'package:job_assistant/features/auth/presentation/providers/auth_providers.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late ProviderContainer container;

  final tUser = User(
    id: 'user_123',
    email: 'user@example.com',
    isVerified: true,
    createdAt: DateTime.now(),
  );

  final tUnverifiedUser = User(
    id: 'user_456',
    email: 'unverified@example.com',
    isVerified: false,
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    when(() => mockRepository.restoreSession()).thenAnswer((_) async => (failure: null, user: null));

    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  test('initial state should restore session and transition to AuthStateUnauthenticated if no user', () async {
    final controller = container.read(authControllerProvider.notifier);
    await controller.restoreSession();

    final state = container.read(authControllerProvider);
    expect(state, isA<AuthStateUnauthenticated>());
  });

  test('login success should update state to AuthStateAuthenticated', () async {
    when(() => mockRepository.login(email: 'user@example.com', password: 'Password123!'))
        .thenAnswer((_) async => (failure: null, user: tUser));

    final controller = container.read(authControllerProvider.notifier);
    final success = await controller.login(email: 'user@example.com', password: 'Password123!');

    expect(success, isTrue);
    final state = container.read(authControllerProvider);
    expect(state, isA<AuthStateAuthenticated>());
    expect((state as AuthStateAuthenticated).user, equals(tUser));
  });

  test('login failure should update state to AuthStateError', () async {
    when(() => mockRepository.login(email: 'user@example.com', password: 'Password123!'))
        .thenAnswer((_) async => (
              failure: const AuthFailure(message: 'Invalid email or password', code: 'UNAUTHENTICATED'),
              user: null,
            ));

    final controller = container.read(authControllerProvider.notifier);
    final success = await controller.login(email: 'user@example.com', password: 'Password123!');

    expect(success, isFalse);
    final state = container.read(authControllerProvider);
    expect(state, isA<AuthStateError>());
    expect((state as AuthStateError).message, equals('Invalid email or password'));
  });

  test('register success with unverified email should transition to AuthStateNeedsVerification', () async {
    when(() => mockRepository.register(email: 'unverified@example.com', password: 'Password123!'))
        .thenAnswer((_) async => (failure: null, user: tUnverifiedUser));

    final controller = container.read(authControllerProvider.notifier);
    final success = await controller.register(email: 'unverified@example.com', password: 'Password123!');

    expect(success, isTrue);
    final state = container.read(authControllerProvider);
    expect(state, isA<AuthStateNeedsVerification>());
  });

  test('logout should transition state to AuthStateUnauthenticated', () async {
    when(() => mockRepository.logout()).thenAnswer((_) async => (failure: null, success: true));

    final controller = container.read(authControllerProvider.notifier);
    await controller.logout();

    final state = container.read(authControllerProvider);
    expect(state, isA<AuthStateUnauthenticated>());
  });
}
