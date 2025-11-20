import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../core/permissions.dart';

part 'audio_provider.g.dart';

/// Audio state with recording status and waveform data
class AudioState {
  final bool isRecording;
  final bool isPlaying;
  final List<double> waveformData;
  final String? lastRecordingPath;
  final String? errorMessage;

  const AudioState({
    this.isRecording = false,
    this.isPlaying = false,
    this.waveformData = const [],
    this.lastRecordingPath,
    this.errorMessage,
  });

  AudioState copyWith({
    bool? isRecording,
    bool? isPlaying,
    List<double>? waveformData,
    String? lastRecordingPath,
    String? errorMessage,
  }) {
    return AudioState(
      isRecording: isRecording ?? this.isRecording,
      isPlaying: isPlaying ?? this.isPlaying,
      waveformData: waveformData ?? this.waveformData,
      lastRecordingPath: lastRecordingPath ?? this.lastRecordingPath,
      errorMessage: errorMessage,
    );
  }
}

/// Real audio recording provider
@riverpod
class AudioNotifier extends _$AudioNotifier {
  late final AudioRecorder _recorder;
  Timer? _amplitudeTimer;
  StreamSubscription<Amplitude>? _amplitudeSubscription;

  @override
  AudioState build() {
    _recorder = AudioRecorder();
    ref.onDispose(() {
      _cleanup();
    });
    return const AudioState();
  }

  /// Start recording audio
  Future<void> startRecording() async {
    try {
      // Check/request permissions
      final hasPermission = await PermissionManager.ensureMicrophonePermission();
      if (!hasPermission) {
        state = state.copyWith(
          errorMessage: 'Microphone permission denied',
        );
        return;
      }

      // Check if already recording
      if (await _recorder.isRecording()) {
        return;
      }

      // Get recording file path
      final directory = await getTemporaryDirectory();
      final filePath = path.join(
        directory.path,
        'recording_${DateTime.now().millisecondsSinceEpoch}.m4a',
      );

      // Start recording
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );

      // Update state
      state = state.copyWith(
        isRecording: true,
        waveformData: [],
        errorMessage: null,
      );

      // Start monitoring amplitude
      _startAmplitudeMonitoring();
    } catch (e) {
      debugPrint('Error starting recording: $e');
      state = state.copyWith(
        isRecording: false,
        errorMessage: 'Failed to start recording: $e',
      );
    }
  }

  /// Stop recording and return file path
  Future<String?> stopRecording() async {
    try {
      // Stop amplitude monitoring
      _stopAmplitudeMonitoring();

      // Stop recording
      final filePath = await _recorder.stop();

      // Update state
      state = state.copyWith(
        isRecording: false,
        lastRecordingPath: filePath,
        waveformData: [],
      );

      return filePath;
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      state = state.copyWith(
        isRecording: false,
        errorMessage: 'Failed to stop recording: $e',
      );
      return null;
    }
  }

  /// Cancel recording without saving
  Future<void> cancelRecording() async {
    try {
      _stopAmplitudeMonitoring();
      
      if (await _recorder.isRecording()) {
        await _recorder.stop();
      }

      state = state.copyWith(
        isRecording: false,
        waveformData: [],
      );
    } catch (e) {
      debugPrint('Error canceling recording: $e');
      state = state.copyWith(
        isRecording: false,
        errorMessage: 'Failed to cancel recording: $e',
      );
    }
  }

  /// Start monitoring audio amplitude for waveform
  void _startAmplitudeMonitoring() {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) async {
        final amplitude = await _recorder.getAmplitude();
        _updateWaveform(amplitude.current);
      },
    );
  }

  /// Stop amplitude monitoring
  void _stopAmplitudeMonitoring() {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;
    _amplitudeSubscription?.cancel();
    _amplitudeSubscription = null;
  }

  /// Update waveform data with new amplitude
  void _updateWaveform(double amplitude) {
    // Normalize amplitude to 0.0-1.0 range
    final normalized = (amplitude + 50) / 50;
    final clamped = normalized.clamp(0.0, 1.0);

    // Keep last 50 samples for waveform visualization
    final updatedWaveform = List<double>.from(state.waveformData);
    updatedWaveform.add(clamped);
    if (updatedWaveform.length > 50) {
      updatedWaveform.removeAt(0);
    }

    state = state.copyWith(waveformData: updatedWaveform);
  }

  /// Cleanup resources
  void _cleanup() {
    _stopAmplitudeMonitoring();
    _recorder.dispose();
  }

  /// Check if device has recording permission
  Future<bool> checkPermission() async {
    return await PermissionManager.hasMicrophonePermission();
  }
}

/// Provider that returns current waveform data
@riverpod
List<double> currentWaveform(Ref ref) {
  return ref.watch(audioNotifierProvider.select((state) => state.waveformData));
}

/// Provider that returns whether audio is currently recording
@riverpod
bool isRecordingAudio(Ref ref) {
  return ref.watch(audioNotifierProvider.select((state) => state.isRecording));
}

/// Provider that returns the last recording path
@riverpod
String? lastRecordingPath(Ref ref) {
  return ref.watch(audioNotifierProvider.select((state) => state.lastRecordingPath));
}
