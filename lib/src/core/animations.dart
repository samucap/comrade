import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Premium animation curves inspired by Lusion.co
class LusionCurves {
  /// Smooth elastic out curve for premium feel
  static const Curve elasticOut = ElasticOutCurve(0.8);

  /// Custom expo out curve
  static const Curve expoOut = ExpoOutCurve();

  /// Custom expo in-out curve
  static const Curve expoInOut = ExpoInOutCurve();

  /// Smooth ease for subtle transitions
  static const Curve smoothEase = Cubic(0.4, 0.0, 0.2, 1.0);

  /// Premium ease out
  static const Curve premiumEase = Cubic(0.25, 0.46, 0.45, 0.94);

  /// Gentle ease for background elements
  static const Curve gentleEase = Cubic(0.33, 0.0, 0.67, 1.0);
}

/// Elastic out curve implementation
class ElasticOutCurve extends Curve {
  const ElasticOutCurve([this.period = 0.4]);

  final double period;

  @override
  double transform(double t) {
    if (t == 0.0 || t == 1.0) return t;
    return math.pow(2.0, -10.0 * t) * math.sin((t - period / 4.0) * (2.0 * math.pi) / period) + 1.0;
  }
}

/// Expo out curve implementation
class ExpoOutCurve extends Curve {
  const ExpoOutCurve();

  @override
  double transform(double t) {
    return t == 1.0 ? t : 1.0 - math.pow(2.0, -10.0 * t);
  }
}

/// Expo in-out curve implementation
class ExpoInOutCurve extends Curve {
  const ExpoInOutCurve();

  @override
  double transform(double t) {
    if (t == 0.0 || t == 1.0) return t;
    if (t < 0.5) {
      return math.pow(2.0, 20.0 * t - 10.0) / 2.0;
    }
    return (2.0 - math.pow(2.0, -20.0 * t + 10.0)) / 2.0;
  }
}

/// Premium animation durations
class LusionDurations {
  /// Quick micro-interactions (300ms)
  static const Duration quick = Duration(milliseconds: 300);

  /// Medium transitions (600ms)
  static const Duration medium = Duration(milliseconds: 600);

  /// Slow elegant animations (900ms)
  static const Duration slow = Duration(milliseconds: 900);

  /// Very slow for hero transitions (1200ms)
  static const Duration extraSlow = Duration(milliseconds: 1200);

  /// Instant for immediate feedback (100ms)
  static const Duration instant = Duration(milliseconds: 100);
}

/// Scroll-based animation controller for parallax and reveal effects
class ScrollAnimationController {
  ScrollAnimationController({
    required this.scrollController,
    this.maxScroll = 1000.0,
  }) {
    scrollController.addListener(_onScroll);
  }

  final ScrollController scrollController;
  final double maxScroll;
  final List<VoidCallback> _listeners = [];

  double _scrollProgress = 0.0;
  
  /// Current scroll progress (0.0 to 1.0)
  double get progress => _scrollProgress;

  /// Current scroll offset
  double get offset => scrollController.hasClients ? scrollController.offset : 0.0;

  void _onScroll() {
    if (!scrollController.hasClients) return;
    
    final newProgress = (scrollController.offset / maxScroll).clamp(0.0, 1.0);
    if (newProgress != _scrollProgress) {
      _scrollProgress = newProgress;
      _notifyListeners();
    }
  }

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  void dispose() {
    scrollController.removeListener(_onScroll);
    _listeners.clear();
  }
}

/// Parallax animation configuration
class ParallaxConfig {
  const ParallaxConfig({
    this.speed = 0.5,
    this.direction = ParallaxDirection.vertical,
    this.min = -100.0,
    this.max = 100.0,
  });

  final double speed;
  final ParallaxDirection direction;
  final double min;
  final double max;
}

enum ParallaxDirection {
  vertical,
  horizontal,
}

/// Calculate parallax offset based on scroll progress
double calculateParallaxOffset({
  required double scrollProgress,
  required ParallaxConfig config,
}) {
  final offset = scrollProgress * config.speed * 100;
  return offset.clamp(config.min, config.max);
}

