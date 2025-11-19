import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_provider.g.dart';

// Simple state class to hold recording status and waveform data
class AudioState {
  final bool isRecording;
  final bool isPlaying;
  final List<double> waveformData;

  AudioState({this.isRecording = false, this.isPlaying = false, this.waveformData = const []});

  AudioState copyWith({bool? isRecording, bool? isPlaying, List<double>? waveformData}) {
    return AudioState(
      isRecording: isRecording ?? this.isRecording,
      isPlaying: isPlaying ?? this.isPlaying,
      waveformData: waveformData ?? this.waveformData,
    );
  }
}

// Simplified mock audio notifier
@riverpod
class AudioNotifier extends _$AudioNotifier {
  @override
  AudioState build() {
    return AudioState();
  }

  Future<void> startRecording() async {
    // Mock recording - just update state
    state = state.copyWith(isRecording: true, waveformData: []);
  }

  Future<String?> stopRecording() async {
    // Mock stop recording
    state = state.copyWith(isRecording: false);
    return null;
  }

  void cancelRecording() {
    // Mock cancel recording
    state = state.copyWith(isRecording: false, waveformData: []);
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
