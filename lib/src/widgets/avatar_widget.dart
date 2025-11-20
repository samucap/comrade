import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rive/rive.dart' hide LinearGradient;

import '../core/rive_controller.dart';
import '../core/animations.dart';
import '../core/typography.dart';
import '../providers/avatar_state_provider.dart';
import '../providers/theme_provider.dart';

/// Premium avatar widget with parallax and smooth transitions
class AvatarWidget extends HookConsumerWidget {
  const AvatarWidget({
    super.key,
    this.width,
    this.height,
    this.scrollController,
  });

  final double? width;
  final double? height;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(
      duration: LusionDurations.medium,
    );
    
    final bounceController = useAnimationController(
      duration: LusionDurations.quick,
    );

    // Handle pull-down gesture for personality switching AND tap for animation
    return GestureDetector(
      onTap: () {
        // Trigger random emotion animation on tap
        HapticFeedback.lightImpact();
        ref.read(avatarStateNotifierProvider.notifier).triggerRandomEmotion();
        bounceController.forward(from: 0).then((_) => bounceController.reverse());
      },
      onVerticalDragEnd: (details) {
        // Detect pull-down gesture (negative velocity = downward)
        if (details.primaryVelocity != null && details.primaryVelocity! < -500) {
          HapticFeedback.mediumImpact();
          ref.read(themeNotifierProvider.notifier).switchPersonality();
          animationController.forward(from: 0);
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([animationController, bounceController]),
        builder: (context, child) {
          // Combine theme switch scale with bounce scale
          final themeScale = 1.0 - (animationController.value * 0.05);
          final bounceScale = 1.0 + (bounceController.value * 0.1);
          
          return Transform.scale(
            scale: themeScale * bounceScale,
            child: SizedBox(
              width: width ?? MediaQuery.of(context).size.width * 0.65,
              height: height ?? MediaQuery.of(context).size.height * 0.65,
              child: _buildPremiumAvatar(context, ref),
            ),
          );
        },
      ),
    );
  }

  /// Build a premium minimalist avatar
  Widget _buildPremiumAvatar(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final avatarEmotion = ref.watch(currentAvatarEmotionProvider);
        final colorScheme = Theme.of(context).colorScheme;

        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.onSurface.withOpacity(0.08),
              width: 2,
            ),
            color: Colors.transparent,
            boxShadow: LusionElevation.medium,
          ),
          child: Center(
            child: Icon(
              _getEmotionIcon(avatarEmotion),
              size: 80,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
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

