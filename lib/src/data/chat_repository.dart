import 'package:drift/drift.dart';
import 'database.dart';
import '../core/rive_controller.dart';

/// Repository for managing chat messages
class ChatRepository {
  ChatRepository(this._database);

  final AppDatabase _database;

  /// Get all messages as a stream (reactive updates)
  Stream<List<Message>> watchAllMessages() {
    return _database.select(_database.messages).watch();
  }

  /// Get all messages as a future (one-time fetch)
  Future<List<Message>> getAllMessages() {
    return _database.getAllMessages();
  }

  /// Add a new user message
  Future<Message> addUserMessage(String content) async {
    final companion = MessagesCompanion.insert(
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );

    final id = await _database.insertMessage(companion);
    final messages = await _database.getAllMessages();
    return messages.firstWhere((msg) => msg.id == id);
  }

  /// Add a new companion message with emotion
  Future<Message> addCompanionMessage(
    String content, {
    AvatarEmotion? emotion,
  }) async {
    final companion = MessagesCompanion.insert(
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
      emotion: emotion != null ? Value(emotion) : const Value.absent(),
    );

    final id = await _database.insertMessage(companion);
    final messages = await _database.getAllMessages();
    return messages.firstWhere((msg) => msg.id == id);
  }

  /// Clear all messages
  Future<void> clearAllMessages() async {
    await _database.deleteAllMessages();
  }

  /// Get messages after a specific timestamp
  Future<List<Message>> getMessagesAfter(DateTime timestamp) {
    return _database.getMessagesAfter(timestamp);
  }

  /// Get the latest message
  Future<Message?> getLatestMessage() async {
    final messages = await _database.getAllMessages();
    return messages.isNotEmpty ? messages.first : null;
  }

  /// Get message count
  Future<int> getMessageCount() async {
    final count = await _database.customSelect(
      'SELECT COUNT(*) as count FROM messages',
      readsFrom: {_database.messages},
    ).getSingle();
    return count.read<int>('count');
  }
}

/// Extension methods for Message entity
extension MessageExtension on Message {
  /// Get the emotion as AvatarEmotion enum
  AvatarEmotion? get emotionValue => AvatarEmotionDatabaseExtension.fromDatabaseValue(emotion);
}

/// Data class for chat message display
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.emotion,
  });

  final int id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final AvatarEmotion? emotion;

  /// Create from database Message entity
  factory ChatMessage.fromDatabase(Message message) {
    return ChatMessage(
      id: message.id,
      content: message.content,
      isUser: message.isUser,
      timestamp: message.timestamp,
      emotion: message.emotionValue,
    );
  }

  /// Convert to database companion for insertion
  MessagesCompanion toCompanion() {
    return MessagesCompanion.insert(
      content: content,
      isUser: isUser,
      timestamp: timestamp,
      emotion: emotion != null ? Value(emotion!) : const Value.absent(),
    );
  }

  /// Create a copy with modified fields
  ChatMessage copyWith({
    int? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    AvatarEmotion? emotion,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      emotion: emotion ?? this.emotion,
    );
  }
}

