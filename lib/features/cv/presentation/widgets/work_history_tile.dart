import 'package:flutter/material.dart';
import '../../domain/entities/work_history.dart';

class WorkHistoryTile extends StatelessWidget {
  final WorkHistory workHistory;
  final VoidCallback? onEdit;

  const WorkHistoryTile({
    super.key,
    required this.workHistory,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final start = workHistory.startDate ?? 'N/A';
    final end = workHistory.isCurrent
        ? 'Present'
        : (workHistory.endDate ?? 'Present');
    final dateRange = '$start – $end';

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
          Row(
            children: [
              Expanded(
                child: Text(
                  workHistory.role,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (onEdit != null)
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  onPressed: onEdit,
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            workHistory.company,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                dateRange,
                style: theme.textTheme.bodySmall,
              ),
              if (workHistory.location != null &&
                  workHistory.location!.isNotEmpty) ...[
                Text('  •  ', style: theme.textTheme.bodySmall),
                Text(
                  workHistory.location!,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
          if (workHistory.description != null &&
              workHistory.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              workHistory.description!,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
