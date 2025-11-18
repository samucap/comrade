import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import '../core/rive_controller.dart';
import '../models/message.dart';

/// Chat bubble widget for displaying individual messages
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
        left: isUser ? 64 : 16,
        right: isUser ? 16 : 64,
        bottom: 8,
      ),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isUser
                  ? colorScheme.primary.withOpacity(0.8)
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: isUser ? const Radius.circular(18) : const Radius.circular(4),
                bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.content,
                  style: TextStyle(
                    color: isUser
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                if (showTimestamp) ...[
                  const SizedBox(height: 4),
                  Text(
                    message.formattedTime,
                    style: TextStyle(
                      color: isUser
                          ? colorScheme.onPrimary.withOpacity(0.7)
                          : colorScheme.onSurfaceVariant.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!isUser && message.emotion != null) ...[
            const SizedBox(height: 4),
            _buildEmotionIndicator(message.emotion!, colorScheme),
          ],
        ],
      ),
    );

    if (!animate) return bubble;

    // Add entrance animation
    return isUser
        ? SlideInRight(child: bubble)
        : SlideInLeft(child: bubble);
  }

  /// Build emotion indicator for companion messages
  Widget _buildEmotionIndicator(AvatarEmotion emotion, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getEmotionIcon(emotion),
            size: 14,
            color: _getEmotionColor(emotion, colorScheme),
          ),
          const SizedBox(width: 4),
          Text(
            emotion.displayName,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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

  /// Get color for emotion
  Color _getEmotionColor(AvatarEmotion emotion, ColorScheme colorScheme) {
    switch (emotion) {
      case AvatarEmotion.happy:
      case AvatarEmotion.laugh:
        return Colors.green;
      case AvatarEmotion.sad:
        return Colors.blue;
      case AvatarEmotion.angry:
        return Colors.red;
      case AvatarEmotion.smirk:
        return Colors.orange;
      case AvatarEmotion.blush:
        return Colors.pink;
      case AvatarEmotion.shocked:
        return Colors.purple;
      case AvatarEmotion.heartEyes:
        return Colors.red;
      case AvatarEmotion.eyeRoll:
        return Colors.grey;
      case AvatarEmotion.shrug:
        return Colors.brown;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }
}

/// Compact chat bubble for small screens
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
        left: isUser ? 32 : 8,
        right: isUser ? 8 : 32,
        bottom: 4,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isUser
              ? colorScheme.primary.withOpacity(0.9)
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(2),
            bottomRight: isUser ? const Radius.circular(2) : const Radius.circular(16),
          ),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: isUser
                ? colorScheme.onPrimary
                : colorScheme.onSurface,
            fontSize: 14,
            height: 1.3,
          ),
        ),
      ),
    );

    if (!animate) return bubble;

    return isUser
        ? FadeInRight(child: bubble)
        : FadeInLeft(child: bubble);
  }
}

/// Typing indicator for when companion is "thinking"
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({
    super.key,
    this.color,
    this.size = 20,
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
      duration: const Duration(milliseconds: 600),
      vsync: this,
    ));

    _animations = _controllers.map((controller) => Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ))).toList();

    // Start animations with staggered delays
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        _controllers[i].repeat(reverse: true);
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
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) => AnimatedBuilder(
        animation: _animations[index],
        builder: (context, child) {
          return Container(
            width: widget.size / 3,
            height: widget.size / 3,
            margin: EdgeInsets.symmetric(horizontal: widget.size / 6),
            decoration: BoxDecoration(
              color: color.withOpacity(_animations[index].value * 0.8 + 0.2),
              shape: BoxShape.circle,
            ),
          );
        },
      )),
    );
  }
}

/// Chat bubble with typing indicator
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
      margin: const EdgeInsets.only(left: 16, right: 64, bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const TypingIndicator(),
      ),
    );

    if (!animate) return bubble;

    return SlideInLeft(child: bubble);
  }
}

