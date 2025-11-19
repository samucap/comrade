import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/rive_controller.dart';
import '../data/chat_repository.dart';
import '../data/database.dart';
import '../models/message.dart';
import 'avatar_state_provider.dart';

part 'chat_provider.g.dart';

/// Provider for the chat repository
@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  return ChatRepository(database);
}

/// Provider for the app database
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}

/// Provider for chat state management
@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  Future<List<MessageModel>> build() async {
    final repository = ref.watch(chatRepositoryProvider);
    final messages = await repository.getAllMessages();

    // Convert database messages to domain models
    return messages.map((msg) => MessageModel(
      id: msg.id.toString(),
      content: msg.content,
      isUser: msg.isUser,
      timestamp: msg.timestamp,
      emotion: msg.emotionValue,
    )).toList();
  }

  /// Add a user message and trigger AI response
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final repository = ref.read(chatRepositoryProvider);

    // Add user message
    await repository.addUserMessage(content);

    // Set avatar to thinking state
    ref.read(avatarStateNotifierProvider.notifier).setEmotion(AvatarEmotion.thinking);

    // Refresh state
    ref.invalidateSelf();

    // Simulate AI processing delay
    await Future.delayed(const Duration(seconds: 1));

    // Generate and add AI response
    await _generateAIResponse(content);
  }

  /// Generate a mock AI response based on user input
  Future<void> _generateAIResponse(String userMessage) async {
    final repository = ref.read(chatRepositoryProvider);
    final avatarNotifier = ref.read(avatarStateNotifierProvider.notifier);

    // Simple response generation based on keywords
    final response = _generateResponseText(userMessage.toLowerCase());
    final emotion = _generateRandomEmotion();

    // Set avatar to speaking state
    avatarNotifier.setEmotion(AvatarEmotion.speaking);

    // Add companion message
    await repository.addCompanionMessage(response, emotion: emotion);

    // Trigger emotion display
    avatarNotifier.triggerEmotion(emotion);

    // Refresh state
    ref.invalidateSelf();

    // Reset to idle after speaking
    Future.delayed(const Duration(seconds: 2), () {
      avatarNotifier.resetToIdle();
    });
  }

  /// Generate response text based on user input
  String _generateResponseText(String userMessage) {
    final responses = {
      'hello': ['Hi there! Great to meet you!', 'Hello! How are you doing today?'],
      'how are you': ['I\'m doing fantastic, thanks for asking!', 'I\'m wonderful! How about you?'],
      'thank': ['You\'re very welcome!', 'My pleasure!', 'Glad I could help!'],
      'sorry': ['No worries at all!', 'That\'s completely fine!', 'Don\'t worry about it!'],
      'love': ['That\'s so sweet! 😊', 'I appreciate that!', 'You\'re too kind!'],
      'hate': ['I\'m sorry to hear that. Is there anything I can do to help?', 'That sounds tough. Want to talk about it?'],
      'bye': ['Goodbye! It was great chatting with you!', 'See you later!', 'Take care!'],
    };

    for (final entry in responses.entries) {
      if (userMessage.contains(entry.key)) {
        final responseList = entry.value;
        return responseList[userMessage.hashCode % responseList.length];
      }
    }

    // Default responses
    final defaultResponses = [
      'That\'s interesting! Tell me more.',
      'I see! What do you think about that?',
      'Fascinating! How do you feel about it?',
      'Thanks for sharing that with me!',
      'I\'m here to listen. What else is on your mind?',
      'That sounds important. How can I help?',
    ];

    return defaultResponses[userMessage.hashCode % defaultResponses.length];
  }

  /// Generate a random emotion for the response
  AvatarEmotion _generateRandomEmotion() {
    final emotions = [
      AvatarEmotion.happy,
      AvatarEmotion.smirk,
      AvatarEmotion.heartEyes,
      AvatarEmotion.laugh,
      AvatarEmotion.blush,
    ];

    return emotions[DateTime.now().millisecondsSinceEpoch % emotions.length];
  }

  /// Clear all messages
  Future<void> clearChat() async {
    final repository = ref.read(chatRepositoryProvider);
    await repository.clearAllMessages();
    ref.invalidateSelf();
  }

  /// Get message count
  Future<int> getMessageCount() async {
    final repository = ref.read(chatRepositoryProvider);
    return repository.getMessageCount();
  }
}

/// Provider that returns the current chat messages
@riverpod
Future<List<MessageModel>> chatMessages(Ref ref) {
  return ref.watch(chatNotifierProvider.future);
}

/// Provider that returns the latest message
@riverpod
Future<MessageModel?> latestMessage(Ref ref) async {
  final messages = await ref.watch(chatMessagesProvider.future);
  return messages.isNotEmpty ? messages.last : null;
}

/// Provider for reactive chat updates
@riverpod
Stream<List<MessageModel>> chatMessagesStream(Ref ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchAllMessages().map((messages) =>
    messages.map((msg) => MessageModel(
      id: msg.id.toString(),
      content: msg.content,
      isUser: msg.isUser,
      timestamp: msg.timestamp,
      emotion: msg.emotionValue,
    )).toList()
  );
}

