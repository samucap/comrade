import 'package:flutter/material.dart';
import '../core/animations.dart';

/// Scroll-based reveal animation widget
class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOut,
    this.offset = 100.0,
    this.fadeIn = true,
    this.slideIn = true,
    this.scaleIn = false,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final double offset;
  final bool fadeIn;
  final bool slideIn;
  final bool scaleIn;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: widget.fadeIn ? 0.0 : 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: widget.slideIn ? const Offset(0, 0.05) : Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _scaleAnimation = Tween<double>(
      begin: widget.scaleIn ? 0.95 : 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // Start animation after delay
    if (widget.delay == Duration.zero) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _checkVisibility();
      });
    }
  }

  void _checkVisibility() {
    if (_hasAnimated) return;

    // Trigger animation
    _hasAnimated = true;
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget result = widget.child;

    if (widget.scaleIn) {
      result = ScaleTransition(
        scale: _scaleAnimation,
        child: result,
      );
    }

    if (widget.slideIn) {
      result = SlideTransition(
        position: _slideAnimation,
        child: result,
      );
    }

    if (widget.fadeIn) {
      result = FadeTransition(
        opacity: _fadeAnimation,
        child: result,
      );
    }

    return result;
  }
}

/// Staggered scroll reveal for multiple children
class StaggeredScrollReveal extends StatelessWidget {
  const StaggeredScrollReveal({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 80),
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOut,
  });

  final List<Widget> children;
  final Duration staggerDelay;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        children.length,
        (index) => ScrollReveal(
          delay: staggerDelay * index,
          duration: duration,
          curve: curve,
          child: children[index],
        ),
      ),
    );
  }
}

/// Scroll-triggered animation based on viewport position
class ScrollTriggeredAnimation extends StatefulWidget {
  const ScrollTriggeredAnimation({
    super.key,
    required this.child,
    required this.scrollController,
    this.triggerOffset = 0.8,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOut,
  });

  final Widget child;
  final ScrollController scrollController;
  final double triggerOffset;
  final Duration duration;
  final Curve curve;

  @override
  State<ScrollTriggeredAnimation> createState() =>
      _ScrollTriggeredAnimationState();
}

class _ScrollTriggeredAnimationState extends State<ScrollTriggeredAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    widget.scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkTrigger());
  }

  void _onScroll() {
    _checkTrigger();
  }

  void _checkTrigger() {
    if (_hasTriggered) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    if (position.dy < screenHeight * widget.triggerOffset) {
      _hasTriggered = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ).animate(_animation),
        child: widget.child,
      ),
    );
  }
}

/// Scroll-based opacity transition
class ScrollOpacity extends StatefulWidget {
  const ScrollOpacity({
    super.key,
    required this.child,
    required this.scrollController,
    this.startOpacity = 1.0,
    this.endOpacity = 0.0,
    this.startOffset = 0.0,
    this.endOffset = 200.0,
  });

  final Widget child;
  final ScrollController scrollController;
  final double startOpacity;
  final double endOpacity;
  final double startOffset;
  final double endOffset;

  @override
  State<ScrollOpacity> createState() => _ScrollOpacityState();
}

class _ScrollOpacityState extends State<ScrollOpacity> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _opacity = widget.startOpacity;
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;

    final offset = widget.scrollController.offset;
    final progress = ((offset - widget.startOffset) /
            (widget.endOffset - widget.startOffset))
        .clamp(0.0, 1.0);

    final newOpacity = widget.startOpacity +
        (widget.endOpacity - widget.startOpacity) * progress;

    if (newOpacity != _opacity) {
      setState(() {
        _opacity = newOpacity;
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
    return Opacity(
      opacity: _opacity,
      child: widget.child,
    );
  }
}

/// Scroll-based scale transition
class ScrollScale extends StatefulWidget {
  const ScrollScale({
    super.key,
    required this.child,
    required this.scrollController,
    this.startScale = 1.0,
    this.endScale = 0.95,
    this.startOffset = 0.0,
    this.endOffset = 200.0,
  });

  final Widget child;
  final ScrollController scrollController;
  final double startScale;
  final double endScale;
  final double startOffset;
  final double endOffset;

  @override
  State<ScrollScale> createState() => _ScrollScaleState();
}

class _ScrollScaleState extends State<ScrollScale> {
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _scale = widget.startScale;
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;

    final offset = widget.scrollController.offset;
    final progress = ((offset - widget.startOffset) /
            (widget.endOffset - widget.startOffset))
        .clamp(0.0, 1.0);

    final newScale =
        widget.startScale + (widget.endScale - widget.startScale) * progress;

    if (newScale != _scale) {
      setState(() {
        _scale = newScale;
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
    return Transform.scale(
      scale: _scale,
      child: widget.child,
    );
  }
}


