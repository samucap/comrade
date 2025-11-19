import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import '../models/message.dart';
import '../core/rive_controller.dart';
import '../providers/avatar_state_provider.dart';
import '../providers/chat_provider.dart';
import 'chat_bubble.dart';

/// Animated list widget for displaying chat messages
class MessageList extends HookConsumerWidget {
  const MessageList({
    super.key,
    this.scrollController,
    this.padding = const EdgeInsets.all(16),
  });

  final ScrollController? scrollController;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(chatMessagesProvider);
    final avatarState = ref.watch(avatarStateNotifierProvider);

    return messagesAsync.when(
      data: (messages) => _buildMessageList(context, messages, avatarState),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading messages: $error'),
      ),
    );
  }

  Widget _buildMessageList(
    BuildContext context,
    List<MessageModel> messages,
    AvatarEmotion avatarState,
  ) {
    return ListView.builder(
      controller: scrollController,
      padding: padding,
      reverse: true, // Newest messages at bottom
      itemCount: messages.length + (avatarState == AvatarEmotion.thinking ? 1 : 0),
      itemBuilder: (context, index) {
        // Show typing indicator when thinking
        if (avatarState == AvatarEmotion.thinking && index == 0) {
          return const TypingChatBubble();
        }

        final messageIndex = avatarState == AvatarEmotion.thinking
            ? index - 1
            : index;

        if (messageIndex < 0 || messageIndex >= messages.length) {
          return const SizedBox.shrink();
        }

        final message = messages[messageIndex];
        final isLast = messageIndex == messages.length - 1;

        return ChatBubble(
          message: message,
          animate: isLast, // Only animate the most recent message
        );
      },
    );
  }
}

/// Scrollable message list with auto-scroll functionality
class AutoScrollMessageList extends StatefulWidget {
  const AutoScrollMessageList({
    super.key,
    this.padding = const EdgeInsets.all(16),
    this.autoScroll = true,
  });

  final EdgeInsets padding;
  final bool autoScroll;

  @override
  State<AutoScrollMessageList> createState() => _AutoScrollMessageListState();
}

class _AutoScrollMessageListState extends State<AutoScrollMessageList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // Auto-scroll to bottom when new messages arrive
        if (widget.autoScroll &&
            notification is ScrollUpdateNotification &&
            _scrollController.hasClients &&
            _scrollController.position.pixels > _scrollController.position.maxScrollExtent - 100) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        }
        return false;
      },
      child: MessageList(
        scrollController: _scrollController,
        padding: widget.padding,
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0, // Since list is reversed, 0 is the bottom
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}

/// Compact message list for smaller screens
class CompactMessageList extends HookConsumerWidget {
  const CompactMessageList({
    super.key,
    this.scrollController,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  final ScrollController? scrollController;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(chatMessagesProvider);
    final avatarState = ref.watch(avatarStateNotifierProvider);

    return messagesAsync.when(
      data: (messages) => ListView.builder(
        controller: scrollController,
        padding: padding,
        reverse: true,
        itemCount: messages.length + (avatarState == AvatarEmotion.thinking ? 1 : 0),
        itemBuilder: (context, index) {
          if (avatarState == AvatarEmotion.thinking && index == 0) {
            return Container(
              margin: const EdgeInsets.only(left: 8, right: 32, bottom: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                child: TypingIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
              ),
            );
          }

          final messageIndex = avatarState == AvatarEmotion.thinking
              ? index - 1
              : index;

          if (messageIndex < 0 || messageIndex >= messages.length) {
            return const SizedBox.shrink();
          }

          final message = messages[messageIndex];
          return CompactChatBubble(message: message);
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}

/// Message list with search functionality
class SearchableMessageList extends HookConsumerWidget {
  const SearchableMessageList({
    super.key,
    this.scrollController,
    this.padding = const EdgeInsets.all(16),
    this.searchQuery = '',
  });

  final ScrollController? scrollController;
  final EdgeInsets padding;
  final String searchQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(chatMessagesProvider);

    return messagesAsync.when(
      data: (messages) {
        final filteredMessages = searchQuery.isEmpty
            ? messages
            : messages.where((msg) =>
                msg.content.toLowerCase().contains(searchQuery.toLowerCase())).toList();

        return ListView.builder(
          controller: scrollController,
          padding: padding,
          reverse: true,
          itemCount: filteredMessages.length,
          itemBuilder: (context, index) {
            final message = filteredMessages[index];
            return ChatBubble(
              message: message,
              animate: false, // No animation for search results
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading messages: $error'),
      ),
    );
  }
}

/// Message list with date separators
class DatedMessageList extends HookConsumerWidget {
  const DatedMessageList({
    super.key,
    this.scrollController,
    this.padding = const EdgeInsets.all(16),
  });

  final ScrollController? scrollController;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(chatMessagesProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return messagesAsync.when(
      data: (messages) {
        final datedMessages = _groupMessagesByDate(messages);

        return ListView.builder(
          controller: scrollController,
          padding: padding,
          reverse: true,
          itemCount: datedMessages.length,
          itemBuilder: (context, index) {
            final group = datedMessages[index];

            return Column(
              children: [
                // Date separator
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formatDate(group.date),
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Messages for this date
                ...group.messages.map((message) => ChatBubble(
                  message: message,
                  showTimestamp: false, // Date separator shows date
                )),
              ],
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading messages: $error'),
      ),
    );
  }

  List<DateMessageGroup> _groupMessagesByDate(List<MessageModel> messages) {
    final groups = <DateMessageGroup>[];
    DateTime? currentDate;

    for (final message in messages) {
      final messageDate = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );

      if (currentDate == null || currentDate != messageDate) {
        currentDate = messageDate;
        groups.add(DateMessageGroup(date: messageDate, messages: []));
      }

      groups.last.messages.add(message);
    }

    return groups;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}

/// Helper class for grouping messages by date
class DateMessageGroup {
  const DateMessageGroup({
    required this.date,
    required this.messages,
  });

  final DateTime date;
  final List<MessageModel> messages;
}

