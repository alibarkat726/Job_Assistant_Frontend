import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../../../../core/utils/app_picked_file.dart';

class FilePickerButton extends StatelessWidget {
  final ValueChanged<AppPickedFile> onFileSelected;
  final ValueChanged<String> onError;
  final bool isLoading;

  const FilePickerButton({
    super.key,
    required this.onFileSelected,
    required this.onError,
    this.isLoading = false,
  });

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'txt'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final platformFile = result.files.single;
        final bytes = platformFile.bytes;

        if (bytes == null || bytes.isEmpty) {
          onError('Failed to read selected file data.');
          return;
        }

        final size = platformFile.size;
        if (size > 10 * 1024 * 1024) {
          onError('File size exceeds the 10MB limit (${(size / (1024 * 1024)).toStringAsFixed(1)}MB). Please choose a smaller file.');
          return;
        }

        final file = AppPickedFile(
          name: platformFile.name,
          bytes: bytes,
          size: size,
          path: platformFile.path,
        );

        onFileSelected(file);
      }
    } catch (e) {
      onError('Failed to pick file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isLoading ? null : _pickFile,
      icon: const Icon(TablerIcons.file_upload),
      label: const Text('Choose File (PDF, DOCX, TXT - Max 10MB)'),
    );
  }
}
