// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the chat repository

@ProviderFor(chatRepository)
const chatRepositoryProvider = ChatRepositoryProvider._();

/// Provider for the chat repository

final class ChatRepositoryProvider
    extends $FunctionalProvider<ChatRepository, ChatRepository, ChatRepository>
    with $Provider<ChatRepository> {
  /// Provider for the chat repository
  const ChatRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'chatRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$chatRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatRepository create(Ref ref) {
    return chatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRepository>(value),
    );
  }
}

String _$chatRepositoryHash() => r'1ed3477064834fb16023d432d87611bdc9785f01';

/// Provider for the app database

@ProviderFor(appDatabase)
const appDatabaseProvider = AppDatabaseProvider._();

/// Provider for the app database

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// Provider for the app database
  const AppDatabaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'appDatabaseProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'8c69eb46d45206533c176c88a926608e79ca927d';

/// Provider for chat state management

@ProviderFor(ChatNotifier)
const chatProvider = ChatNotifierProvider._();

/// Provider for chat state management
final class ChatNotifierProvider
    extends $AsyncNotifierProvider<ChatNotifier, List<MessageModel>> {
  /// Provider for chat state management
  const ChatNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'chatProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$chatNotifierHash();

  @$internal
  @override
  ChatNotifier create() => ChatNotifier();
}

String _$chatNotifierHash() => r'b327d33ec738b4d35cac71aacf2d14a2f6c6a9da';

/// Provider for chat state management

abstract class _$ChatNotifier extends $AsyncNotifier<List<MessageModel>> {
  FutureOr<List<MessageModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<MessageModel>>, List<MessageModel>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<MessageModel>>, List<MessageModel>>,
        AsyncValue<List<MessageModel>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

/// Provider that returns the current chat messages

@ProviderFor(chatMessages)
const chatMessagesProvider = ChatMessagesProvider._();

/// Provider that returns the current chat messages

final class ChatMessagesProvider extends $FunctionalProvider<
        AsyncValue<List<MessageModel>>,
        List<MessageModel>,
        FutureOr<List<MessageModel>>>
    with
        $FutureModifier<List<MessageModel>>,
        $FutureProvider<List<MessageModel>> {
  /// Provider that returns the current chat messages
  const ChatMessagesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'chatMessagesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$chatMessagesHash();

  @$internal
  @override
  $FutureProviderElement<List<MessageModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<MessageModel>> create(Ref ref) {
    return chatMessages(ref);
  }
}

String _$chatMessagesHash() => r'04c3365335b409df523d6121e89e56057c57e788';

/// Provider that returns the latest message

@ProviderFor(latestMessage)
const latestMessageProvider = LatestMessageProvider._();

/// Provider that returns the latest message

final class LatestMessageProvider extends $FunctionalProvider<
        AsyncValue<MessageModel?>, MessageModel?, FutureOr<MessageModel?>>
    with $FutureModifier<MessageModel?>, $FutureProvider<MessageModel?> {
  /// Provider that returns the latest message
  const LatestMessageProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'latestMessageProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$latestMessageHash();

  @$internal
  @override
  $FutureProviderElement<MessageModel?> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<MessageModel?> create(Ref ref) {
    return latestMessage(ref);
  }
}

String _$latestMessageHash() => r'14ecfbf68c882c085813899db5f4322978522c5f';

/// Provider for reactive chat updates

@ProviderFor(chatMessagesStream)
const chatMessagesStreamProvider = ChatMessagesStreamProvider._();

/// Provider for reactive chat updates

final class ChatMessagesStreamProvider extends $FunctionalProvider<
        AsyncValue<List<MessageModel>>,
        List<MessageModel>,
        Stream<List<MessageModel>>>
    with
        $FutureModifier<List<MessageModel>>,
        $StreamProvider<List<MessageModel>> {
  /// Provider for reactive chat updates
  const ChatMessagesStreamProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'chatMessagesStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$chatMessagesStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<MessageModel>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<MessageModel>> create(Ref ref) {
    return chatMessagesStream(ref);
  }
}

String _$chatMessagesStreamHash() =>
    r'292816d94bf0515741af90976b277b6bb1397b2a';
