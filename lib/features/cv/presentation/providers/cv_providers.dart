import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/cv_repository_impl.dart';
import '../../data/services/cv_api_service.dart';
import '../../domain/entities/cv.dart';
import '../../domain/repositories/cv_repository.dart';
import '../controllers/cv_controller.dart';

final cvApiServiceProvider = Provider<CvApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CvApiServiceImpl(apiClient: apiClient);
});

final cvRepositoryProvider = Provider<CvRepository>((ref) {
  final apiService = ref.watch(cvApiServiceProvider);
  return CvRepositoryImpl(apiService: apiService);
});

final cvControllerProvider =
    NotifierProvider<CvController, AsyncValue<Cv?>>(() {
  return CvController();
});
