import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/rive_controller.dart';
import '../core/avatar_animator.dart';

part 'avatar_state_provider.g.dart';

/// Provider for managing the current avatar emotion state
@riverpod
class AvatarStateNotifier extends _$AvatarStateNotifier {
  late final AvatarAnimator _animator;
  
  @override
  AvatarEmotion build() {
    _animator = AvatarAnimator();
    return AvatarEmotion.idle;
  }

  /// Set the current emotion
  void setEmotion(AvatarEmotion emotion) {
    _animator.setCurrentEmotion(emotion);
    state = emotion;
  }

  /// Trigger an emotion temporarily (auto-resets to idle)
  void triggerEmotion(AvatarEmotion emotion, {Duration? duration}) {
    final animDuration = duration ?? _animator.getDuration(emotion);
    setEmotion(emotion);

    // Auto-reset to idle for temporary emotions
    if (emotion.isTemporary) {
      Future.delayed(animDuration, () {
        if (state == emotion) {
          setEmotion(AvatarEmotion.idle);
        }
      });
    }
  }

  /// Trigger a random emotion animation
  void triggerRandomEmotion() {
    final emotion = _animator.getRandomEmotion();
    triggerEmotion(emotion);
  }

  /// Trigger a specific emotion with proper animation timing
  void triggerSpecificEmotion(AvatarEmotion emotion) {
    triggerEmotion(emotion);
  }

  /// Reset to idle state
  void resetToIdle() {
    setEmotion(AvatarEmotion.idle);
  }

  /// Check if currently in a specific emotion
  bool isInEmotion(AvatarEmotion emotion) => state == emotion;

  /// Check if currently idle
  bool get isIdle => state == AvatarEmotion.idle;

  /// Check if currently listening
  bool get isListening => state == AvatarEmotion.listening;

  /// Check if currently speaking
  bool get isSpeaking => state == AvatarEmotion.speaking;

  /// Check if currently thinking
  bool get isThinking => state == AvatarEmotion.thinking;
}

/// Provider that returns the current emotion
@riverpod
AvatarEmotion currentAvatarEmotion(Ref ref) {
  return ref.watch(avatarStateNotifierProvider);
}

/// Provider for avatar emotion stream (reactive updates)
@riverpod
Stream<AvatarEmotion> avatarEmotionStream(Ref ref) {
  return ref.watch(avatarStateNotifierProvider.select((state) => Stream.value(state)));
}

