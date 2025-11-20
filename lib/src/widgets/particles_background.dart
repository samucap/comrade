import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Premium minimal background inspired by Lusion.co aesthetic
class PremiumBackground extends StatelessWidget {
  const PremiumBackground({
    super.key,
    this.isDark = false,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Stack(
      children: [
        // Base color
        Container(
          color: colorScheme.surface,
        ),
        
        // Subtle radial gradient
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.5,
              colors: [
                colorScheme.onSurface.withOpacity(0.015),
                colorScheme.surface,
              ],
            ),
          ),
        ),
        
        // Ambient gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorScheme.surface,
                colorScheme.onSurface.withOpacity(0.01),
                colorScheme.surface,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        
        // Subtle noise texture overlay
        CustomPaint(
          painter: NoiseTexturePainter(
            color: colorScheme.onSurface,
            opacity: 0.02,
          ),
          size: Size.infinite,
        ),
      ],
    );
  }
}

/// Noise texture painter for premium texture effect
class NoiseTexturePainter extends CustomPainter {
  NoiseTexturePainter({
    required this.color,
    this.opacity = 0.02,
  });

  final Color color;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = 1;

    final random = math.Random(42); // Fixed seed for consistency
    
    // Draw subtle noise pattern
    for (var i = 0; i < size.width * size.height / 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), 0.5, paint);
    }
  }

  @override
  bool shouldRepaint(NoiseTexturePainter oldDelegate) =>
      color != oldDelegate.color || opacity != oldDelegate.opacity;
}

/// Minimal gradient background
class MinimalGradientBackground extends StatelessWidget {
  const MinimalGradientBackground({
    super.key,
    this.colors,
  });

  final List<Color>? colors;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors ?? [
            colorScheme.surface,
            colorScheme.surface.withOpacity(0.95),
            colorScheme.onSurface.withOpacity(0.02),
          ],
        ),
      ),
    );
  }
}

/// Elegant mesh gradient background
class MeshGradientBackground extends StatelessWidget {
  const MeshGradientBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return CustomPaint(
      painter: MeshGradientPainter(
        baseColor: colorScheme.surface,
        accentColor: colorScheme.onSurface,
      ),
      size: Size.infinite,
    );
  }
}

/// Mesh gradient painter for sophisticated background
class MeshGradientPainter extends CustomPainter {
  MeshGradientPainter({
    required this.baseColor,
    required this.accentColor,
  });

  final Color baseColor;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Base layer
    canvas.drawRect(rect, Paint()..color = baseColor);
    
    // Radial gradients for mesh effect
    _createRadialGradient(
      center: Offset(size.width * 0.2, size.height * 0.3),
      radius: size.width * 0.5,
      canvas: canvas,
    );
    _createRadialGradient(
      center: Offset(size.width * 0.8, size.height * 0.6),
      radius: size.width * 0.4,
      canvas: canvas,
    );
    _createRadialGradient(
      center: Offset(size.width * 0.5, size.height * 0.9),
      radius: size.width * 0.3,
      canvas: canvas,
    );
  }

  void _createRadialGradient({
    required Offset center,
    required double radius,
    required Canvas canvas,
  }) {
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: [
        accentColor.withOpacity(0.03),
        accentColor.withOpacity(0.0),
      ],
    );
    
    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );
    
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(MeshGradientPainter oldDelegate) =>
      baseColor != oldDelegate.baseColor || accentColor != oldDelegate.accentColor;
}

/// Animated subtle background with breathing effect
class AnimatedPremiumBackground extends StatefulWidget {
  const AnimatedPremiumBackground({
    super.key,
  });

  @override
  State<AnimatedPremiumBackground> createState() => _AnimatedPremiumBackgroundState();
}

class _AnimatedPremiumBackgroundState extends State<AnimatedPremiumBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: BreathingBackgroundPainter(
            progress: _controller.value,
            baseColor: Theme.of(context).colorScheme.surface,
            accentColor: Theme.of(context).colorScheme.onSurface,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class BreathingBackgroundPainter extends CustomPainter {
  BreathingBackgroundPainter({
    required this.progress,
    required this.baseColor,
    required this.accentColor,
  });

  final double progress;
  final Color baseColor;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, Paint()..color = baseColor);

    // Animated radial gradient
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final radius = size.width * (0.6 + progress * 0.2);

    final gradient = RadialGradient(
      colors: [
        accentColor.withOpacity(0.01 + progress * 0.01),
        accentColor.withOpacity(0.0),
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(BreathingBackgroundPainter oldDelegate) =>
      progress != oldDelegate.progress;
}

// Legacy aliases for backwards compatibility
typedef ParticlesBackground = PremiumBackground;
