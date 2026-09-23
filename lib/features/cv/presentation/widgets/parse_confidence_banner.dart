import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../../../../core/theme/app_semantic_colors.dart';

class ParseConfidenceBanner extends StatelessWidget {
  final double confidence;
  final List<String> notes;

  const ParseConfidenceBanner({
    super.key,
    required this.confidence,
    this.notes = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semanticColors =
        theme.extension<AppSemanticColors>() ?? AppSemanticColors.dark;

    final percentage = (confidence * 100).round();
    Color bgColor;
    Color textColor;
    IconData iconData;
    String statusTitle;

    if (confidence >= 0.8) {
      bgColor = semanticColors.matchedBg;
      textColor = semanticColors.matchedText;
      iconData = TablerIcons.circle_check;
      statusTitle = 'High Confidence Parse ($percentage%)';
    } else if (confidence >= 0.5) {
      bgColor = semanticColors.partialBg;
      textColor = semanticColors.partialText;
      iconData = TablerIcons.alert_triangle;
      statusTitle = 'Medium Confidence Parse ($percentage%)';
    } else {
      bgColor = semanticColors.missingBg;
      textColor = semanticColors.missingText;
      iconData = TablerIcons.alert_circle;
      statusTitle = 'Low Confidence Parse ($percentage%)';
    }

    final isLowOrHasNotes = confidence < 0.8 || notes.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(iconData, color: textColor, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  statusTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (isLowOrHasNotes) ...[
            const SizedBox(height: 8),
            Text(
              'Please carefully review and correct the parsed fields below before finalizing your canonical CV.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          if (notes.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              'Parsing Notes:',
              style: theme.textTheme.labelMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            ...notes.map(
              (note) => Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: TextStyle(color: textColor)),
                    Expanded(
                      child: Text(
                        note,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
