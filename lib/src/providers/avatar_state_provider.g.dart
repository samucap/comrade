// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentAvatarEmotionHash() =>
    r'aa79c8269b85d2e128818ae51f9590230aad86a8';

/// Provider that returns the current emotion
///
/// Copied from [currentAvatarEmotion].
@ProviderFor(currentAvatarEmotion)
final currentAvatarEmotionProvider =
    AutoDisposeProvider<AvatarEmotion>.internal(
  currentAvatarEmotion,
  name: r'currentAvatarEmotionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentAvatarEmotionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentAvatarEmotionRef = AutoDisposeProviderRef<AvatarEmotion>;
String _$avatarEmotionStreamHash() =>
    r'c8983d664d6d0ab4aea341d3492ecae462d5fe61';

/// Provider for avatar emotion stream (reactive updates)
///
/// Copied from [avatarEmotionStream].
@ProviderFor(avatarEmotionStream)
final avatarEmotionStreamProvider =
    AutoDisposeStreamProvider<AvatarEmotion>.internal(
  avatarEmotionStream,
  name: r'avatarEmotionStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$avatarEmotionStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvatarEmotionStreamRef = AutoDisposeStreamProviderRef<AvatarEmotion>;
String _$avatarStateNotifierHash() =>
    r'cb850205967cf4dc1e2f7f692df8562d4a900063';

/// Provider for managing the current avatar emotion state
///
/// Copied from [AvatarStateNotifier].
@ProviderFor(AvatarStateNotifier)
final avatarStateNotifierProvider =
    AutoDisposeNotifierProvider<AvatarStateNotifier, AvatarEmotion>.internal(
  AvatarStateNotifier.new,
  name: r'avatarStateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$avatarStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AvatarStateNotifier = AutoDisposeNotifier<AvatarEmotion>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
