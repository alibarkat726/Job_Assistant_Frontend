import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:job_assistant/core/theme/app_semantic_colors.dart';
import 'package:job_assistant/core/theme/theme_providers.dart';
import 'package:job_assistant/features/auth/presentation/controllers/auth_state.dart';
import 'package:job_assistant/features/auth/presentation/providers/auth_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final semanticColors = theme.extension<AppSemanticColors>() ?? AppSemanticColors.dark;
    final isDarkMode = theme.brightness == Brightness.dark;

    final authState = ref.watch(authControllerProvider);
    final user = authState is AuthStateAuthenticated ? authState.user : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Assistant AI'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? TablerIcons.sun : TablerIcons.moon),
            tooltip: 'Toggle Light/Dark Theme',
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleThemeMode();
            },
          ),
          IconButton(
            icon: const Icon(TablerIcons.logout),
            tooltip: 'Logout',
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      TablerIcons.user,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome Back!',
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user?.email ?? 'Logged in user',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Chip(
                      avatar: Icon(
                        (user?.isVerified ?? false) ? TablerIcons.circle_check : TablerIcons.alert_circle,
                        size: 16,
                        color: (user?.isVerified ?? false)
                            ? semanticColors.matchedText
                            : semanticColors.partialText,
                      ),
                      backgroundColor: (user?.isVerified ?? false)
                          ? semanticColors.matchedBg
                          : semanticColors.partialBg,
                      label: Text(
                        (user?.isVerified ?? false) ? 'Email Verified' : 'Unverified',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: (user?.isVerified ?? false)
                              ? semanticColors.matchedText
                              : semanticColors.partialText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(authControllerProvider.notifier).logout();
                },
                icon: const Icon(TablerIcons.logout),
                label: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
