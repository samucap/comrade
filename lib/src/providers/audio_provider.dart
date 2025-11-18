import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart'; // Use the new package
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_provider.g.dart';

// Simple state class to hold recording status and waveform data
class AudioState {
  final bool isRecording;
  final List<double> waveformData;

  AudioState({this.isRecording = false, this.waveformData = const []});

  AudioState copyWith({bool? isRecording, List<double>? waveformData}) {
    return AudioState(
      isRecording: isRecording ?? this.isRecording,
      waveformData: waveformData ?? this.waveformData,
    );
  }
}

@riverpod
class AudioNotifier extends _$AudioNotifier {
  AudioRecorder? _recorder;
  StreamSubscription? _streamSubscription;
  final List<double> _buffer = [];
  File? _tempFile;
  IOSink? _fileSink;

  @override
  AudioState build() {
    // Initialize the recorder when the provider is built
    _recorder = AudioRecorder();
    ref.onDispose(() {
      _recorder?.dispose();
      _streamSubscription?.cancel();
      _fileSink?.close();
    });
    return AudioState();
  }

  Future<void> startRecording() async {
    if (_recorder == null) return;

    // Check permissions
    if (!await _recorder!.hasPermission()) return;

    // Prepare a temporary file to save the audio
    final tempDir = await getTemporaryDirectory();
    _tempFile = File('${tempDir.path}/recording.pcm'); // Raw PCM data
    _fileSink = _tempFile!.openWrite();

    // Start streaming raw 16-bit PCM data
    final stream = await _recorder!.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
      ),
    );

    state = state.copyWith(isRecording: true, waveformData: []);
    _buffer.clear();

    _streamSubscription = stream.listen((data) {
      // 1. Write to file (so we can send it later)
      _fileSink?.add(data);

      // 2. Process for Waveform (Convert Int16 bytes to normalized doubles)
      final samples = _processAudioBytes(data);
      
      // Keep only the last 50-100 points for a smooth visualizer
      if (_buffer.length > 100) {
        _buffer.removeRange(0, _buffer.length - 100);
      }
      _buffer.addAll(samples);
      
      state = state.copyWith(waveformData: List.from(_buffer));
    });
  }

  Future<String?> stopRecording() async {
    await _streamSubscription?.cancel();
    await _recorder?.stop(); // Stop the recorder hardware
    await _fileSink?.close(); // Close the file
    
    state = state.copyWith(isRecording: false);
    
    // Return the path to the recorded file
    return _tempFile?.path;
  }

  void cancelRecording() async {
    await stopRecording();
    if (_tempFile != null && await _tempFile!.exists()) {
      await _tempFile!.delete();
    }
    state = state.copyWith(isRecording: false, waveformData: []);
  }

  // Helper: Convert raw PCM 16-bit bytes to a list of doubles (-1.0 to 1.0)
  List<double> _processAudioBytes(Uint8List data) {
    final samples = <double>[];
    // Read 2 bytes at a time (Int16)
    for (var i = 0; i < data.length; i += 2) {
      if (i + 1 < data.length) {
        // Combine two bytes into a 16-bit integer
        int sample = data[i] | (data[i + 1] << 8);
        
        // Handle signed 16-bit integer conversion
        if (sample > 32767) sample -= 65536;
        
        // Normalize to -1.0 -> 1.0
        samples.add(sample / 32768.0);
      }
    }
    return samples;
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
