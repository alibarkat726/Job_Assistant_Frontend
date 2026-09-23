import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_picked_file.dart';
import '../entities/cv.dart';

abstract class CvRepository {
  Future<({Failure? failure, Cv? cv})> uploadCv(
    AppPickedFile file, {
    void Function(int count, int total)? onSendProgress,
  });

  Future<({Failure? failure, Cv? cv})> getMyCv();

  Future<({Failure? failure, Cv? cv})> updateDraft(Cv draft);

  Future<({Failure? failure, Cv? cv})> finalizeCv();

  Future<({Failure? failure, String? filePath})> downloadRawCv();

  Future<({Failure? failure, bool success})> deleteCv();
}
