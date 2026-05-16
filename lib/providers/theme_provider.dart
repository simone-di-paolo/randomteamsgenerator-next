import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

/// Notifier responsible for managing the application's theme mode (Light/Dark).
@Riverpod(keepAlive: true)
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    if (kDebugMode) {
      print('ThemeNotifier: Initializing with ThemeMode.system');
    }
    return ThemeMode.system;
  }

  /// Toggles between light and dark modes.
  void toggleTheme(bool isDark) {
    state = isDark ? ThemeMode.dark : ThemeMode.light;
    if (kDebugMode) {
      print('ThemeNotifier: Theme changed to ${state.name}');
    }
  }
}
