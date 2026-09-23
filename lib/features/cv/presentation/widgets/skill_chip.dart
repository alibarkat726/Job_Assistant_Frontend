import 'package:flutter/material.dart';
import '../../domain/entities/cv_skill.dart';

class SkillChip extends StatelessWidget {
  final CvSkill skill;

  const SkillChip({
    super.key,
    required this.skill,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Chip(
      label: Text(
        skill.name,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      side: BorderSide(color: theme.colorScheme.outline),
    );
  }
}
