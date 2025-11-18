import 'package:rive/rive.dart';

/// Avatar emotion states that map to Rive state machine inputs
enum AvatarEmotion {
  /// Default resting state
  idle,

  /// Actively listening to user input
  listening,

  /// Speaking or responding
  speaking,

  /// Processing/thinking about response
  thinking,

  /// Happy/joyful expression
  happy,

  /// Laughing animation
  laugh,

  /// Playful, sarcastic expression
  smirk,

  /// Embarrassed or shy expression
  blush,

  /// Sad or downcast expression
  sad,

  /// Angry or frustrated expression
  angry,

  /// Surprised or shocked expression
  shocked,

  /// Affectionate expression
  heartEyes,

  /// Annoyed or dismissive expression
  eyeRoll,

  /// Uncertain or confused expression
  shrug,
}

/// Controller for managing Rive avatar animations and state machine
class RiveAvatarController {
  RiveAvatarController({
    required this.animationController,
    required this.stateMachineController,
  }) {
    _setupInputs();
  }

  final RiveAnimationController animationController;
  final StateMachineController stateMachineController;

  // State machine inputs - these will be triggered by the avatar state
  late final SMINumber? _emotionInput;

  // Current emotion state
  AvatarEmotion _currentEmotion = AvatarEmotion.idle;

  /// Get the current emotion
  AvatarEmotion get currentEmotion => _currentEmotion;

  /// Initialize state machine inputs
  void _setupInputs() {
    final inputs = stateMachineController.inputs;
    for (final input in inputs) {
      if (input.name == 'emotion' && input is SMINumber) {
        _emotionInput = input;
        break;
      }
    }
  }

  /// Set the avatar emotion and trigger the corresponding animation
  void setEmotion(AvatarEmotion emotion) {
    if (_currentEmotion == emotion) return;

    _currentEmotion = emotion;

    // Map emotion to state machine input value (0-13)
    final inputValue = emotion.index.toDouble();
    _emotionInput?.value = inputValue;
  }

  /// Reset to idle state
  void resetToIdle() {
    setEmotion(AvatarEmotion.idle);
  }

  /// Trigger a specific emotion temporarily (auto-resets after duration)
  void triggerEmotion(AvatarEmotion emotion, {Duration duration = const Duration(seconds: 2)}) {
    setEmotion(emotion);

    // Auto-reset to idle after duration (unless it's a continuous state)
    if (!_isContinuousState(emotion)) {
      Future.delayed(duration, () {
        if (_currentEmotion == emotion) {
          resetToIdle();
        }
      });
    }
  }

  /// Check if an emotion state should be continuous (doesn't auto-reset)
  bool _isContinuousState(AvatarEmotion emotion) {
    return emotion == AvatarEmotion.idle ||
           emotion == AvatarEmotion.listening ||
           emotion == AvatarEmotion.speaking ||
           emotion == AvatarEmotion.thinking;
  }

  /// Dispose of the controller
  void dispose() {
    animationController.dispose();
    stateMachineController.dispose();
  }
}

/// Extension methods for AvatarEmotion enum
extension AvatarEmotionExtension on AvatarEmotion {
  /// Get display name for the emotion
  String get displayName {
    switch (this) {
      case AvatarEmotion.idle:
        return 'Idle';
      case AvatarEmotion.listening:
        return 'Listening';
      case AvatarEmotion.speaking:
        return 'Speaking';
      case AvatarEmotion.thinking:
        return 'Thinking';
      case AvatarEmotion.happy:
        return 'Happy';
      case AvatarEmotion.laugh:
        return 'Laughing';
      case AvatarEmotion.smirk:
        return 'Smirking';
      case AvatarEmotion.blush:
        return 'Blushing';
      case AvatarEmotion.sad:
        return 'Sad';
      case AvatarEmotion.angry:
        return 'Angry';
      case AvatarEmotion.shocked:
        return 'Shocked';
      case AvatarEmotion.heartEyes:
        return 'Heart Eyes';
      case AvatarEmotion.eyeRoll:
        return 'Eye Roll';
      case AvatarEmotion.shrug:
        return 'Shrugging';
    }
  }

  /// Check if this emotion is temporary (auto-resets) or continuous
  bool get isTemporary => ![
    AvatarEmotion.idle,
    AvatarEmotion.listening,
    AvatarEmotion.speaking,
    AvatarEmotion.thinking,
  ].contains(this);
}

