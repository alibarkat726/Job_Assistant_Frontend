import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_assistant/features/cv/domain/entities/cv.dart';
import 'package:job_assistant/features/cv/domain/repositories/cv_repository.dart';
import 'package:job_assistant/features/cv/presentation/providers/cv_providers.dart';
import 'package:job_assistant/features/cv/presentation/screens/cv_review_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockCvRepository extends Mock implements CvRepository {}

void main() {
  late MockCvRepository mockRepository;

  const tLowConfidenceCv = Cv(
    id: 'cv_low_1',
    fullName: 'John Smith',
    summary: 'Parsed summary',
    parseConfidence: 0.45,
    parsingNotes: ['Work history start date unparseable'],
  );

  setUpAll(() {
    registerFallbackValue(tLowConfidenceCv);
  });

  setUp(() {
    mockRepository = MockCvRepository();
    when(() => mockRepository.getMyCv()).thenAnswer((_) async => (failure: null, cv: tLowConfidenceCv));
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        cvRepositoryProvider.overrideWithValue(mockRepository),
      ],
      child: const MaterialApp(
        home: CvReviewScreen(),
      ),
    );
  }

  testWidgets('renders low confidence banner and warning message', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Low Confidence Parse (45%)'), findsOneWidget);
    expect(find.text('Parsing Notes:'), findsOneWidget);
    expect(find.text('Work history start date unparseable'), findsOneWidget);
    expect(find.text('Please carefully review and correct the parsed fields below before finalizing your canonical CV.'), findsOneWidget);
  });

  testWidgets('renders editable form with parsed full name and summary', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextFormField, 'John Smith'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Parsed summary'), findsOneWidget);
  });

  testWidgets('saving draft triggers updateDraft on repository', (WidgetTester tester) async {
    when(() => mockRepository.updateDraft(any())).thenAnswer((_) async => (failure: null, cv: tLowConfidenceCv));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final saveDraftButton = find.widgetWithText(OutlinedButton, 'Save Draft');
    await tester.ensureVisible(saveDraftButton);
    await tester.tap(saveDraftButton);
    await tester.pumpAndSettle();

    verify(() => mockRepository.updateDraft(any())).called(1);
  });
}
