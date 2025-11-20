// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentWaveformHash() => r'f05fb11bca9e6e22e92369bfa89104b954761993';

/// Provider that returns current waveform data
///
/// Copied from [currentWaveform].
@ProviderFor(currentWaveform)
final currentWaveformProvider = AutoDisposeProvider<List<double>>.internal(
  currentWaveform,
  name: r'currentWaveformProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentWaveformHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentWaveformRef = AutoDisposeProviderRef<List<double>>;
String _$isRecordingAudioHash() => r'2f244464703d3124022c98dac941111472af6c55';

/// Provider that returns whether audio is currently recording
///
/// Copied from [isRecordingAudio].
@ProviderFor(isRecordingAudio)
final isRecordingAudioProvider = AutoDisposeProvider<bool>.internal(
  isRecordingAudio,
  name: r'isRecordingAudioProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isRecordingAudioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsRecordingAudioRef = AutoDisposeProviderRef<bool>;
String _$lastRecordingPathHash() => r'e9ac3cc84112d9d69584a919b942e895bdd64669';

/// Provider that returns the last recording path
///
/// Copied from [lastRecordingPath].
@ProviderFor(lastRecordingPath)
final lastRecordingPathProvider = AutoDisposeProvider<String?>.internal(
  lastRecordingPath,
  name: r'lastRecordingPathProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lastRecordingPathHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LastRecordingPathRef = AutoDisposeProviderRef<String?>;
String _$audioNotifierHash() => r'd4a4dbf422764a6da0e0598ae60756e28901e493';

/// Real audio recording provider
///
/// Copied from [AudioNotifier].
@ProviderFor(AudioNotifier)
final audioNotifierProvider =
    AutoDisposeNotifierProvider<AudioNotifier, AudioState>.internal(
  AudioNotifier.new,
  name: r'audioNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$audioNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AudioNotifier = AutoDisposeNotifier<AudioState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
