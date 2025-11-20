import 'package:flutter/material.dart';

/// Premium typography system inspired by Lusion.co
class LusionTypography {
  /// Display text styles for hero sections
  static const TextStyle displayLarge = TextStyle(
    fontSize: 64,
    fontWeight: FontWeight.w300,
    letterSpacing: -1.5,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.5,
    height: 1.3,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w300,
    letterSpacing: 0,
    height: 1.35,
  );

  /// Headline text styles for section titles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.5,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.6,
  );

  /// Title text styles for card headers
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.6,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.5,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.5,
  );

  /// Body text styles for content
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.75,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.7,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.6,
  );

  /// Label text styles for buttons and UI elements
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.3,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.3,
  );
}

/// Premium color palette for typography
class LusionColors {
  /// Primary text colors
  static const Color textPrimary = Color(0xFF0A0A0A);
  static const Color textSecondary = Color(0xFF5A5A5A);
  static const Color textTertiary = Color(0xFF8A8A8A);
  static const Color textDisabled = Color(0xFFB0B0B0);

  /// Light theme text colors
  static const Color textPrimaryLight = Color(0xFFE8E8E8);
  static const Color textSecondaryLight = Color(0xFFB0B0B0);
  static const Color textTertiaryLight = Color(0xFF808080);

  /// Accent color (minimal use)
  static const Color accent = Color(0xFF2A2A2A);
  static const Color accentLight = Color(0xFFE8E8E8);

  /// Surface colors
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color surfaceDark = Color(0xFF0A0A0A);
  
  /// Border colors
  static const Color borderLight = Color(0xFFE8E8E8);
  static const Color borderDark = Color(0xFF2A2A2A);

  /// Error state
  static const Color error = Color(0xFFDC2626);
}

/// Text style extensions for easy color application
extension TextStyleX on TextStyle {
  /// Apply primary text color
  TextStyle get primary => copyWith(color: LusionColors.textPrimary);

  /// Apply secondary text color
  TextStyle get secondary => copyWith(color: LusionColors.textSecondary);

  /// Apply tertiary text color
  TextStyle get tertiary => copyWith(color: LusionColors.textTertiary);

  /// Apply custom opacity
  TextStyle withOpacity(double opacity) {
    return copyWith(color: color?.withOpacity(opacity));
  }

  /// Apply custom color
  TextStyle withColor(Color color) {
    return copyWith(color: color);
  }

  /// Make text lighter weight
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);

  /// Make text regular weight
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);

  /// Make text medium weight
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  /// Make text semi-bold weight
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
}

/// Responsive typography that scales with screen size
class ResponsiveTypography {
  ResponsiveTypography(this.context);

  final BuildContext context;

  double get _scaleFactor {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return 0.9;
    if (width > 600) return 1.1;
    return 1.0;
  }

  TextStyle get displayLarge => LusionTypography.displayLarge.copyWith(
    fontSize: LusionTypography.displayLarge.fontSize! * _scaleFactor,
  );

  TextStyle get displayMedium => LusionTypography.displayMedium.copyWith(
    fontSize: LusionTypography.displayMedium.fontSize! * _scaleFactor,
  );

  TextStyle get headlineLarge => LusionTypography.headlineLarge.copyWith(
    fontSize: LusionTypography.headlineLarge.fontSize! * _scaleFactor,
  );

  TextStyle get headlineMedium => LusionTypography.headlineMedium.copyWith(
    fontSize: LusionTypography.headlineMedium.fontSize! * _scaleFactor,
  );

  TextStyle get bodyLarge => LusionTypography.bodyLarge.copyWith(
    fontSize: LusionTypography.bodyLarge.fontSize! * _scaleFactor,
  );

  TextStyle get bodyMedium => LusionTypography.bodyMedium.copyWith(
    fontSize: LusionTypography.bodyMedium.fontSize! * _scaleFactor,
  );
}

/// BuildContext extension for easy typography access
extension TypographyContext on BuildContext {
  /// Get responsive typography
  ResponsiveTypography get typography => ResponsiveTypography(this);

  /// Get theme text style with color applied
  TextStyle? textStyle(TextStyle? style, {Color? color, double? opacity}) {
    if (style == null) return null;
    final textColor = color ?? Theme.of(this).colorScheme.onSurface;
    return style.copyWith(
      color: opacity != null ? textColor.withOpacity(opacity) : textColor,
    );
  }
}

/// Premium spacing system
class LusionSpacing {
  /// Micro spacing (4px)
  static const double micro = 4.0;

  /// Extra small spacing (8px)
  static const double xs = 8.0;

  /// Small spacing (12px)
  static const double sm = 12.0;

  /// Medium spacing (16px)
  static const double md = 16.0;

  /// Large spacing (24px)
  static const double lg = 24.0;

  /// Extra large spacing (32px)
  static const double xl = 32.0;

  /// 2X large spacing (48px)
  static const double xxl = 48.0;

  /// 3X large spacing (64px)
  static const double xxxl = 64.0;

  /// Huge spacing (96px)
  static const double huge = 96.0;

  /// Massive spacing (128px)
  static const double massive = 128.0;
}

/// Premium border radius values
class LusionRadius {
  /// No radius
  static const double none = 0.0;

  /// Minimal radius (2px)
  static const double minimal = 2.0;

  /// Small radius (4px)
  static const double sm = 4.0;

  /// Medium radius (8px)
  static const double md = 8.0;

  /// Large radius (12px)
  static const double lg = 12.0;

  /// Extra large radius (16px)
  static const double xl = 16.0;

  /// Full circle
  static const double full = 9999.0;
}

/// Premium elevation/shadow values
class LusionElevation {
  /// No shadow
  static List<BoxShadow> get none => [];

  /// Subtle shadow
  static List<BoxShadow> get subtle => [
    BoxShadow(
      color: LusionColors.textPrimary.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  /// Low shadow
  static List<BoxShadow> get low => [
    BoxShadow(
      color: LusionColors.textPrimary.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  /// Medium shadow
  static List<BoxShadow> get medium => [
    BoxShadow(
      color: LusionColors.textPrimary.withOpacity(0.10),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  /// High shadow
  static List<BoxShadow> get high => [
    BoxShadow(
      color: LusionColors.textPrimary.withOpacity(0.15),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
}


