import 'dart:math';

import 'package:flutter/material.dart';

/// Custom painter for rendering audio waveform visualization
class WaveformPainter extends CustomPainter {
  WaveformPainter({
    required this.waveformData,
    required this.color,
    this.strokeWidth = 2.0,
    this.isReversed = false,
    this.maxAmplitude = 1.0,
  });

  final List<double> waveformData;
  final Color color;
  final double strokeWidth;
  final bool isReversed;
  final double maxAmplitude;

  @override
  void paint(Canvas canvas, Size size) {
    if (waveformData.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final centerY = size.height / 2;
    final stepX = size.width / max(1, waveformData.length - 1);

    final path = Path();

    for (int i = 0; i < waveformData.length; i++) {
      final x = i * stepX;
      final amplitude = waveformData[i] * maxAmplitude;
      final height = amplitude * centerY;

      // Create symmetric waveform (mirrored around center)
      final topY = centerY - height;
      final bottomY = centerY + height;

      if (isReversed) {
        // For playback visualization (mirrored)
        if (i == 0) {
          path.moveTo(x, centerY - height);
        } else {
          path.lineTo(x, centerY - height);
        }
        path.lineTo(x, centerY + height);
      } else {
        // For recording visualization
        if (i == 0) {
          path.moveTo(x, centerY);
          path.lineTo(x, centerY - height);
        } else {
          path.lineTo(x, centerY - height);
        }
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return waveformData != oldDelegate.waveformData ||
           color != oldDelegate.color ||
           strokeWidth != oldDelegate.strokeWidth ||
           isReversed != oldDelegate.isReversed ||
           maxAmplitude != oldDelegate.maxAmplitude;
  }
}

/// Animated waveform widget
class AnimatedWaveform extends StatefulWidget {
  const AnimatedWaveform({
    super.key,
    required this.waveformData,
    this.color,
    this.strokeWidth = 2.0,
    this.isReversed = false,
    this.maxAmplitude = 1.0,
    this.duration = const Duration(milliseconds: 300),
  });

  final List<double> waveformData;
  final Color? color;
  final double strokeWidth;
  final bool isReversed;
  final double maxAmplitude;
  final Duration duration;

  @override
  State<AnimatedWaveform> createState() => _AnimatedWaveformState();
}

class _AnimatedWaveformState extends State<AnimatedWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(AnimatedWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.waveformData != oldWidget.waveformData) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: WaveformPainter(
            waveformData: widget.waveformData,
            color: color.withOpacity(_animation.value),
            strokeWidth: widget.strokeWidth,
            isReversed: widget.isReversed,
            maxAmplitude: widget.maxAmplitude * _animation.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

/// Live waveform widget that updates in real-time
class LiveWaveform extends StatelessWidget {
  const LiveWaveform({
    super.key,
    required this.waveformData,
    this.color,
    this.strokeWidth = 2.0,
    this.height = 40.0,
    this.isReversed = false,
  });

  final List<double> waveformData;
  final Color? color;
  final double strokeWidth;
  final double height;
  final bool isReversed;

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: WaveformPainter(
          waveformData: waveformData,
          color: themeColor,
          strokeWidth: strokeWidth,
          isReversed: isReversed,
          maxAmplitude: height / 2,
        ),
      ),
    );
  }
}

/// Pulsing waveform effect for recording state
class PulsingWaveform extends StatefulWidget {
  const PulsingWaveform({
    super.key,
    required this.waveformData,
    this.color,
    this.strokeWidth = 2.0,
    this.height = 40.0,
    this.pulseDuration = const Duration(milliseconds: 1000),
  });

  final List<double> waveformData;
  final Color? color;
  final double strokeWidth;
  final double height;
  final Duration pulseDuration;

  @override
  State<PulsingWaveform> createState() => _PulsingWaveformState();
}

class _PulsingWaveformState extends State<PulsingWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: widget.pulseDuration,
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.color ?? Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: WaveformPainter(
              waveformData: widget.waveformData,
              color: themeColor.withOpacity(_pulseAnimation.value),
              strokeWidth: widget.strokeWidth,
              maxAmplitude: widget.height / 2,
            ),
          );
        },
      ),
    );
  }
}

