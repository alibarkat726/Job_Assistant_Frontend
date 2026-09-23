import 'package:flutter/material.dart';
import '../../domain/entities/education_entry.dart';

class EducationTile extends StatelessWidget {
  final EducationEntry education;

  const EducationTile({
    super.key,
    required this.education,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final start = education.startDate ?? '';
    final end = education.endDate ?? '';
    final dateRange = start.isNotEmpty || end.isNotEmpty
        ? '$start ${end.isNotEmpty ? '– $end' : ''}'
        : null;

    final degreeText = [
      if (education.degree != null && education.degree!.isNotEmpty)
        education.degree,
      if (education.fieldOfStudy != null && education.fieldOfStudy!.isNotEmpty)
        education.fieldOfStudy,
    ].join(' in ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            education.institution,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (degreeText.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              degreeText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
          if (dateRange != null) ...[
            const SizedBox(height: 4),
            Text(
              dateRange,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
