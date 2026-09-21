import 'package:flutter/material.dart';

@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color matchedBg;
  final Color matchedText;
  final Color partialBg;
  final Color partialText;
  final Color missingBg;
  final Color missingText;

  const AppSemanticColors({
    required this.matchedBg,
    required this.matchedText,
    required this.partialBg,
    required this.partialText,
    required this.missingBg,
    required this.missingText,
  });

  static const light = AppSemanticColors(
    matchedBg: Color(0xFFE3F7F3),
    matchedText: Color(0xFF0D9488),
    partialBg: Color(0xFFFDEEDA),
    partialText: Color(0xFFB4740E),
    missingBg: Color(0xFFFCE8E8),
    missingText: Color(0xFFB91C1C),
  );

  static const dark = AppSemanticColors(
    matchedBg: Color(0xFF0E2E2A),
    matchedText: Color(0xFF2DD4BF),
    partialBg: Color(0xFF2E2818),
    partialText: Color(0xFFF2A93B),
    missingBg: Color(0xFF2E1A1A),
    missingText: Color(0xFFF87171),
  );

  @override
  AppSemanticColors copyWith({
    Color? matchedBg,
    Color? matchedText,
    Color? partialBg,
    Color? partialText,
    Color? missingBg,
    Color? missingText,
  }) {
    return AppSemanticColors(
      matchedBg: matchedBg ?? this.matchedBg,
      matchedText: matchedText ?? this.matchedText,
      partialBg: partialBg ?? this.partialBg,
      partialText: partialText ?? this.partialText,
      missingBg: missingBg ?? this.missingBg,
      missingText: missingText ?? this.missingText,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      matchedBg: Color.lerp(matchedBg, other.matchedBg, t)!,
      matchedText: Color.lerp(matchedText, other.matchedText, t)!,
      partialBg: Color.lerp(partialBg, other.partialBg, t)!,
      partialText: Color.lerp(partialText, other.partialText, t)!,
      missingBg: Color.lerp(missingBg, other.missingBg, t)!,
      missingText: Color.lerp(missingText, other.missingText, t)!,
    );
  }
}
