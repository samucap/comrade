import '../core/rive_controller.dart';

/// Represents a chat message in the conversation
class MessageModel {
  const MessageModel({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.emotion,
  });

  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final AvatarEmotion? emotion;

  /// Create a user message
  factory MessageModel.user(String content) {
    return MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );
  }

  /// Create a companion message
  factory MessageModel.companion(String content, {AvatarEmotion? emotion}) {
    return MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
      emotion: emotion,
    );
  }

  /// Create a copy with modified fields
  MessageModel copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    AvatarEmotion? emotion,
  }) {
    return MessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      emotion: emotion ?? this.emotion,
    );
  }

  /// Check if the message is from the user
  bool get isFromUser => isUser;

  /// Check if the message is from the companion
  bool get isFromCompanion => !isUser;

  /// Get a formatted timestamp string
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MessageModel &&
        other.id == id &&
        other.content == content &&
        other.isUser == isUser &&
        other.timestamp == timestamp &&
        other.emotion == emotion;
  }

  @override
  int get hashCode {
    return Object.hash(id, content, isUser, timestamp, emotion);
  }

  @override
  String toString() {
    return 'MessageModel(id: $id, content: $content, isUser: $isUser, timestamp: $timestamp, emotion: $emotion)';
  }
}

