import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/theme.dart';

part 'theme_provider.g.dart';

/// Provider for managing the current personality/theme
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  Personality build() {
    // Default to light theme
    return Personality.light;
  }

  /// Switch to the next personality in the cycle
  void switchPersonality() {
    // Toggle between light and dark
    state = state == Personality.light ? Personality.dark : Personality.light;
  }

  /// Set a specific personality
  void setPersonality(Personality personality) {
    state = personality;
  }

  /// Get the current theme data
  ThemeData get themeData => CompanionTheme.createTheme(state);

  /// Get the current personality info
  Personality get currentPersonality => state;
}

/// Provider that returns the current theme data
@riverpod
ThemeData currentTheme(Ref ref) {
  final personality = ref.watch(themeNotifierProvider);
  return CompanionTheme.createTheme(personality);
}

/// Provider that returns the current personality
@riverpod
Personality currentPersonality(Ref ref) {
  return ref.watch(themeNotifierProvider);
}

