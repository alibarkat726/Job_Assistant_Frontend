import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/app_picked_file.dart';
import '../../domain/entities/cv.dart';
import '../../domain/repositories/cv_repository.dart';
import '../providers/cv_providers.dart';

class CvController extends Notifier<AsyncValue<Cv?>> {
  late final CvRepository _repository;

  @override
  AsyncValue<Cv?> build() {
    _repository = ref.watch(cvRepositoryProvider);
    Future.microtask(() => loadCv());
    return const AsyncValue.loading();
  }

  Future<void> loadCv() async {
    state = const AsyncValue.loading();
    final result = await _repository.getMyCv();
    if (result.failure != null) {
      state = AsyncValue.error(
        result.failure!.message,
        StackTrace.current,
      );
    } else {
      state = AsyncValue.data(result.cv);
    }
  }

  Future<({bool success, Cv? cv, String? errorMessage})> uploadCv(
    AppPickedFile file, {
    void Function(int count, int total)? onSendProgress,
  }) async {
    state = const AsyncValue.loading();
    final result = await _repository.uploadCv(
      file,
      onSendProgress: onSendProgress,
    );

    if (result.cv != null) {
      state = AsyncValue.data(result.cv);
      return (success: true, cv: result.cv, errorMessage: null);
    } else {
      final msg = result.failure?.message ?? 'Failed to upload CV';
      state = AsyncValue.error(msg, StackTrace.current);
      return (success: false, cv: null, errorMessage: msg);
    }
  }

  Future<({bool success, Cv? cv, String? errorMessage})> updateDraft(Cv draft) async {
    final previousState = state.value;
    state = const AsyncValue.loading();
    final result = await _repository.updateDraft(draft);

    if (result.cv != null) {
      state = AsyncValue.data(result.cv);
      return (success: true, cv: result.cv, errorMessage: null);
    } else {
      final msg = result.failure?.message ?? 'Failed to update draft';
      state = AsyncValue.data(previousState);
      return (success: false, cv: null, errorMessage: msg);
    }
  }

  Future<({bool success, Cv? cv, String? errorMessage})> finalizeCv() async {
    final previousState = state.value;
    state = const AsyncValue.loading();
    final result = await _repository.finalizeCv();

    if (result.cv != null) {
      state = AsyncValue.data(result.cv);
      return (success: true, cv: result.cv, errorMessage: null);
    } else {
      final msg = result.failure?.message ?? 'Failed to finalize CV';
      state = AsyncValue.data(previousState);
      return (success: false, cv: null, errorMessage: msg);
    }
  }

  Future<({bool success, String? filePath, String? errorMessage})> downloadRawCv() async {
    final result = await _repository.downloadRawCv();
    if (result.filePath != null) {
      return (success: true, filePath: result.filePath, errorMessage: null);
    } else {
      return (
        success: false,
        filePath: null,
        errorMessage: result.failure?.message ?? 'Failed to download raw CV file'
      );
    }
  }

  Future<({bool success, String? errorMessage})> deleteCv() async {
    state = const AsyncValue.loading();
    final result = await _repository.deleteCv();

    if (result.success) {
      state = const AsyncValue.data(null);
      return (success: true, errorMessage: null);
    } else {
      final msg = result.failure?.message ?? 'Failed to delete CV';
      state = AsyncValue.error(msg, StackTrace.current);
      return (success: false, errorMessage: msg);
    }
  }
}
