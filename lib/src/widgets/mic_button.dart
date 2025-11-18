import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vibration/vibration.dart';

import '../providers/audio_provider.dart';
import '../providers/avatar_state_provider.dart';
import '../providers/chat_provider.dart';
import 'waveform_painter.dart';

/// Custom microphone button with gesture handling for voice recording
class MicButton extends HookConsumerWidget {
  const MicButton({
    super.key,
    this.size = 80,
    this.onRecordingStart,
    this.onRecordingEnd,
    this.onRecordingCancel,
  });

  final double size;
  final VoidCallback? onRecordingStart;
  final VoidCallback? onRecordingEnd;
  final VoidCallback? onRecordingCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioNotifierProvider);
    final waveformData = ref.watch(currentWaveformProvider);
    final isRecording = audioState.isRecording;
    final isPlaying = audioState.isPlaying;

    return GestureDetector(
      onLongPressStart: (_) => _handleRecordingStart(context, ref),
      onLongPressEnd: (_) => _handleRecordingEnd(context, ref),
      onLongPressMoveUpdate: (details) => _handleSwipeCancel(details, context, ref),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isRecording ? size * 1.2 : size,
        height: isRecording ? size * 1.2 : size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background pulse effect when recording
            if (isRecording) _buildPulseEffect(context),

            // Main button
            _buildMainButton(context, isRecording, isPlaying),

            // Waveform overlay when recording
            if (isRecording && waveformData.isNotEmpty)
              _buildWaveformOverlay(waveformData, context),

            // Playback waveform when speaking
            if (isPlaying) _buildPlaybackWaveform(waveformData, context),
          ],
        ),
      ),
    );
  }

  void _handleRecordingStart(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(audioNotifierProvider.notifier).startRecording();

      // Set avatar to listening state
      ref.read(avatarStateNotifierProvider.notifier).setEmotion(AvatarEmotion.listening);

      // Trigger haptic feedback
      _triggerHapticFeedback();

      onRecordingStart?.call();
    } catch (e) {
      // Handle recording start error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start recording: $e')),
      );
    }
  }

  void _handleRecordingEnd(BuildContext context, WidgetRef ref) async {
    try {
      final audioData = await ref.read(audioNotifierProvider.notifier).stopRecording();

      if (audioData != null) {
        // Process the recorded audio and send message
        final message = "Voice message recorded"; // In real app, this would be transcribed
        await ref.read(chatNotifierProvider.notifier).sendMessage(message);
      }

      onRecordingEnd?.call();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to stop recording: $e')),
      );
    }
  }

  void _handleSwipeCancel(LongPressMoveUpdateDetails details, BuildContext context, WidgetRef ref) {
    // Cancel if swiped down more than 50 pixels
    if (details.offsetFromOrigin.dy > 50) {
      ref.read(audioNotifierProvider.notifier).cancelRecording();

      // Set avatar to shrug emotion for cancellation
      ref.read(avatarStateNotifierProvider.notifier).triggerEmotion(AvatarEmotion.shrug);

      // Trigger haptic feedback
      _triggerHapticFeedback();

      onRecordingCancel?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recording cancelled')),
      );
    }
  }

  Widget _buildMainButton(BuildContext context, bool isRecording, bool isPlaying) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isRecording
              ? [Colors.red.shade400, Colors.red.shade600]
              : isPlaying
                  ? [colorScheme.primary, colorScheme.primaryContainer]
                  : [colorScheme.primary, colorScheme.primaryContainer],
        ),
        boxShadow: [
          BoxShadow(
            color: (isRecording ? Colors.red : colorScheme.primary).withOpacity(0.3),
            blurRadius: isRecording ? 20 : 10,
            spreadRadius: isRecording ? 5 : 0,
          ),
        ],
      ),
      child: Icon(
        isRecording
            ? Icons.mic
            : isPlaying
                ? Icons.volume_up
                : Icons.mic_none,
        color: colorScheme.onPrimary,
        size: size * 0.4,
      ),
    );
  }

  Widget _buildPulseEffect(BuildContext context) {
    return Container(
      width: size * 2,
      height: size * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 2,
        ),
      ),
    );
  }

  Widget _buildWaveformOverlay(List<double> waveformData, BuildContext context) {
    return Positioned(
      top: -size * 0.3,
      left: -size * 0.3,
      right: -size * 0.3,
      bottom: -size * 0.3,
      child: PulsingWaveform(
        waveformData: waveformData,
        color: Colors.red,
        height: size * 0.6,
      ),
    );
  }

  Widget _buildPlaybackWaveform(List<double> waveformData, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned(
      top: -size * 0.2,
      left: -size * 0.2,
      right: -size * 0.2,
      bottom: -size * 0.2,
      child: LiveWaveform(
        waveformData: waveformData,
        color: colorScheme.primary,
        height: size * 0.4,
        isReversed: true,
      ),
    );
  }

  void _triggerHapticFeedback() async {
    try {
      final hasVibrator = await Vibration.hasVibrator() ?? false;
      if (hasVibrator) {
        await Vibration.vibrate(duration: 50);
      } else {
        // Fallback to system sound
        await SystemSound.play(SystemSoundType.click);
      }
    } catch (e) {
      // Haptic feedback not available
    }
  }
}