/// Stagger animation helper
class StaggerAnimation {
  StaggerAnimation({
    required this.controller,
    required int itemCount,
    Duration delay = const Duration(milliseconds: 50),
    Curve curve = Curves.easeOut,
  }) {
    final delayValue = delay.inMilliseconds / controller.duration!.inMilliseconds;
    final itemDelay = delayValue / itemCount;

    animations = List.generate(
      itemCount,
      (index) {
        final start = itemDelay * index;
        final end = (start + (1.0 - delayValue)).clamp(0.0, 1.0);
        
        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(start, end, curve: curve),
          ),
        );
      },
    );
  }

  final AnimationController controller;
  late final List<Animation<double>> animations;

  Animation<double> operator [](int index) => animations[index];

  int get length => animations.length;
}

/// Fade and scale reveal animation
class RevealAnimation {
  RevealAnimation({
    required AnimationController controller,
    Curve curve = Curves.easeOut,
    double beginScale = 0.95,
    double endScale = 1.0,
  }) : 
    opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: curve),
    ),
    scale = Tween<double>(begin: beginScale, end: endScale).animate(
      CurvedAnimation(parent: controller, curve: curve),
    ),
    slide = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );

  final Animation<double> opacity;
  final Animation<double> scale;
  final Animation<Offset> slide;
}

/// Premium fade transition builder
class PremiumFadeTransition extends StatelessWidget {
  const PremiumFadeTransition({
    super.key,
    required this.animation,
    required this.child,
    this.withScale = true,
    this.withSlide = false,
  });

  final Animation<double> animation;
  final Widget child;
  final bool withScale;
  final bool withSlide;

  @override
  Widget build(BuildContext context) {
    Widget result = FadeTransition(
      opacity: animation,
      child: child,
    );

    if (withScale) {
      final scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: LusionCurves.smoothEase),
      );
      result = ScaleTransition(scale: scaleAnimation, child: result);
    }

    if (withSlide) {
      final slideAnimation = Tween<Offset>(
        begin: const Offset(0, 0.05),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: animation, curve: LusionCurves.smoothEase),
      );
      result = SlideTransition(position: slideAnimation, child: result);
    }

    return result;
  }
}

/// Page transition builder for premium navigation
class PremiumPageTransition extends PageRouteBuilder {
  PremiumPageTransition({
    required this.child,
    RouteSettings? settings,
  }) : super(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionDuration: LusionDurations.medium,
    reverseTransitionDuration: LusionDurations.medium,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: LusionCurves.smoothEase,
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.02),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: LusionCurves.smoothEase,
            ),
          ),
          child: child,
        ),
      );
    },
  );

  final Widget child;
}

/// Animation extensions for convenient usage
extension AnimationControllerX on AnimationController {
  /// Forward with premium curve
  Future<void> forwardPremium() {
    return forward();
  }

  /// Reverse with premium curve
  Future<void> reversePremium() {
    return reverse();
  }
}

/// Widget extensions for easy animation
extension WidgetAnimationX on Widget {
  /// Wrap with fade in animation
  Widget fadeIn({
    Duration duration = const Duration(milliseconds: 600),
    Duration delay = Duration.zero,
    Curve curve = Curves.easeOut,
  }) {
    return _FadeInWrapper(
      duration: duration,
      delay: delay,
      curve: curve,
      child: this,
    );
  }

  /// Wrap with slide and fade animation
  Widget slideAndFadeIn({
    Duration duration = const Duration(milliseconds: 600),
    Duration delay = Duration.zero,
    Offset begin = const Offset(0, 0.05),
  }) {
    return _SlideAndFadeWrapper(
      duration: duration,
      delay: delay,
      begin: begin,
      child: this,
    );
  }
}

class _FadeInWrapper extends StatefulWidget {
  const _FadeInWrapper({
    required this.child,
    required this.duration,
    required this.delay,
    required this.curve,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;

  @override
  State<_FadeInWrapper> createState() => _FadeInWrapperState();
}

class _FadeInWrapperState extends State<_FadeInWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

class _SlideAndFadeWrapper extends StatefulWidget {
  const _SlideAndFadeWrapper({
    required this.child,
    required this.duration,
    required this.delay,
    required this.begin,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset begin;

  @override
  State<_SlideAndFadeWrapper> createState() => _SlideAndFadeWrapperState();
}

class _SlideAndFadeWrapperState extends State<_SlideAndFadeWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: LusionCurves.smoothEase,
    );
    _slideAnimation = Tween<Offset>(
      begin: widget.begin,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: LusionCurves.smoothEase,
    ));
    
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}


