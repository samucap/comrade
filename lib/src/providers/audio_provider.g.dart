// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AudioNotifier)
const audioProvider = AudioNotifierProvider._();

final class AudioNotifierProvider
    extends $NotifierProvider<AudioNotifier, AudioState> {
  const AudioNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'audioProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$audioNotifierHash();

  @$internal
  @override
  AudioNotifier create() => AudioNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioState>(value),
    );
  }
}

String _$audioNotifierHash() => r'996b2ef497b0bb6f748d7457bbcb0c3d98f6867a';

abstract class _$AudioNotifier extends $Notifier<AudioState> {
  AudioState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AudioState, AudioState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AudioState, AudioState>, AudioState, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
