// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatRepositoryHash() => r'1ed3477064834fb16023d432d87611bdc9785f01';

/// Provider for the chat repository
///
/// Copied from [chatRepository].
@ProviderFor(chatRepository)
final chatRepositoryProvider = Provider<ChatRepository>.internal(
  chatRepository,
  name: r'chatRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatRepositoryRef = ProviderRef<ChatRepository>;
String _$appDatabaseHash() => r'8c69eb46d45206533c176c88a926608e79ca927d';

/// Provider for the app database
///
/// Copied from [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = ProviderRef<AppDatabase>;
String _$chatMessagesHash() => r'04c3365335b409df523d6121e89e56057c57e788';

/// Provider that returns the current chat messages
///
/// Copied from [chatMessages].
@ProviderFor(chatMessages)
final chatMessagesProvider =
    AutoDisposeFutureProvider<List<MessageModel>>.internal(
  chatMessages,
  name: r'chatMessagesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatMessagesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatMessagesRef = AutoDisposeFutureProviderRef<List<MessageModel>>;
String _$latestMessageHash() => r'14ecfbf68c882c085813899db5f4322978522c5f';

/// Provider that returns the latest message
///
/// Copied from [latestMessage].
@ProviderFor(latestMessage)
final latestMessageProvider = AutoDisposeFutureProvider<MessageModel?>.internal(
  latestMessage,
  name: r'latestMessageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$latestMessageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LatestMessageRef = AutoDisposeFutureProviderRef<MessageModel?>;
String _$chatMessagesStreamHash() =>
    r'292816d94bf0515741af90976b277b6bb1397b2a';

/// Provider for reactive chat updates
///
/// Copied from [chatMessagesStream].
@ProviderFor(chatMessagesStream)
final chatMessagesStreamProvider =
    AutoDisposeStreamProvider<List<MessageModel>>.internal(
  chatMessagesStream,
  name: r'chatMessagesStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatMessagesStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatMessagesStreamRef
    = AutoDisposeStreamProviderRef<List<MessageModel>>;
String _$chatNotifierHash() => r'b327d33ec738b4d35cac71aacf2d14a2f6c6a9da';

/// Provider for chat state management
///
/// Copied from [ChatNotifier].
@ProviderFor(ChatNotifier)
final chatNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ChatNotifier, List<MessageModel>>.internal(
  ChatNotifier.new,
  name: r'chatNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatNotifier = AutoDisposeAsyncNotifier<List<MessageModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
