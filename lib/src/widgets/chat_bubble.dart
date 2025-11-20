import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core/rive_controller.dart';
import '../core/animations.dart';
import '../core/typography.dart';
import '../models/message.dart';

/// Premium minimal chat bubble
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    this.showTimestamp = true,
    this.animate = true,
  });

  final MessageModel message;
  final bool showTimestamp;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUser = message.isFromUser;

    final bubble = Container(
      margin: EdgeInsets.only(
        left: isUser ? LusionSpacing.xxxl : LusionSpacing.md,
        right: isUser ? LusionSpacing.md : LusionSpacing.xxxl,
        bottom: LusionSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: LusionSpacing.lg,
              vertical: LusionSpacing.md,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: colorScheme.onSurface.withOpacity(0.08),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(LusionRadius.sm),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.content,
                  style: LusionTypography.bodyMedium.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.87),
                    height: 1.7,
                  ),
                ),
                if (showTimestamp) ...[
                  SizedBox(height: LusionSpacing.xs),
                  Text(
                    message.formattedTime,
                    style: LusionTypography.labelSmall.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.4),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!isUser && message.emotion != null) ...[
            SizedBox(height: LusionSpacing.xs),
            _buildEmotionIndicator(message.emotion!, colorScheme),
          ],
        ],
      ),
    );

    if (!animate) return bubble;

    // Add elegant entrance animation
    return bubble.slideAndFadeIn(
      delay: Duration(milliseconds: isUser ? 100 : 200),
      begin: Offset(isUser ? 0.02 : -0.02, 0),
    );
  }

  /// Build minimal emotion indicator
  Widget _buildEmotionIndicator(AvatarEmotion emotion, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: LusionSpacing.sm,
        vertical: LusionSpacing.micro,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: colorScheme.onSurface.withOpacity(0.06),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(LusionRadius.minimal),
      ),
      child: Text(
        emotion.displayName.toUpperCase(),
        style: LusionTypography.labelSmall.copyWith(
          color: colorScheme.onSurface.withOpacity(0.4),
          letterSpacing: 1.2,
          fontSize: 10,
        ),
      ),
    );
  }

  /// Get icon for emotion
  IconData _getEmotionIcon(AvatarEmotion emotion) {
    switch (emotion) {
      case AvatarEmotion.happy:
        return Icons.sentiment_satisfied;
      case AvatarEmotion.sad:
        return Icons.sentiment_dissatisfied;
      case AvatarEmotion.angry:
        return Icons.sentiment_very_dissatisfied;
      case AvatarEmotion.smirk:
        return Icons.sentiment_satisfied_alt;
      case AvatarEmotion.laugh:
        return Icons.sentiment_very_satisfied;
      case AvatarEmotion.blush:
        return Icons.face_retouching_natural;
      case AvatarEmotion.shocked:
        return Icons.sentiment_very_dissatisfied;
      case AvatarEmotion.heartEyes:
        return Icons.favorite;
      case AvatarEmotion.eyeRoll:
        return Icons.visibility_off;
      case AvatarEmotion.shrug:
        return Icons.person_outline;
      default:
        return Icons.face;
    }
  }
}

/// Compact premium chat bubble
class CompactChatBubble extends ChatBubble {
  const CompactChatBubble({
    super.key,
    required super.message,
    super.showTimestamp = false,
    super.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUser = message.isFromUser;

    final bubble = Container(
      margin: EdgeInsets.only(
        left: isUser ? LusionSpacing.xl : LusionSpacing.xs,
        right: isUser ? LusionSpacing.xs : LusionSpacing.xl,
        bottom: LusionSpacing.sm,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: LusionSpacing.md,
          vertical: LusionSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: colorScheme.onSurface.withOpacity(0.06),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(LusionRadius.minimal),
        ),
        child: Text(
          message.content,
          style: LusionTypography.bodySmall.copyWith(
            color: colorScheme.onSurface.withOpacity(0.87),
            height: 1.6,
          ),
        ),
      ),
    );

    if (!animate) return bubble;

    return bubble.fadeIn(delay: Duration(milliseconds: isUser ? 100 : 200));
  }
}

/// Premium minimal typing indicator
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({
    super.key,
    this.color,
    this.size = 16,
  });

  final Color? color;
  final double size;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) => AnimationController(
      duration: LusionDurations.medium,
      vsync: this,
    ));

    _animations = _controllers.map((controller) => Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: LusionCurves.smoothEase,
    ))).toList();

    // Start animations with staggered delays
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.onSurface;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) => AnimatedBuilder(
        animation: _animations[index],
        builder: (context, child) {
          return Container(
            width: widget.size / 4,
            height: widget.size / 4,
            margin: EdgeInsets.symmetric(horizontal: widget.size / 8),
            decoration: BoxDecoration(
              color: color.withOpacity(_animations[index].value * 0.6),
              shape: BoxShape.circle,
            ),
          );
        },
      )),
    );
  }
}

/// Premium chat bubble with typing indicator
class TypingChatBubble extends StatelessWidget {
  const TypingChatBubble({
    super.key,
    this.animate = true,
  });

  final bool animate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final bubble = Container(
      margin: EdgeInsets.only(
        left: LusionSpacing.md,
        right: LusionSpacing.xxxl,
        bottom: LusionSpacing.lg,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: LusionSpacing.lg,
          vertical: LusionSpacing.md,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: colorScheme.onSurface.withOpacity(0.08),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(LusionRadius.sm),
        ),
        child: const TypingIndicator(),
      ),
    );

    if (!animate) return bubble;

    return bubble.fadeIn();
  }
}

