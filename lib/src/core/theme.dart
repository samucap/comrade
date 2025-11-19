import 'package:flutter/material.dart';

/// Personality types for the companion avatar.
/// Each personality has its own color scheme and accent colors.
enum Personality {
  /// Playful and friendly personality with blue/purple tones
  playful,

  /// Energetic and bold personality with orange/red tones
  energetic,
}

/// Extension methods for Personality enum to get color schemes
extension PersonalityExtension on Personality {
  /// Get the primary color for this personality
  Color get primaryColor {
    switch (this) {
      case Personality.playful:
        return const Color(0xFF6366F1); // Indigo
      case Personality.energetic:
        return const Color(0xFFF97316); // Orange
    }
  }

  /// Get the secondary color for this personality
  Color get secondaryColor {
    switch (this) {
      case Personality.playful:
        return const Color(0xFF8B5CF6); // Purple
      case Personality.energetic:
        return const Color(0xFFDC2626); // Red
    }
  }

  /// Get the accent color for this personality
  Color get accentColor {
    switch (this) {
      case Personality.playful:
        return const Color(0xFF06B6D4); // Cyan
      case Personality.energetic:
        return const Color(0xFFF59E0B); // Amber
    }
  }

  /// Get the radial gradient for this personality
  RadialGradient get radialGradient {
    return RadialGradient(
      center: Alignment.center,
      radius: 1.2,
      colors: [
        primaryColor.withOpacity(0.1),
        secondaryColor.withOpacity(0.05),
        const Color(0xFFFEFEFE),
      ],
    );
  }

  /// Get the display name for this personality
  String get displayName {
    switch (this) {
      case Personality.playful:
        return 'Playful';
      case Personality.energetic:
        return 'Energetic';
    }
  }
}

/// Material 3 theme data for the companion app
class CompanionTheme {
  /// Create a theme for the given personality
  static ThemeData createTheme(Personality personality) {
    final colorScheme = _createColorScheme(personality);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // Custom theme components
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surfaceContainerLowest,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),

      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerHighest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Text themes
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 32,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Custom properties
      extensions: [
        CompanionThemeExtension(
          personality: personality,
          gradientBackground: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerLowest,
            ],
          ),
          radialGradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.surface,
            ],
          ),
        ),
      ],
    );
  }

  /// Create a ColorScheme for the given personality
  static ColorScheme _createColorScheme(Personality personality) {
    final primary = personality.primaryColor;
    final secondary = personality.secondaryColor;
    final accent = personality.accentColor;

    // Material 3 color scheme generation
    return ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      secondary: secondary,
      tertiary: accent,
      surface: const Color(0xFFFEFEFE),
      surfaceContainerLowest: const Color(0xFFF8F9FA),
      surfaceContainerLow: const Color(0xFFF1F3F4),
      surfaceContainer: const Color(0xFFECEFF1),
      surfaceContainerHigh: const Color(0xFFE8F5E8).withOpacity(0.8),
      surfaceContainerHighest: const Color(0xFFE0F2F1).withOpacity(0.9),
      onSurface: const Color(0xFF1C1B1F),
      onSurfaceVariant: const Color(0xFF49454F),
    );
  }
}

/// Custom theme extension for companion-specific theming
class CompanionThemeExtension extends ThemeExtension<CompanionThemeExtension> {
  const CompanionThemeExtension({
    required this.personality,
    required this.gradientBackground,
    required this.radialGradient,
  });

  final Personality personality;
  final LinearGradient gradientBackground;
  final RadialGradient radialGradient;

  @override
  ThemeExtension<CompanionThemeExtension> copyWith({
    Personality? personality,
    LinearGradient? gradientBackground,
    RadialGradient? radialGradient,
  }) {
    return CompanionThemeExtension(
      personality: personality ?? this.personality,
      gradientBackground: gradientBackground ?? this.gradientBackground,
      radialGradient: radialGradient ?? this.radialGradient,
    );
  }

  @override
  ThemeExtension<CompanionThemeExtension> lerp(
    ThemeExtension<CompanionThemeExtension>? other,
    double t,
  ) {
    if (other is! CompanionThemeExtension) {
      return this;
    }

    return CompanionThemeExtension(
      personality: t < 0.5 ? personality : other.personality,
      gradientBackground: LinearGradient.lerp(gradientBackground, other.gradientBackground, t)!,
      radialGradient: RadialGradient.lerp(radialGradient, other.radialGradient, t)!,
    );
  }

  /// Get the extension from the current theme
  static CompanionThemeExtension of(BuildContext context) {
    return Theme.of(context).extension<CompanionThemeExtension>()!;
  }
}

/// Extension method to easily access companion theme from BuildContext
extension CompanionThemeExtensionX on BuildContext {
  CompanionThemeExtension get companionTheme => CompanionThemeExtension.of(this);
  Personality get personality => companionTheme.personality;
}

