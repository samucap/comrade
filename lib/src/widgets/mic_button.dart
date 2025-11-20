import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/chat_provider.dart';
import '../providers/audio_provider.dart';
import '../providers/avatar_state_provider.dart';
import '../core/animations.dart';
import '../core/typography.dart';
import '../core/rive_controller.dart';

/// Premium microphone button with real audio recording
class MicButton extends ConsumerStatefulWidget {
  const MicButton({
    super.key,
    this.size = 80,
  });

  final double size;

  @override
  ConsumerState<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends ConsumerState<MicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: LusionDurations.quick,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: LusionCurves.smoothEase),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onLongPressStart(LongPressStartDetails details) async {
    HapticFeedback.mediumImpact();
    setState(() {
      _isPressed = true;
    });
    _controller.forward();
    
    // Start recording
    await ref.read(audioNotifierProvider.notifier).startRecording();
    
    // Set avatar to listening state
    ref.read(avatarStateNotifierProvider.notifier).setEmotion(AvatarEmotion.listening);
  }

  void _onLongPressEnd(LongPressEndDetails details) async {
    HapticFeedback.lightImpact();
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
    
    // Stop recording
    final recordingPath = await ref.read(audioNotifierProvider.notifier).stopRecording();
    
    if (recordingPath != null) {
      // Set avatar to thinking state
      ref.read(avatarStateNotifierProvider.notifier).setEmotion(AvatarEmotion.thinking);
      
      // Send message (you can process audio here)
      ref.read(chatNotifierProvider.notifier).sendMessage("Voice message recorded");
      
      // Reset to idle after a moment
      Future.delayed(const Duration(seconds: 2), () {
        ref.read(avatarStateNotifierProvider.notifier).resetToIdle();
      });
    }
  }

  void _onLongPressCancel() async {
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
    
    // Cancel recording
    await ref.read(audioNotifierProvider.notifier).cancelRecording();
    ref.read(avatarStateNotifierProvider.notifier).resetToIdle();
  }

  void _onTap() {
    // Simple tap - just send a hello message
    HapticFeedback.lightImpact();
    ref.read(chatNotifierProvider.notifier).sendMessage("Hello!");
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isRecording = ref.watch(isRecordingAudioProvider);

    return GestureDetector(
      onTap: _onTap,
      onLongPressStart: _onLongPressStart,
      onLongPressEnd: _onLongPressEnd,
      onLongPressCancel: _onLongPressCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isRecording
                      ? LusionColors.error
                      : colorScheme.onSurface.withOpacity(0.2),
                  width: 1.5,
                ),
                color: _isPressed || isRecording
                    ? (isRecording
                        ? LusionColors.error.withOpacity(0.05)
                        : colorScheme.onSurface.withOpacity(0.05))
                    : Colors.transparent,
                boxShadow: _isPressed || isRecording
                    ? [
                        BoxShadow(
                          color: isRecording
                              ? LusionColors.error.withOpacity(0.15)
                              : colorScheme.onSurface.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : LusionElevation.subtle,
              ),
              child: Icon(
                isRecording ? Icons.mic_rounded : Icons.mic_none_rounded,
                color: isRecording
                    ? LusionColors.error
                    : colorScheme.onSurface,
                size: widget.size * 0.4,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Premium mic button with elegant instruction overlay
class InstructionalMicButton extends StatelessWidget {
  const InstructionalMicButton({
    super.key,
    this.size = 80,
    this.showInstructions = true,
  });

  final double size;
  final bool showInstructions;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        MicButton(size: size),
        if (showInstructions)
          Positioned(
            bottom: size + LusionSpacing.md,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: LusionSpacing.md,
                vertical: LusionSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: colorScheme.onSurface.withOpacity(0.1),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(LusionRadius.minimal),
              ),
              child: Text(
                'Tap to speak',
                style: LusionTypography.labelSmall.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Recording state mic button with active animation
class RecordingMicButton extends StatefulWidget {
  const RecordingMicButton({
    super.key,
    this.size = 80,
    this.isRecording = false,
  });

  final double size;
  final bool isRecording;

  @override
  State<RecordingMicButton> createState() => _RecordingMicButtonState();
}

class _RecordingMicButtonState extends State<RecordingMicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    if (widget.isRecording) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(RecordingMicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !oldWidget.isRecording) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulse ring when recording
            if (widget.isRecording)
              Container(
                width: widget.size + 20 * _pulseController.value,
                height: widget.size + 20 * _pulseController.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: LusionColors.error.withOpacity(0.3 * (1 - _pulseController.value)),
                    width: 2,
                  ),
                ),
              ),
            // Main button
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.isRecording
                      ? LusionColors.error
                      : colorScheme.onSurface.withOpacity(0.2),
                  width: 1.5,
                ),
                color: widget.isRecording
                    ? LusionColors.error.withOpacity(0.05)
                    : Colors.transparent,
                boxShadow: widget.isRecording
                    ? [
                        BoxShadow(
                          color: LusionColors.error.withOpacity(0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : LusionElevation.subtle,
              ),
              child: Icon(
                widget.isRecording ? Icons.mic_rounded : Icons.mic_none_rounded,
                color: widget.isRecording
                    ? LusionColors.error
                    : colorScheme.onSurface,
                size: widget.size * 0.4,
              ),
            ),
          ],
        );
      },
    );
  }
}
