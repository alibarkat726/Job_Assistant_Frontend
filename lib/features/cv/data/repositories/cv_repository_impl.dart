import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_picked_file.dart';
import '../../domain/entities/cv.dart';
import '../../domain/repositories/cv_repository.dart';
import '../models/cv_draft_update_request_dto.dart';
import '../models/cv_upload_response_dto.dart';
import '../models/cv_detail_dto.dart';
import '../services/cv_api_service.dart';

class CvRepositoryImpl implements CvRepository {
  final CvApiService _apiService;

  CvRepositoryImpl({required CvApiService apiService}) : _apiService = apiService;

  @override
  Future<({Failure? failure, Cv? cv})> uploadCv(
    AppPickedFile file, {
    void Function(int count, int total)? onSendProgress,
  }) async {
    try {
      if (file.size > 10 * 1024 * 1024) {
        return (
          failure: const ValidationFailure(
            message: 'File size exceeds 10MB limit. Please choose a smaller file.',
            code: 'FILE_TOO_LARGE',
          ),
          cv: null,
        );
      }

      final responseDto = await _apiService.uploadCv(
        file.bytes,
        file.name,
        onSendProgress: onSendProgress,
      );

      return (failure: null, cv: responseDto.toDomain());
    } catch (e) {
      return (failure: _mapExceptionToFailure(e), cv: null);
    }
  }

  @override
  Future<({Failure? failure, Cv? cv})> getMyCv() async {
    try {
      final detailDto = await _apiService.getMyCv();
      return (failure: null, cv: detailDto.toDomain());
    } catch (e) {
      final failure = _mapExceptionToFailure(e);
      if (failure.code == 'NOT_FOUND' ||
          (e is ServerException && e.statusCode == 404)) {
        return (failure: null, cv: null);
      }
      return (failure: failure, cv: null);
    }
  }

  @override
  Future<({Failure? failure, Cv? cv})> updateDraft(Cv draft) async {
    try {
      final request = CvDraftUpdateRequestDto(
        fullName: draft.fullName,
        summary: draft.summary,
        workHistory: draft.workHistories
            .map(
              (w) => CvDraftWorkHistoryItemDto(
                company: w.company,
                role: w.role,
                isCurrent: w.isCurrent,
                description: w.description,
              ),
            )
            .toList(),
      );

      final detailDto = await _apiService.updateDraft(request);
      return (failure: null, cv: detailDto.toDomain());
    } catch (e) {
      return (failure: _mapExceptionToFailure(e), cv: null);
    }
  }

  @override
  Future<({Failure? failure, Cv? cv})> finalizeCv() async {
    try {
      final detailDto = await _apiService.finalizeCv();
      return (failure: null, cv: detailDto.toDomain());
    } catch (e) {
      return (failure: _mapExceptionToFailure(e), cv: null);
    }
  }

  @override
  Future<({Failure? failure, String? filePath})> downloadRawCv() async {
    try {
      final result = await _apiService.downloadRawCv();
      final fileName = result.fileName ?? 'downloaded_cv.pdf';
      if (kIsWeb) {
        return (failure: null, filePath: fileName);
      }
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(result.bytes);
      return (failure: null, filePath: file.path);
    } catch (e) {
      return (failure: _mapExceptionToFailure(e), filePath: null);
    }
  }

  @override
  Future<({Failure? failure, bool success})> deleteCv() async {
    try {
      await _apiService.deleteCv();
      return (failure: null, success: true);
    } catch (e) {
      return (failure: _mapExceptionToFailure(e), success: false);
    }
  }

  Failure _mapExceptionToFailure(Object exception) {
    if (exception is DioException && exception.error is AppException) {
      final appException = exception.error! as AppException;
      return _mapAppException(appException);
    } else if (exception is AppException) {
      return _mapAppException(exception);
    }

    return UnknownFailure(message: exception.toString());
  }

  Failure _mapAppException(AppException exception) {
    if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is AuthException) {
      return AuthFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is NetworkException) {
      return NetworkFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    }

    return ServerFailure(
      message: exception.message,
      code: exception.code,
      details: exception.details,
    );
  }
}
