import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/cv.dart';
import '../../domain/entities/work_history.dart';
import '../providers/cv_providers.dart';
import '../widgets/cv_section_card.dart';
import '../widgets/education_tile.dart';
import '../widgets/parse_confidence_banner.dart';
import '../widgets/skill_chip.dart';
import '../widgets/work_history_tile.dart';

class CvReviewScreen extends ConsumerStatefulWidget {
  const CvReviewScreen({super.key});

  @override
  ConsumerState<CvReviewScreen> createState() => _CvReviewScreenState();
}

class _CvReviewScreenState extends ConsumerState<CvReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _summaryController;
  List<WorkHistory> _workHistories = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _summaryController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  void _initializeFromCv(Cv cv) {
    if (_nameController.text.isEmpty && _summaryController.text.isEmpty) {
      _nameController.text = cv.fullName;
      _summaryController.text = cv.summary ?? '';
      _workHistories = List.from(cv.workHistories);
    }
  }

  Future<void> _saveDraft(Cv currentCv) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final updatedCv = currentCv.copyWith(
      fullName: _nameController.text.trim(),
      summary: _summaryController.text.trim(),
      workHistories: _workHistories,
    );

    final result = await ref.read(cvControllerProvider.notifier).updateDraft(updatedCv);

    if (mounted) {
      setState(() {
        _isSaving = false;
      });

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Draft saved successfully.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.errorMessage ?? 'Failed to save draft.')),
        );
      }
    }
  }

  Future<void> _confirmAndFinalize(Cv currentCv) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalize Baseline CV?'),
        content: const Text(
          'Finalizing will set this document as your canonical baseline CV for future job applications and AI skill matching. You can edit or replace it later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm & Finalize'),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && mounted) {
      setState(() {
        _isSaving = true;
      });

      // Save draft first if modified
      final updatedCv = currentCv.copyWith(
        fullName: _nameController.text.trim(),
        summary: _summaryController.text.trim(),
        workHistories: _workHistories,
      );
      await ref.read(cvControllerProvider.notifier).updateDraft(updatedCv);

      final result = await ref.read(cvControllerProvider.notifier).finalizeCv();

      if (mounted) {
        setState(() {
          _isSaving = false;
        });

        if (result.success) {
          context.go('/cv/detail');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.errorMessage ?? 'Failed to finalize CV.')),
          );
        }
      }
    }
  }

  void _showAddEditWorkHistoryModal([WorkHistory? existing, int? index]) {
    final companyController = TextEditingController(text: existing?.company ?? '');
    final roleController = TextEditingController(text: existing?.role ?? '');
    final descController = TextEditingController(text: existing?.description ?? '');
    bool isCurrent = existing?.isCurrent ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                existing == null ? 'Add Work Experience' : 'Edit Work Experience',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'Role / Position'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: companyController,
                decoration: const InputDecoration(labelText: 'Company Name'),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Current Role'),
                value: isCurrent,
                onChanged: (val) {
                  setModalState(() {
                    isCurrent = val;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description / Achievements'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (roleController.text.trim().isEmpty || companyController.text.trim().isEmpty) return;
                  final item = WorkHistory(
                    id: existing?.id,
                    role: roleController.text.trim(),
                    company: companyController.text.trim(),
                    isCurrent: isCurrent,
                    description: descController.text.trim(),
                  );
                  setState(() {
                    if (index != null) {
                      _workHistories[index] = item;
                    } else {
                      _workHistories.add(item);
                    }
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save Experience'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cvState = ref.watch(cvControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Parsed CV Draft'),
        actions: [
          IconButton(
            icon: const Icon(TablerIcons.file_upload),
            tooltip: 'Re-upload Different CV',
            onPressed: () => context.go('/cv/upload'),
          ),
        ],
      ),
      body: cvState.when(
        data: (cv) {
          if (cv == null) {
            return Center(
              child: Text(
                'No draft available.',
                style: theme.textTheme.bodyLarge,
              ),
            );
          }

          _initializeFromCv(cv);

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ParseConfidenceBanner(
                    confidence: cv.parseConfidence,
                    notes: cv.parsingNotes,
                  ),
                  const SizedBox(height: 24),

                  // Editable Contact Info
                  CvSectionCard(
                    title: 'Contact Information',
                    icon: TablerIcons.user,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Full Name'),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Full name is required' : null,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Chip(
                              avatar: const Icon(TablerIcons.lock, size: 14),
                              label: Text('Read-Only Details', style: theme.textTheme.labelSmall),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text('Email', style: theme.textTheme.labelSmall),
                          subtitle: Text(cv.email ?? 'Not specified', style: theme.textTheme.bodyMedium),
                        ),
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text('Location', style: theme.textTheme.labelSmall),
                          subtitle: Text(cv.location ?? 'Not specified', style: theme.textTheme.bodyMedium),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Editable Summary
                  CvSectionCard(
                    title: 'Professional Summary',
                    icon: TablerIcons.file_text,
                    child: TextFormField(
                      controller: _summaryController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Enter your professional summary...',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Editable Work History
                  CvSectionCard(
                    title: 'Work History',
                    icon: TablerIcons.briefcase,
                    trailing: IconButton(
                      icon: const Icon(TablerIcons.plus),
                      onPressed: () => _showAddEditWorkHistoryModal(),
                    ),
                    child: _workHistories.isEmpty
                        ? Text('No work experience parsed.', style: theme.textTheme.bodyMedium)
                        : Column(
                            children: _workHistories
                                .asMap()
                                .entries
                                .map(
                                  (entry) => WorkHistoryTile(
                                    workHistory: entry.value,
                                    onEdit: () => _showAddEditWorkHistoryModal(entry.value, entry.key),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                  const SizedBox(height: 20),

                  // Read-only Education
                  CvSectionCard(
                    title: 'Education',
                    icon: TablerIcons.school,
                    trailing: Chip(
                      avatar: const Icon(TablerIcons.lock, size: 14),
                      label: Text('Read-Only', style: theme.textTheme.labelSmall),
                    ),
                    child: cv.educationEntries.isEmpty
                        ? Text('No education parsed.', style: theme.textTheme.bodyMedium)
                        : Column(
                            children: cv.educationEntries
                                .map((edu) => EducationTile(education: edu))
                                .toList(),
                          ),
                  ),
                  const SizedBox(height: 20),

                  // Read-only Skills
                  CvSectionCard(
                    title: 'Extracted Skills',
                    icon: TablerIcons.code,
                    trailing: Chip(
                      avatar: const Icon(TablerIcons.lock, size: 14),
                      label: Text('Read-Only', style: theme.textTheme.labelSmall),
                    ),
                    child: cv.skills.isEmpty
                        ? Text('No skills extracted.', style: theme.textTheme.bodyMedium)
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: cv.skills.map((s) => SkillChip(skill: s)).toList(),
                          ),
                  ),
                  const SizedBox(height: 32),

                  // Actions
                  OutlinedButton.icon(
                    onPressed: _isSaving ? null : () => _saveDraft(cv),
                    icon: const Icon(TablerIcons.device_floppy),
                    label: const Text('Save Draft'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _isSaving ? null : () => _confirmAndFinalize(cv),
                    icon: const Icon(TablerIcons.check),
                    label: const Text('Finalize Baseline CV'),
                  ),
                ],
              ),
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
                child: const Text('Back to Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
