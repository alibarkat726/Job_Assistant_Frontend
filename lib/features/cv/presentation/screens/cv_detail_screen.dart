import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';
import '../../../../core/theme/app_semantic_colors.dart';
import '../../domain/entities/cv_skill.dart';
import '../providers/cv_providers.dart';
import '../widgets/cv_section_card.dart';
import '../widgets/education_tile.dart';
import '../widgets/skill_chip.dart';
import '../widgets/work_history_tile.dart';

class CvDetailScreen extends ConsumerStatefulWidget {
  const CvDetailScreen({super.key});

  @override
  ConsumerState<CvDetailScreen> createState() => _CvDetailScreenState();
}

class _CvDetailScreenState extends ConsumerState<CvDetailScreen> {
  bool _isDownloading = false;

  Future<void> _downloadRaw() async {
    setState(() {
      _isDownloading = true;
    });

    final result = await ref.read(cvControllerProvider.notifier).downloadRawCv();

    if (mounted) {
      setState(() {
        _isDownloading = false;
      });

      if (result.success && result.filePath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File downloaded to: ${result.filePath}'),
            action: SnackBarAction(
              label: 'Open File',
              onPressed: () {
                OpenFilex.open(result.filePath!);
              },
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage ?? 'Failed to download raw CV file.'),
          ),
        );
      }
    }
  }

  Future<void> _confirmAndDelete() async {
    final semanticColors = Theme.of(context).extension<AppSemanticColors>() ?? AppSemanticColors.dark;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Baseline CV?'),
        content: const Text(
          'This action is destructive and will permanently delete your baseline CV and extracted skill profile. You will need to upload a new CV.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: semanticColors.missingBg,
              foregroundColor: semanticColors.missingText,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && mounted) {
      final result = await ref.read(cvControllerProvider.notifier).deleteCv();
      if (mounted) {
        if (result.success) {
          context.go('/cv/upload');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.errorMessage ?? 'Failed to delete CV.')),
          );
        }
      }
    }
  }

  Map<String, List<CvSkill>> _groupSkillsByCategory(List<CvSkill> skills) {
    final Map<String, List<CvSkill>> grouped = {};
    for (final skill in skills) {
      final category = skill.category ?? 'General Skills';
      grouped.putIfAbsent(category, () => []).add(skill);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cvState = ref.watch(cvControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Canonical Baseline CV'),
        actions: [
          IconButton(
            icon: const Icon(TablerIcons.download),
            tooltip: 'Download Raw CV',
            onPressed: _isDownloading ? null : _downloadRaw,
          ),
          IconButton(
            icon: const Icon(TablerIcons.trash),
            tooltip: 'Delete CV',
            onPressed: _confirmAndDelete,
          ),
        ],
      ),
      body: cvState.when(
        data: (cv) {
          if (cv == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No CV available.', style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/cv/upload'),
                    child: const Text('Upload CV'),
                  ),
                ],
              ),
            );
          }

          final groupedSkills = _groupSkillsByCategory(cv.skills);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(TablerIcons.file_check, size: 36, color: theme.colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cv.fullName,
                                  style: theme.textTheme.displayMedium,
                                ),
                                if (cv.rawFileName != null)
                                  Text(
                                    'File: ${cv.rawFileName}',
                                    style: theme.textTheme.bodySmall,
                                  ),
                              ],
                            ),
                          ),
                          Chip(
                            avatar: const Icon(TablerIcons.circle_check, size: 16),
                            label: const Text('Canonical'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (cv.email != null)
                            Row(
                              children: [
                                const Icon(TablerIcons.mail, size: 16),
                                const SizedBox(width: 6),
                                Text(cv.email!, style: theme.textTheme.bodySmall),
                              ],
                            ),
                          if (cv.phone != null)
                            Row(
                              children: [
                                const Icon(TablerIcons.phone, size: 16),
                                const SizedBox(width: 6),
                                Text(cv.phone!, style: theme.textTheme.bodySmall),
                              ],
                            ),
                          if (cv.location != null)
                            Row(
                              children: [
                                const Icon(TablerIcons.map_pin, size: 16),
                                const SizedBox(width: 6),
                                Text(cv.location!, style: theme.textTheme.bodySmall),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Summary
                if (cv.summary != null && cv.summary!.isNotEmpty) ...[
                  CvSectionCard(
                    title: 'Professional Summary',
                    icon: TablerIcons.file_text,
                    child: Text(cv.summary!, style: theme.textTheme.bodyLarge),
                  ),
                  const SizedBox(height: 20),
                ],

                // Work History Timeline
                CvSectionCard(
                  title: 'Work Experience',
                  icon: TablerIcons.briefcase,
                  child: cv.workHistories.isEmpty
                      ? Text('No work experience recorded.', style: theme.textTheme.bodyMedium)
                      : Column(
                          children: cv.workHistories
                              .map((work) => WorkHistoryTile(workHistory: work))
                              .toList(),
                        ),
                ),
                const SizedBox(height: 20),

                // Education Entries
                CvSectionCard(
                  title: 'Education',
                  icon: TablerIcons.school,
                  child: cv.educationEntries.isEmpty
                      ? Text('No education recorded.', style: theme.textTheme.bodyMedium)
                      : Column(
                          children: cv.educationEntries
                              .map((edu) => EducationTile(education: edu))
                              .toList(),
                        ),
                ),
                const SizedBox(height: 20),

                // Grouped Skills
                CvSectionCard(
                  title: 'Skills & Competencies',
                  icon: TablerIcons.code,
                  child: cv.skills.isEmpty
                      ? Text('No skills recorded.', style: theme.textTheme.bodyMedium)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: groupedSkills.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.key,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: entry.value
                                        .map((skill) => SkillChip(skill: skill))
                                        .toList(),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                ),
                const SizedBox(height: 32),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _downloadRaw,
                        icon: const Icon(TablerIcons.download),
                        label: const Text('Download Raw'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => context.go('/cv/review'),
                        icon: const Icon(TablerIcons.edit),
                        label: const Text('Edit Draft'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $err', style: theme.textTheme.bodyLarge),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/cv/upload'),
                child: const Text('Upload CV'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
