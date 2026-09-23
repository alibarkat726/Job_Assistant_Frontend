import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_picked_file.dart';
import '../providers/cv_providers.dart';
import '../widgets/file_picker_button.dart';

class CvUploadScreen extends ConsumerStatefulWidget {
  const CvUploadScreen({super.key});

  @override
  ConsumerState<CvUploadScreen> createState() => _CvUploadScreenState();
}

class _CvUploadScreenState extends ConsumerState<CvUploadScreen> {
  double? _uploadProgress;
  String? _errorMessage;

  Future<void> _handleFileSelected(AppPickedFile file) async {
    setState(() {
      _uploadProgress = 0.0;
      _errorMessage = null;
    });

    final result = await ref.read(cvControllerProvider.notifier).uploadCv(
      file,
      onSendProgress: (count, total) {
        if (total > 0 && mounted) {
          setState(() {
            _uploadProgress = count / total;
          });
        }
      },
    );

    if (mounted) {
      setState(() {
        _uploadProgress = null;
      });

      if (result.success && result.cv != null) {
        context.go('/cv/review');
      } else if (result.errorMessage != null) {
        setState(() {
          _errorMessage = result.errorMessage;
        });
      }
    }
  }

  void _handleValidationError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Your CV'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      TablerIcons.file_upload,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No CV Uploaded Yet',
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upload your primary resume to extract skills, work history, and enable AI job matching.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (_uploadProgress != null) ...[
                      LinearProgressIndicator(
                        value: _uploadProgress,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Uploading & Parsing... ${(_uploadProgress! * 100).round()}%',
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ] else ...[
                      FilePickerButton(
                        onFileSelected: _handleFileSelected,
                        onError: _handleValidationError,
                        isLoading: _uploadProgress != null,
                      ),
                    ],
                  ],
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.colorScheme.error),
                  ),
                  child: Row(
                    children: [
                      Icon(TablerIcons.alert_circle,
                          color: theme.colorScheme.error),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
