import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/cv_detail_dto.dart';
import '../models/cv_draft_update_request_dto.dart';
import '../models/cv_upload_response_dto.dart';

abstract class CvApiService {
  Future<CvUploadResponseDto> uploadCv(
    List<int> bytes,
    String fileName, {
    void Function(int count, int total)? onSendProgress,
  });

  Future<CvDetailDto> getMyCv();

  Future<CvDetailDto> updateDraft(CvDraftUpdateRequestDto request);

  Future<CvDetailDto> finalizeCv();

  Future<({List<int> bytes, String? fileName, String? contentType})> downloadRawCv();

  Future<void> deleteCv();
}

class CvApiServiceImpl implements CvApiService {
  final ApiClient _apiClient;

  CvApiServiceImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<CvUploadResponseDto> uploadCv(
    List<int> bytes,
    String fileName, {
    void Function(int count, int total)? onSendProgress,
  }) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        bytes,
        filename: fileName,
      ),
    });

    final response = await _apiClient.dio.post(
      '/cvs/upload',
      data: formData,
      onSendProgress: onSendProgress,
    );

    return CvUploadResponseDto.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<CvDetailDto> getMyCv() async {
    final response = await _apiClient.dio.get('/cvs/me');
    return CvDetailDto.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<CvDetailDto> updateDraft(CvDraftUpdateRequestDto request) async {
    final response = await _apiClient.dio.put(
      '/cvs/draft',
      data: request.toJson(),
    );
    return CvDetailDto.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<CvDetailDto> finalizeCv() async {
    final response = await _apiClient.dio.post('/cvs/finalize');
    return CvDetailDto.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<({List<int> bytes, String? fileName, String? contentType})> downloadRawCv() async {
    final response = await _apiClient.dio.get<List<int>>(
      '/cvs/raw',
      options: Options(responseType: ResponseType.bytes),
    );

    final disposition = response.headers.value('content-disposition');
    String? fileName;
    if (disposition != null && disposition.contains('filename=')) {
      final regExp = RegExp(r'filename="?([^";]+)"?');
      final match = regExp.firstMatch(disposition);
      if (match != null) {
        fileName = match.group(1);
      }
    }

    final contentType = response.headers.value('content-type');
    final bytes = response.data ?? <int>[];

    return (bytes: bytes, fileName: fileName, contentType: contentType);
  }

  @override
  Future<void> deleteCv() async {
    await _apiClient.dio.delete('/cvs/me');
  }
}
