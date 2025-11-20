import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Parallax layer widget for depth effect
class ParallaxLayer extends StatefulWidget {
  const ParallaxLayer({
    super.key,
    required this.child,
    required this.scrollController,
    this.speed = 0.5,
    this.direction = ParallaxDirection.vertical,
    this.enabled = true,
  });

  final Widget child;
  final ScrollController scrollController;
  final double speed;
  final ParallaxDirection direction;
  final bool enabled;

  @override
  State<ParallaxLayer> createState() => _ParallaxLayerState();
}

class _ParallaxLayerState extends State<ParallaxLayer> {
  double _offset = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      widget.scrollController.addListener(_onScroll);
    }
  }

  void _onScroll() {
    if (!mounted || !widget.enabled) return;

    final scrollOffset = widget.scrollController.offset;
    final newOffset = scrollOffset * widget.speed;

    if (newOffset != _offset) {
      setState(() {
        _offset = newOffset;
      });
    }
  }

  @override
  void dispose() {
    if (widget.enabled) {
      widget.scrollController.removeListener(_onScroll);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return Transform.translate(
      offset: widget.direction == ParallaxDirection.vertical
          ? Offset(0, -_offset)
          : Offset(-_offset, 0),
      child: widget.child,
    );
  }
}

enum ParallaxDirection {
  vertical,
  horizontal,
}

/// Multi-layer parallax container
class ParallaxContainer extends StatelessWidget {
  const ParallaxContainer({
    super.key,
    required this.scrollController,
    required this.layers,
  });

  final ScrollController scrollController;
  final List<ParallaxLayerConfig> layers;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: layers.map((config) {
        return ParallaxLayer(
          scrollController: scrollController,
          speed: config.speed,
          direction: config.direction,
          child: config.child,
        );
      }).toList(),
    );
  }
}

class ParallaxLayerConfig {
  const ParallaxLayerConfig({
    required this.child,
    this.speed = 0.5,
    this.direction = ParallaxDirection.vertical,
  });

  final Widget child;
  final double speed;
  final ParallaxDirection direction;
}

/// Parallax background with gradient
class ParallaxBackground extends StatefulWidget {
  const ParallaxBackground({
    super.key,
    required this.scrollController,
    this.gradient,
    this.speed = 0.3,
  });

  final ScrollController scrollController;
  final Gradient? gradient;
  final double speed;

  @override
  State<ParallaxBackground> createState() => _ParallaxBackgroundState();
}

class _ParallaxBackgroundState extends State<ParallaxBackground> {
  double _offset = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;

    final scrollOffset = widget.scrollController.offset;
    final newOffset = scrollOffset * widget.speed;

    if (newOffset != _offset) {
      setState(() {
        _offset = newOffset;
      });
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -_offset),
      child: Container(
        height: MediaQuery.of(context).size.height * 1.5,
        decoration: BoxDecoration(
          gradient: widget.gradient ??
              LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surface.withOpacity(0.8),
                ],
              ),
        ),
      ),
    );
  }
}

/// Parallax image with zoom effect
class ParallaxImage extends StatefulWidget {
  const ParallaxImage({
    super.key,
    required this.scrollController,
    required this.imagePath,
    this.speed = 0.5,
    this.fit = BoxFit.cover,
  });

  final ScrollController scrollController;
  final String imagePath;
  final double speed;
  final BoxFit fit;

  @override
  State<ParallaxImage> createState() => _ParallaxImageState();
}

class _ParallaxImageState extends State<ParallaxImage> {
  double _offset = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;

    final scrollOffset = widget.scrollController.offset;
    final newOffset = scrollOffset * widget.speed;

    if (newOffset != _offset) {
      setState(() {
        _offset = newOffset;
      });
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -_offset),
      child: Image.asset(
        widget.imagePath,
        fit: widget.fit,
        height: MediaQuery.of(context).size.height * 1.5,
        width: double.infinity,
      ),
    );
  }
}

/// Mouse-based parallax effect (for web/desktop)
class MouseParallax extends StatefulWidget {
  const MouseParallax({
    super.key,
    required this.child,
    this.intensity = 20.0,
  });

  final Widget child;
  final double intensity;

  @override
  State<MouseParallax> createState() => _MouseParallaxState();
}

class _MouseParallaxState extends State<MouseParallax> {
  Offset _offset = Offset.zero;

  void _onPointerMove(PointerEvent details) {
    final size = MediaQuery.of(context).size;
    final center = Offset(size.width / 2, size.height / 2);
    final position = details.position;

    final dx = (position.dx - center.dx) / center.dx * widget.intensity;
    final dy = (position.dy - center.dy) / center.dy * widget.intensity;

    setState(() {
      _offset = Offset(dx, dy);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onPointerMove,
      child: Transform.translate(
        offset: _offset,
        child: widget.child,
      ),
    );
  }
}

/// Scroll-based rotation effect
class ParallaxRotation extends StatefulWidget {
  const ParallaxRotation({
    super.key,
    required this.child,
    required this.scrollController,
    this.maxRotation = 0.1,
    this.axis = Axis.horizontal,
  });

  final Widget child;
  final ScrollController scrollController;
  final double maxRotation;
  final Axis axis;

  @override
  State<ParallaxRotation> createState() => _ParallaxRotationState();
}

class _ParallaxRotationState extends State<ParallaxRotation> {
  double _rotation = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;

    final scrollOffset = widget.scrollController.offset;
    final progress = (scrollOffset / 1000).clamp(0.0, 1.0);
    final newRotation = progress * widget.maxRotation;

    if (newRotation != _rotation) {
      setState(() {
        _rotation = newRotation;
      });
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(widget.axis == Axis.vertical ? _rotation : 0)
        ..rotateY(widget.axis == Axis.horizontal ? _rotation : 0),
      alignment: Alignment.center,
      child: widget.child,
    );
  }
}


