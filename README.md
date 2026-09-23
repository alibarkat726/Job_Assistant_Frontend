# Job Assistant AI — Flutter Frontend

Production-grade, scalable Flutter application for the Job Assistant AI platform built with Riverpod, Clean Architecture, and Dio.

---

## 📄 CV Intake Feature Module Architecture

The CV Intake feature (`lib/features/cv/`) manages resume uploading, parsing, reviewing, draft updating, baseline finalizing, canonical viewing, raw binary downloading, and deletion.

```
lib/features/cv/
├── data/
│   ├── models/          # DTOs only — Freezed & json_serializable
│   │   ├── cv_upload_response_dto.dart
│   │   ├── cv_detail_dto.dart
│   │   ├── work_history_dto.dart
│   │   ├── education_entry_dto.dart
│   │   ├── cv_skill_dto.dart
│   │   └── cv_draft_update_request_dto.dart
│   ├── services/        # Raw Dio HTTP calls (multipart upload, PUT/POST/DELETE, binary stream)
│   │   └── cv_api_service.dart
│   └── repositories/    # DTO -> domain mapping, exception -> Failure mapping, key-shape & skill normalization
│       └── cv_repository_impl.dart
├── domain/
│   ├── entities/        # Domain entities (Cv, WorkHistory, EducationEntry, CvSkill)
│   │   ├── cv.dart
│   │   ├── work_history.dart
│   │   ├── education_entry.dart
│   │   └── cv_skill.dart
│   └── repositories/    # Abstract repository contract
│       └── cv_repository.dart
└── presentation/
    ├── controllers/     # Riverpod Notifier managing AsyncValue<Cv?>
    │   └── cv_controller.dart
    ├── providers/       # Riverpod provider definitions & dependency wiring
    │   └── cv_providers.dart
    ├── screens/         # UI screens (CvUploadScreen, CvReviewScreen, CvDetailScreen)
    │   ├── cv_upload_screen.dart
    │   ├── cv_review_screen.dart
    │   └── cv_detail_screen.dart
    └── widgets/         # Reusable CV components
        ├── file_picker_button.dart
        ├── parse_confidence_banner.dart
        ├── cv_section_card.dart
        ├── work_history_tile.dart
        ├── education_tile.dart
        └── skill_chip.dart
```

---

## 🔀 DTO Normalization Strategy

The backend API contract contains two schema inconsistencies between endpoints:

1. **Skills Format Normalization**:
   - `POST /api/v1/cvs/upload` returns plain string skills under `parsed_data.skills`: `["Python", "FastAPI"]`.
   - `GET /api/v1/cvs/me` returns object skills: `[{"id": "sk_1", "name": "Python", "category": "Backend"}]`.
   - **Repository Decision**: `CvRepositoryImpl` maps both string lists and object lists to a single domain `CvSkill` entity (`id`, `name`, `category`). The UI layer consumes `CvSkill` directly without checking source endpoint shapes.

2. **Key Name Normalization**:
   - `POST /api/v1/cvs/upload` uses singular keys `work_history` and `education` inside `parsed_data`.
   - `GET /api/v1/cvs/me` uses plural keys `work_histories` and `education_entries`.
   - **Repository Decision**: `CvRepositoryImpl` maps both key shapes to `List<WorkHistory>` and `List<EducationEntry>` in the domain model.

3. **Authoritative Parse Confidence**:
   - `parse_confidence` and `parsing_notes` exist at both the top-level response and nested inside `parsed_data` on upload. The top-level fields are selected as authoritative by `CvUploadResponseDto.toDomain()`.

4. **Draft Editability Scope**:
   - `PUT /api/v1/cvs/draft` payload accepts `{ full_name, summary, work_history }`. Fields supported by this contract (`fullName`, `summary`, `workHistories`) are editable in `CvReviewScreen`.
   - Fields not documented in the draft endpoint (`email`, `phone`, `location`, `educationEntries`, `skills`) are displayed read-only with explanatory badges to prevent silent drop of user edits.

---

## 🧪 Testing

Run all unit and widget tests with:
```bash
flutter test
```
- **`cv_repository_impl_test.dart`**: Unit tests for string-vs-object skills normalization, key mapping, 404 response handling, and failure mapping.
- **`cv_controller_test.dart`**: Unit tests for CV state machine (`uploading`, `draft`, `finalized`, `deleted`).
- **`cv_review_screen_test.dart`**: Widget tests for `ParseConfidenceBanner` rendering and draft submission.
