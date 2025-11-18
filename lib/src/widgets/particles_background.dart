import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Particle system for background animation
class ParticlesBackground extends HookConsumerWidget {
  const ParticlesBackground({
    super.key,
    this.enabled = true,
    this.particleCount = 50,
    this.maxSpeed = 0.5,
    this.particleSize = 2.0,
  });

  final bool enabled;
  final int particleCount;
  final double maxSpeed;
  final double particleSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!enabled) return const SizedBox.shrink();

    return HookBuilder(
      builder: (context) {
        final particles = useMemoized(() => _generateParticles(particleCount));
        final animationController = useAnimationController(
          duration: const Duration(seconds: 10),
        )..repeat();

        useEffect(() {
          animationController.repeat();
          return null;
        }, []);

        return AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return CustomPaint(
              painter: ParticlesPainter(
                particles: particles,
                animationValue: animationController.value,
                maxSpeed: maxSpeed,
                particleSize: particleSize,
              ),
              size: Size.infinite,
            );
          },
        );
      },
    );
  }

  List<Particle> _generateParticles(int count) {
    final random = Random();
    final particles = <Particle>[];

    for (int i = 0; i < count; i++) {
      particles.add(Particle(
        position: Offset(
          random.nextDouble() * 1000, // Will be scaled in painter
          random.nextDouble() * 2000, // Will be scaled in painter
        ),
        velocity: Offset(
          (random.nextDouble() - 0.5) * maxSpeed,
          (random.nextDouble() - 0.5) * maxSpeed,
        ),
        size: random.nextDouble() * particleSize + 0.5,
        opacity: random.nextDouble() * 0.6 + 0.2,
        color: HSVColor.fromAHSV(
          random.nextDouble() * 0.3 + 0.1, // Low opacity
          random.nextDouble() * 360, // Hue
          0.8, // Saturation
          1.0, // Value
        ).toColor(),
      ));
    }

    return particles;
  }
}

/// Individual particle data
class Particle {
  Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.opacity,
    required this.color,
  });

  final Offset position;
  final Offset velocity;
  final double size;
  final double opacity;
  final Color color;
}

/// Custom painter for rendering particles
class ParticlesPainter extends CustomPainter {
  ParticlesPainter({
    required this.particles,
    required this.animationValue,
    required this.maxSpeed,
    required this.particleSize,
  });

  final List<Particle> particles;
  final double animationValue;
  final double maxSpeed;
  final double particleSize;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // Update particle position based on animation
      final animatedX = (particle.position.dx + particle.velocity.dx * animationValue * 100) % size.width;
      final animatedY = (particle.position.dy + particle.velocity.dy * animationValue * 100) % size.height;

      // Wrap around screen edges
      final wrappedX = animatedX < 0 ? animatedX + size.width : animatedX;
      final wrappedY = animatedY < 0 ? animatedY + size.height : animatedY;

      final position = Offset(wrappedX, wrappedY);

      // Draw particle
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(position, particle.size, paint);

      // Add subtle glow effect
      final glowPaint = Paint()
        ..color = particle.color.withOpacity(particle.opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(position, particle.size * 2, glowPaint);
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) {
    return animationValue != oldDelegate.animationValue ||
           particles != oldDelegate.particles;
  }
}

/// Floating particles with physics simulation
class FloatingParticles extends HookConsumerWidget {
  const FloatingParticles({
    super.key,
    this.enabled = true,
    this.particleCount = 30,
    this.gravity = 0.1,
    this.windStrength = 0.05,
  });

  final bool enabled;
  final int particleCount;
  final double gravity;
  final double windStrength;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!enabled) return const SizedBox.shrink();

    return HookBuilder(
      builder: (context) {
        final particles = useState(_generateFloatingParticles(particleCount));
        final lastUpdate = useRef(DateTime.now());

        useEffect(() {
          final timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
            final now = DateTime.now();
            final deltaTime = now.difference(lastUpdate.value).inMilliseconds / 1000.0;
            lastUpdate.value = now;

            particles.value = _updateParticles(particles.value, deltaTime);
          });

          return timer.cancel;
        }, []);

        return CustomPaint(
          painter: FloatingParticlesPainter(particles: particles.value),
          size: Size.infinite,
        );
      },
    );
  }

  List<FloatingParticle> _generateFloatingParticles(int count) {
    final random = Random();
    final particles = <FloatingParticle>[];

    for (int i = 0; i < count; i++) {
      particles.add(FloatingParticle(
        position: Offset(
          random.nextDouble() * 1000,
          random.nextDouble() * 1000,
        ),
        velocity: Offset(
          (random.nextDouble() - 0.5) * windStrength * 2,
          random.nextDouble() * -0.5, // Start with upward motion
        ),
        size: random.nextDouble() * 3 + 1,
        life: random.nextDouble() * 10 + 5, // 5-15 seconds lifetime
        maxLife: random.nextDouble() * 10 + 5,
      ));
    }

    return particles;
  }

  List<FloatingParticle> _updateParticles(List<FloatingParticle> particles, double deltaTime) {
    final random = Random();
    final updatedParticles = <FloatingParticle>[];

    for (final particle in particles) {
      var newVelocity = particle.velocity;
      var newPosition = particle.position;
      var newLife = particle.life - deltaTime;

      // Apply gravity
      newVelocity = Offset(
        newVelocity.dx + (random.nextDouble() - 0.5) * windStrength * deltaTime,
        newVelocity.dy + gravity * deltaTime,
      );

      // Update position
      newPosition = Offset(
        newPosition.dx + newVelocity.dx,
        newPosition.dy + newVelocity.dy,
      );

      // Reset particle if it goes off screen or dies
      if (newLife <= 0 || newPosition.dy > 2000) {
        newPosition = Offset(random.nextDouble() * 1000, -10);
        newVelocity = Offset(
          (random.nextDouble() - 0.5) * windStrength * 2,
          random.nextDouble() * -0.5,
        );
        newLife = random.nextDouble() * 10 + 5;
      }

      updatedParticles.add(FloatingParticle(
        position: newPosition,
        velocity: newVelocity,
        size: particle.size,
        life: newLife,
        maxLife: particle.maxLife,
      ));
    }

    return updatedParticles;
  }
}

/// Floating particle with physics
class FloatingParticle {
  const FloatingParticle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.life,
    required this.maxLife,
  });

  final Offset position;
  final Offset velocity;
  final double size;
  final double life;
  final double maxLife;

  double get opacity => (life / maxLife).clamp(0.0, 1.0);
}

/// Painter for floating particles
class FloatingParticlesPainter extends CustomPainter {
  const FloatingParticlesPainter({required this.particles});

  final List<FloatingParticle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final screenPosition = Offset(
        particle.position.dx % size.width,
        particle.position.dy % size.height,
      );

      final paint = Paint()
        ..color = Colors.white.withOpacity(particle.opacity * 0.6)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(screenPosition, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(FloatingParticlesPainter oldDelegate) {
    return particles != oldDelegate.particles;
  }
}

