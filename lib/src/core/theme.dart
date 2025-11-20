import 'package:flutter/material.dart';

/// Premium theme modes inspired by Lusion.co aesthetic
enum Personality {
  /// Dark minimalist theme with deep blacks
  dark,

  /// Light sophisticated theme with subtle grays
  light,
}

/// Extension methods for Personality enum to get premium color schemes
extension PersonalityExtension on Personality {
  /// Get the primary color for this personality
  Color get primaryColor {
    switch (this) {
      case Personality.dark:
        return const Color(0xFF0A0A0A); // Deep black
      case Personality.light:
        return const Color(0xFFFAFAFA); // Subtle white
    }
  }

  /// Get the secondary color for this personality
  Color get secondaryColor {
    switch (this) {
      case Personality.dark:
        return const Color(0xFF1A1A1A); // Charcoal
      case Personality.light:
        return const Color(0xFFF5F5F5); // Light gray
    }
  }

  /// Get the accent color for this personality (minimal use)
  Color get accentColor {
    switch (this) {
      case Personality.dark:
        return const Color(0xFFE8E8E8); // Soft white
      case Personality.light:
        return const Color(0xFF2A2A2A); // Soft black
    }
  }

  /// Get the subtle gradient for this personality
  RadialGradient get radialGradient {
    return RadialGradient(
      center: Alignment.center,
      radius: 1.5,
      colors: [
        secondaryColor.withOpacity(0.3),
        primaryColor.withOpacity(0.1),
        primaryColor,
      ],
    );
  }

  /// Get the display name for this personality
  String get displayName {
    switch (this) {
      case Personality.dark:
        return 'Dark';
      case Personality.light:
        return 'Light';
    }
  }
}

/// Premium Material 3 theme inspired by Lusion.co
class CompanionTheme {
  /// Create a premium theme for the given personality
  static ThemeData createTheme(Personality personality) {
    final colorScheme = _createColorScheme(personality);
    final isDark = personality == Personality.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: isDark ? Brightness.dark : Brightness.light,

      // Custom theme components with minimal design
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      cardTheme: CardThemeData(
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(
            color: colorScheme.onSurface.withOpacity(0.08),
            width: 1,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
          backgroundColor: colorScheme.onSurface,
          foregroundColor: colorScheme.surface,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
          side: BorderSide(
            color: colorScheme.onSurface.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),

      // Premium typography with refined weights
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 64,
          fontWeight: FontWeight.w300,
          letterSpacing: -1.5,
          height: 1.2,
        ),
        displayMedium: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 48,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
          height: 1.3,
        ),
        headlineLarge: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 32,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.4,
        ),
        headlineMedium: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          height: 1.5,
        ),
        titleLarge: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
          height: 1.6,
        ),
        bodyLarge: TextStyle(
          color: colorScheme.onSurface.withOpacity(0.87),
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          height: 1.75,
        ),
        bodyMedium: TextStyle(
          color: colorScheme.onSurface.withOpacity(0.87),
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          height: 1.7,
        ),
        bodySmall: TextStyle(
          color: colorScheme.onSurface.withOpacity(0.6),
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          height: 1.6,
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
              colorScheme.surface.withOpacity(0.95),
            ],
          ),
          radialGradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              colorScheme.onSurface.withOpacity(0.02),
              colorScheme.surface,
            ],
          ),
        ),
      ],
    );
  }

  /// Create a premium monochromatic ColorScheme
  static ColorScheme _createColorScheme(Personality personality) {
    final isDark = personality == Personality.dark;

    if (isDark) {
      // Dark premium theme
      return const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF0A0A0A),
        onPrimary: Color(0xFFE8E8E8),
        secondary: Color(0xFF1A1A1A),
        onSecondary: Color(0xFFE8E8E8),
        tertiary: Color(0xFF2A2A2A),
        onTertiary: Color(0xFFE8E8E8),
        error: Color(0xFFDC2626),
        onError: Color(0xFFFFFFFF),
        surface: Color(0xFF0A0A0A),
        onSurface: Color(0xFFE8E8E8),
        onSurfaceVariant: Color(0xFFB0B0B0),
        outline: Color(0xFF3A3A3A),
        outlineVariant: Color(0xFF2A2A2A),
        shadow: Color(0xFF000000),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFFFAFAFA),
        onInverseSurface: Color(0xFF0A0A0A),
        inversePrimary: Color(0xFFFAFAFA),
        surfaceTint: Color(0xFF1A1A1A),
      );
    } else {
      // Light premium theme
      return const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFFFAFAFA),
        onPrimary: Color(0xFF0A0A0A),
        secondary: Color(0xFFF5F5F5),
        onSecondary: Color(0xFF0A0A0A),
        tertiary: Color(0xFFE8E8E8),
        onTertiary: Color(0xFF0A0A0A),
        error: Color(0xFFDC2626),
        onError: Color(0xFFFFFFFF),
        surface: Color(0xFFFAFAFA),
        onSurface: Color(0xFF0A0A0A),
        onSurfaceVariant: Color(0xFF5A5A5A),
        outline: Color(0xFFD0D0D0),
        outlineVariant: Color(0xFFE8E8E8),
        shadow: Color(0xFF000000),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFF0A0A0A),
        onInverseSurface: Color(0xFFFAFAFA),
        inversePrimary: Color(0xFF0A0A0A),
        surfaceTint: Color(0xFFF5F5F5),
      );
    }
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

