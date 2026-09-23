import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_assistant/core/errors/exceptions.dart';
import 'package:job_assistant/core/utils/app_picked_file.dart';
import 'package:job_assistant/features/cv/data/models/cv_detail_dto.dart';
import 'package:job_assistant/features/cv/data/models/cv_skill_dto.dart';
import 'package:job_assistant/features/cv/data/models/cv_upload_response_dto.dart';
import 'package:job_assistant/features/cv/data/models/education_entry_dto.dart';
import 'package:job_assistant/features/cv/data/models/work_history_dto.dart';
import 'package:job_assistant/features/cv/data/repositories/cv_repository_impl.dart';
import 'package:job_assistant/features/cv/data/services/cv_api_service.dart';
import 'package:mocktail/mocktail.dart';

class MockCvApiService extends Mock implements CvApiService {}

void main() {
  late MockCvApiService mockApiService;
  late CvRepositoryImpl repository;

  final tUploadResponseDto = CvUploadResponseDto(
    cvId: 'cv_upload_123',
    message: 'CV parsed successfully',
    isCanonical: false,
    parseConfidence: 0.85,
    parsingNotes: const ['Check work history dates'],
    parsedData: const CvUploadParsedDataDto(
      contactInfo: CvContactInfoDto(
        fullName: 'Jane Doe',
        email: 'jane@example.com',
        phone: '+123456789',
        location: 'San Francisco, CA',
        summary: 'Experienced Software Engineer',
      ),
      workHistory: [
        WorkHistoryDto(
          id: 'wh_1',
          company: 'Tech Corp',
          role: 'Senior Engineer',
          startDate: '2020-01',
          endDate: null,
          isCurrent: true,
          description: 'Built scalable APIs',
        ),
      ],
      education: [
        EducationEntryDto(
          id: 'edu_1',
          institution: 'Stanford University',
          degree: 'B.S.',
          fieldOfStudy: 'Computer Science',
        ),
      ],
      skills: ['Python', 'FastAPI', 'Flutter'],
    ),
  );

  const tCvDetailDto = CvDetailDto(
    id: 'cv_detail_456',
    userId: 'user_789',
    title: 'Jane Doe CV',
    isCanonical: true,
    fullName: 'Jane Doe',
    email: 'jane@example.com',
    phone: '+123456789',
    location: 'San Francisco, CA',
    summary: 'Experienced Software Engineer',
    parseConfidence: 0.95,
    workHistories: [
      WorkHistoryDto(
        id: 'wh_1',
        company: 'Tech Corp',
        role: 'Senior Engineer',
        startDate: '2020-01',
        endDate: null,
        isCurrent: true,
        description: 'Built scalable APIs',
      ),
    ],
    educationEntries: [
      EducationEntryDto(
        id: 'edu_1',
        institution: 'Stanford University',
        degree: 'B.S.',
        fieldOfStudy: 'Computer Science',
      ),
    ],
    skills: [
      CvSkillDto(id: 'sk_1', name: 'Python', category: 'Backend'),
      CvSkillDto(id: 'sk_2', name: 'FastAPI', category: 'Framework'),
    ],
  );

  setUp(() {
    mockApiService = MockCvApiService();
    repository = CvRepositoryImpl(apiService: mockApiService);
  });

  group('CvRepositoryImpl DTO Normalization', () {
    test('uploadCv should normalize string skills and singular keys into domain Cv entity', () async {
      const mockFile = AppPickedFile(
        name: 'dummy_cv.pdf',
        bytes: [1, 2, 3, 4],
        size: 4,
      );

      when(() => mockApiService.uploadCv(any(), any(), onSendProgress: any(named: 'onSendProgress')))
          .thenAnswer((_) async => tUploadResponseDto);

      final result = await repository.uploadCv(mockFile);

      expect(result.failure, isNull);
      expect(result.cv, isNotNull);
      final cv = result.cv!;

      expect(cv.id, equals('cv_upload_123'));
      expect(cv.fullName, equals('Jane Doe'));
      expect(cv.parseConfidence, equals(0.85));

      expect(cv.workHistories.length, equals(1));
      expect(cv.workHistories.first.company, equals('Tech Corp'));
      expect(cv.workHistories.first.isCurrent, isTrue);

      expect(cv.educationEntries.length, equals(1));
      expect(cv.educationEntries.first.institution, equals('Stanford University'));

      expect(cv.skills.length, equals(3));
      expect(cv.skills[0].name, equals('Python'));
      expect(cv.skills[0].id, isNull);
      expect(cv.skills[1].name, equals('FastAPI'));
      expect(cv.skills[2].name, equals('Flutter'));
    });

    test('getMyCv should normalize object skills and plural keys into domain Cv entity', () async {
      when(() => mockApiService.getMyCv()).thenAnswer((_) async => tCvDetailDto);

      final result = await repository.getMyCv();

      expect(result.failure, isNull);
      expect(result.cv, isNotNull);
      final cv = result.cv!;

      expect(cv.id, equals('cv_detail_456'));
      expect(cv.isCanonical, isTrue);

      expect(cv.workHistories.length, equals(1));
      expect(cv.workHistories.first.company, equals('Tech Corp'));

      expect(cv.educationEntries.length, equals(1));
      expect(cv.educationEntries.first.institution, equals('Stanford University'));

      expect(cv.skills.length, equals(2));
      expect(cv.skills[0].id, equals('sk_1'));
      expect(cv.skills[0].name, equals('Python'));
      expect(cv.skills[0].category, equals('Backend'));
    });

    test('getMyCv should return null cv when backend returns 404 NOT_FOUND', () async {
      when(() => mockApiService.getMyCv()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/cvs/me'),
          error: const ServerException(message: 'No CV found', code: 'NOT_FOUND', statusCode: 404),
        ),
      );

      final result = await repository.getMyCv();

      expect(result.failure, isNull);
      expect(result.cv, isNull);
    });
  });
}
