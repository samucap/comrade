import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/theme.dart';

part 'theme_provider.g.dart';

/// Provider for managing the current personality/theme
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  Personality build() {
    // Default to playful personality
    return Personality.playful;
  }

  /// Switch to the next personality in the cycle
  void switchPersonality() {
    final currentIndex = Personality.values.indexOf(state);
    final nextIndex = (currentIndex + 1) % Personality.values.length;
    state = Personality.values[nextIndex];
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

