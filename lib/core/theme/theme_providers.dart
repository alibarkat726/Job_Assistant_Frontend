import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/theme_storage.dart';

final themeStorageProvider = Provider<ThemeStorage>((ref) {
  return ThemeStorageImpl();
});

class ThemeModeController extends Notifier<ThemeMode> {
  late final ThemeStorage _storage;

  @override
  ThemeMode build() {
    _storage = ref.watch(themeStorageProvider);
    Future.microtask(() => _loadThemeMode());
    return ThemeMode.system;
  }

  Future<void> _loadThemeMode() async {
    final mode = await _storage.getThemeMode();
    state = mode;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _storage.saveThemeMode(mode);
  }

  void toggleThemeMode() {
    if (state == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }
}

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(() {
  return ThemeModeController();
});
