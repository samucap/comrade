// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for managing the current avatar emotion state

@ProviderFor(AvatarStateNotifier)
const avatarStateProvider = AvatarStateNotifierProvider._();

/// Provider for managing the current avatar emotion state
final class AvatarStateNotifierProvider
    extends $NotifierProvider<AvatarStateNotifier, AvatarEmotion> {
  /// Provider for managing the current avatar emotion state
  const AvatarStateNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'avatarStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$avatarStateNotifierHash();

  @$internal
  @override
  AvatarStateNotifier create() => AvatarStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AvatarEmotion value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AvatarEmotion>(value),
    );
  }
}

String _$avatarStateNotifierHash() =>
    r'cb850205967cf4dc1e2f7f692df8562d4a900063';

/// Provider for managing the current avatar emotion state

abstract class _$AvatarStateNotifier extends $Notifier<AvatarEmotion> {
  AvatarEmotion build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AvatarEmotion, AvatarEmotion>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AvatarEmotion, AvatarEmotion>,
        AvatarEmotion,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

/// Provider that returns the current emotion

@ProviderFor(currentAvatarEmotion)
const currentAvatarEmotionProvider = CurrentAvatarEmotionProvider._();

/// Provider that returns the current emotion

final class CurrentAvatarEmotionProvider
    extends $FunctionalProvider<AvatarEmotion, AvatarEmotion, AvatarEmotion>
    with $Provider<AvatarEmotion> {
  /// Provider that returns the current emotion
  const CurrentAvatarEmotionProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'currentAvatarEmotionProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$currentAvatarEmotionHash();

  @$internal
  @override
  $ProviderElement<AvatarEmotion> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AvatarEmotion create(Ref ref) {
    return currentAvatarEmotion(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AvatarEmotion value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AvatarEmotion>(value),
    );
  }
}

String _$currentAvatarEmotionHash() =>
    r'aa79c8269b85d2e128818ae51f9590230aad86a8';

/// Provider for avatar emotion stream (reactive updates)

@ProviderFor(avatarEmotionStream)
const avatarEmotionStreamProvider = AvatarEmotionStreamProvider._();

/// Provider for avatar emotion stream (reactive updates)

final class AvatarEmotionStreamProvider extends $FunctionalProvider<
        AsyncValue<AvatarEmotion>, AvatarEmotion, Stream<AvatarEmotion>>
    with $FutureModifier<AvatarEmotion>, $StreamProvider<AvatarEmotion> {
  /// Provider for avatar emotion stream (reactive updates)
  const AvatarEmotionStreamProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'avatarEmotionStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$avatarEmotionStreamHash();

  @$internal
  @override
  $StreamProviderElement<AvatarEmotion> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AvatarEmotion> create(Ref ref) {
    return avatarEmotionStream(ref);
  }
}

String _$avatarEmotionStreamHash() =>
    r'c8983d664d6d0ab4aea341d3492ecae462d5fe61';
