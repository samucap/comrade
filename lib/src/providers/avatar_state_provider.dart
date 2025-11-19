import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/rive_controller.dart';

part 'avatar_state_provider.g.dart';

/// Provider for managing the current avatar emotion state
@riverpod
class AvatarStateNotifier extends _$AvatarStateNotifier {
  @override
  AvatarEmotion build() {
    return AvatarEmotion.idle;
  }

  /// Set the current emotion
  void setEmotion(AvatarEmotion emotion) {
    state = emotion;
  }

  /// Trigger an emotion temporarily (auto-resets to idle)
  void triggerEmotion(AvatarEmotion emotion, {Duration duration = const Duration(seconds: 2)}) {
    setEmotion(emotion);

    // Auto-reset to idle for temporary emotions
    if (emotion.isTemporary) {
      Future.delayed(duration, () {
        if (state == emotion) {
          setEmotion(AvatarEmotion.idle);
        }
      });
    }
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

