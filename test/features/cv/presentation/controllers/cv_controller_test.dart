import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_assistant/core/utils/app_picked_file.dart';
import 'package:job_assistant/features/cv/domain/entities/cv.dart';
import 'package:job_assistant/features/cv/domain/entities/work_history.dart';
import 'package:job_assistant/features/cv/domain/repositories/cv_repository.dart';
import 'package:job_assistant/features/cv/presentation/providers/cv_providers.dart';
import 'package:mocktail/mocktail.dart';

class MockCvRepository extends Mock implements CvRepository {}

class FakeAppPickedFile extends Fake implements AppPickedFile {}

void main() {
  late MockCvRepository mockRepository;
  late ProviderContainer container;

  const tDraftCv = Cv(
    id: 'cv_123',
    fullName: 'Jane Doe',
    summary: 'Software Engineer',
    isCanonical: false,
    parseConfidence: 0.85,
    workHistories: [
      WorkHistory(company: 'Tech Corp', role: 'Engineer', isCurrent: true),
    ],
  );

  const tFinalizedCv = Cv(
    id: 'cv_123',
    fullName: 'Jane Doe',
    summary: 'Software Engineer',
    isCanonical: true,
    parseConfidence: 0.85,
  );

  setUpAll(() {
    registerFallbackValue(FakeAppPickedFile());
    registerFallbackValue(tDraftCv);
  });

  setUp(() {
    mockRepository = MockCvRepository();
    when(() => mockRepository.getMyCv()).thenAnswer((_) async => (failure: null, cv: tDraftCv));

    container = ProviderContainer(
      overrides: [
        cvRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  test('build should load existing CV into AsyncData', () async {
    final controller = container.read(cvControllerProvider.notifier);
    await controller.loadCv();

    final state = container.read(cvControllerProvider);
    expect(state.value, equals(tDraftCv));
  });

  test('uploadCv success should update state to AsyncData with parsed CV', () async {
    const mockFile = AppPickedFile(name: 'dummy.pdf', bytes: [1, 2, 3], size: 3);
    when(() => mockRepository.uploadCv(any(), onSendProgress: any(named: 'onSendProgress')))
        .thenAnswer((_) async => (failure: null, cv: tDraftCv));

    final controller = container.read(cvControllerProvider.notifier);
    final result = await controller.uploadCv(mockFile);

    expect(result.success, isTrue);
    expect(result.cv, equals(tDraftCv));
    expect(container.read(cvControllerProvider).value, equals(tDraftCv));
  });

  test('finalizeCv success should update state to canonical CV', () async {
    when(() => mockRepository.finalizeCv()).thenAnswer((_) async => (failure: null, cv: tFinalizedCv));

    final controller = container.read(cvControllerProvider.notifier);
    final result = await controller.finalizeCv();

    expect(result.success, isTrue);
    expect(result.cv?.isCanonical, isTrue);
    expect(container.read(cvControllerProvider).value?.isCanonical, isTrue);
  });

  test('deleteCv success should reset state to AsyncData(null)', () async {
    when(() => mockRepository.deleteCv()).thenAnswer((_) async => (failure: null, success: true));

    final controller = container.read(cvControllerProvider.notifier);
    final result = await controller.deleteCv();

    expect(result.success, isTrue);
    expect(container.read(cvControllerProvider).value, isNull);
  });
}
