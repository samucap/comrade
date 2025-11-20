import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/rive_controller.dart';
import 'animations.dart';

/// Avatar animation manager for emotion transitions
class AvatarAnimator {
  AvatarAnimator();

  final _random = math.Random();
  AvatarEmotion? _currentEmotion;
  final List<AvatarEmotion> _emotionQueue = [];

  /// Get a random emotion (excluding base states)
  AvatarEmotion getRandomEmotion() {
    final emotionalStates = [
      AvatarEmotion.happy,
      AvatarEmotion.laugh,
      AvatarEmotion.smirk,
      AvatarEmotion.blush,
      AvatarEmotion.sad,
      AvatarEmotion.angry,
      AvatarEmotion.shocked,
      AvatarEmotion.heartEyes,
      AvatarEmotion.eyeRoll,
      AvatarEmotion.shrug,
    ];

    return emotionalStates[_random.nextInt(emotionalStates.length)];
  }

  /// Get animation duration for specific emotion
  Duration getDuration(AvatarEmotion emotion) {
    switch (emotion) {
      case AvatarEmotion.idle:
      case AvatarEmotion.listening:
      case AvatarEmotion.speaking:
      case AvatarEmotion.thinking:
        return LusionDurations.medium; // Base states are sustained
      
      case AvatarEmotion.laugh:
      case AvatarEmotion.shocked:
        return LusionDurations.slow; // Dramatic emotions last longer
      
      case AvatarEmotion.happy:
      case AvatarEmotion.smirk:
      case AvatarEmotion.blush:
      case AvatarEmotion.heartEyes:
        return const Duration(milliseconds: 800);
      
      case AvatarEmotion.sad:
      case AvatarEmotion.angry:
        return const Duration(milliseconds: 700);
      
      case AvatarEmotion.eyeRoll:
      case AvatarEmotion.shrug:
        return const Duration(milliseconds: 600);
    }
  }

  /// Get animation curve for specific emotion
  Curve getCurve(AvatarEmotion emotion) {
    switch (emotion) {
      case AvatarEmotion.laugh:
      case AvatarEmotion.happy:
        return LusionCurves.elasticOut;
      
      case AvatarEmotion.shocked:
      case AvatarEmotion.angry:
        return LusionCurves.expoOut;
      
      case AvatarEmotion.smirk:
      case AvatarEmotion.eyeRoll:
        return LusionCurves.smoothEase;
      
      default:
        return LusionCurves.premiumEase;
    }
  }

  /// Queue an emotion for playback
  void queueEmotion(AvatarEmotion emotion) {
    _emotionQueue.add(emotion);
  }

  /// Get next emotion from queue
  AvatarEmotion? getNextEmotion() {
    if (_emotionQueue.isEmpty) return null;
    return _emotionQueue.removeAt(0);
  }

  /// Check if there are queued emotions
  bool get hasQueuedEmotions => _emotionQueue.isNotEmpty;

  /// Clear the emotion queue
  void clearQueue() {
    _emotionQueue.clear();
  }

  /// Set current emotion
  void setCurrentEmotion(AvatarEmotion emotion) {
    _currentEmotion = emotion;
  }

  /// Get current emotion
  AvatarEmotion? get currentEmotion => _currentEmotion;

  /// Check if emotion is a base state (not an expressive emotion)
  bool isBaseState(AvatarEmotion emotion) {
    return emotion == AvatarEmotion.idle ||
           emotion == AvatarEmotion.listening ||
           emotion == AvatarEmotion.speaking ||
           emotion == AvatarEmotion.thinking;
  }

  /// Get emotion intensity (for potential future use with amplitude)
  double getEmotionIntensity(AvatarEmotion emotion) {
    switch (emotion) {
      case AvatarEmotion.laugh:
      case AvatarEmotion.angry:
      case AvatarEmotion.shocked:
        return 1.0; // High intensity
      
      case AvatarEmotion.happy:
      case AvatarEmotion.sad:
      case AvatarEmotion.heartEyes:
        return 0.8; // Medium-high intensity
      
      case AvatarEmotion.smirk:
      case AvatarEmotion.blush:
      case AvatarEmotion.eyeRoll:
        return 0.6; // Medium intensity
      
      case AvatarEmotion.shrug:
        return 0.4; // Low intensity
      
      default:
        return 0.5; // Neutral
    }
  }
}

/// Animation sequence for complex emotion transitions
class EmotionSequence {
  const EmotionSequence({
    required this.emotions,
    required this.totalDuration,
  });

  final List<AvatarEmotion> emotions;
  final Duration totalDuration;

  /// Create a laugh sequence
  static EmotionSequence laugh() {
    return const EmotionSequence(
      emotions: [
        AvatarEmotion.happy,
        AvatarEmotion.laugh,
        AvatarEmotion.happy,
      ],
      totalDuration: Duration(milliseconds: 2000),
    );
  }

  /// Create a surprise sequence
  static EmotionSequence surprise() {
    return const EmotionSequence(
      emotions: [
        AvatarEmotion.shocked,
        AvatarEmotion.happy,
      ],
      totalDuration: Duration(milliseconds: 1500),
    );
  }

  /// Create a dismissive sequence
  static EmotionSequence dismissive() {
    return const EmotionSequence(
      emotions: [
        AvatarEmotion.eyeRoll,
        AvatarEmotion.smirk,
      ],
      totalDuration: Duration(milliseconds: 1200),
    );
  }
}