/// Floating action button style mic button
class FloatingMicButton extends MicButton {
  const FloatingMicButton({
    super.key,
    super.size = 56,
    super.onRecordingStart,
    super.onRecordingEnd,
    super.onRecordingCancel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioNotifierProvider);
    final waveformData = ref.watch(currentWaveformProvider);
    final isRecording = audioState.isRecording;
    final isPlaying = audioState.isPlaying;

    return GestureDetector(
      onLongPressStart: (_) => _handleRecordingStart(context, ref),
      onLongPressEnd: (_) => _handleRecordingEnd(context, ref),
      onLongPressMoveUpdate: (details) => _handleSwipeCancel(details, context, ref),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isRecording ? size * 1.5 : size,
        height: isRecording ? size * 1.5 : size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isRecording ? Colors.red : Theme.of(context).colorScheme.primaryContainer,
          boxShadow: [
            BoxShadow(
              color: (isRecording ? Colors.red : Theme.of(context).colorScheme.primary)
                  .withOpacity(0.3),
              blurRadius: isRecording ? 25 : 8,
              spreadRadius: isRecording ? 8 : 0,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              isRecording
                  ? Icons.mic
                  : isPlaying
                      ? Icons.volume_up
                      : Icons.mic_none,
              color: isRecording
                  ? Colors.white
                  : Theme.of(context).colorScheme.onPrimaryContainer,
              size: size * 0.4,
            ),
            if (isRecording && waveformData.isNotEmpty)
              Positioned(
                top: -size * 0.3,
                left: -size * 0.3,
                right: -size * 0.3,
                bottom: -size * 0.3,
                child: AnimatedWaveform(
                  waveformData: waveformData,
                  color: Colors.red.withOpacity(0.8),
                  height: size * 0.8,
                  isReversed: false,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Mic button with hold-to-record instruction overlay
class InstructionalMicButton extends HookConsumerWidget {
  const InstructionalMicButton({
    super.key,
    this.size = 80,
    this.showInstructions = true,
  });

  final double size;
  final bool showInstructions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRecording = ref.watch(isRecordingAudioProvider);

    return Stack(
      alignment: Alignment.center,
      children: [
        MicButton(size: size),
        if (showInstructions && !isRecording)
          Positioned(
            bottom: size * 0.7,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                'Hold to record',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Mic button with recording duration display
class TimedMicButton extends HookConsumerWidget {
  const TimedMicButton({
    super.key,
    this.size = 80,
    this.maxDuration = const Duration(seconds: 30),
  });

  final double size;
  final Duration maxDuration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRecording = ref.watch(isRecordingAudioProvider);

    return Stack(
      alignment: Alignment.center,
      children: [
        MicButton(size: size),
        if (isRecording)
          Positioned(
            top: -size * 0.6,
            child: HookBuilder(
              builder: (context) {
                final startTime = useRef<DateTime?>(null);
                final duration = useState<Duration>(Duration.zero);

                useEffect(() {
                  if (isRecording && startTime.value == null) {
                    startTime.value = DateTime.now();
                  }

                  if (isRecording) {
                    final timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
                      if (startTime.value != null) {
                        duration.value = DateTime.now().difference(startTime.value!);
                      }
                    });
                    return timer.cancel;
                  } else {
                    startTime.value = null;
                    duration.value = Duration.zero;
                  }
                  return null;
                }, [isRecording]);

                final remaining = maxDuration - duration.value;
                final progress = duration.value.inMilliseconds / maxDuration.inMilliseconds;

                return Column(
                  children: [
                    SizedBox(
                      width: size * 0.8,
                      height: 4,
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${remaining.inSeconds}s',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}

