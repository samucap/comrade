import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rive/rive.dart' hide LinearGradient;

import '../core/rive_controller.dart';
import '../providers/avatar_state_provider.dart';
import '../providers/theme_provider.dart';

/// Avatar widget that displays the Rive character with emotion states
class AvatarWidget extends HookConsumerWidget {
  const AvatarWidget({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Handle pull-down gesture for personality switching
    return GestureDetector(
      onVerticalDragEnd: (details) {
        // Detect pull-down gesture (negative velocity = downward)
        if (details.primaryVelocity != null && details.primaryVelocity! < -500) {
          // Switch personality on pull-down
          ref.read(themeNotifierProvider.notifier).switchPersonality();
        }
      },
      child: SizedBox(
        width: width ?? MediaQuery.of(context).size.width * 0.65,
        height: height ?? MediaQuery.of(context).size.height * 0.65,
        child: _buildPlaceholderAvatar(),
      ),
    );
  }

  /// Build a placeholder avatar when Rive file is not available or loading
  Widget _buildPlaceholderAvatar() {
    return Consumer(
      builder: (context, ref, child) {
        final avatarEmotion = ref.watch(currentAvatarEmotionProvider);
        final colorScheme = Theme.of(context).colorScheme;

        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6366F1), // Indigo with opacity will be applied at runtime
                Color(0xFF8B5CF6), // Purple with opacity will be applied at runtime
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(
            _getEmotionIcon(avatarEmotion),
            size: 80,
            color: colorScheme.onPrimary,
          ),
        );
      },
    );
  }

  /// Get appropriate icon for the current emotion
  IconData _getEmotionIcon(AvatarEmotion emotion) {
    switch (emotion) {
      case AvatarEmotion.idle:
        return Icons.face;
      case AvatarEmotion.listening:
        return Icons.hearing;
      case AvatarEmotion.speaking:
        return Icons.mic;
      case AvatarEmotion.thinking:
        return Icons.psychology;
      case AvatarEmotion.happy:
        return Icons.sentiment_satisfied;
      case AvatarEmotion.laugh:
        return Icons.sentiment_very_satisfied;
      case AvatarEmotion.smirk:
        return Icons.sentiment_satisfied_alt;
      case AvatarEmotion.blush:
        return Icons.face_retouching_natural;
      case AvatarEmotion.sad:
        return Icons.sentiment_dissatisfied;
      case AvatarEmotion.angry:
        return Icons.sentiment_very_dissatisfied;
      case AvatarEmotion.shocked:
        return Icons.sentiment_very_dissatisfied;
      case AvatarEmotion.heartEyes:
        return Icons.favorite;
      case AvatarEmotion.eyeRoll:
        return Icons.visibility_off;
      case AvatarEmotion.shrug:
        return Icons.person_outline;
    }
  }
}

/// Hook for managing Rive avatar controller lifecycle
RiveAvatarController useAvatarController() {
  return useMemoized(() {
    // Create controllers - these will be properly initialized when Rive loads
    final animationController = SimpleAnimation('idle');
    final stateMachineController = StateMachineController.fromArtboard(
      Artboard(),
      'avatar_state_machine',
    );

    return RiveAvatarController(
      animationController: animationController,
      stateMachineController: stateMachineController!,
    );
  });
}

/// Extension methods for avatar widget
extension AvatarWidgetExtensions on AvatarWidget {
  /// Create a compact version of the avatar
  AvatarWidget compact() {
    return AvatarWidget(
      width: 120,
      height: 120,
      key: key,
    );
  }

  /// Create a full-screen version of the avatar
  AvatarWidget fullscreen() {
    return AvatarWidget(
      width: double.infinity,
      height: double.infinity,
      key: key,
    );
  }
}

