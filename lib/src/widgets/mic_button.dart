import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/chat_provider.dart';

/// Simplified microphone button that triggers a chat message on tap
class MicButton extends ConsumerWidget {
  const MicButton({
    super.key,
    this.size = 80,
  });

  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        // Simple tap triggers a chat message
        ref.read(chatNotifierProvider.notifier).sendMessage("Hello!");
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.primaryContainer],
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Icon(
          Icons.mic_none,
          color: colorScheme.onPrimary,
          size: size * 0.4,
        ),
      ),
    );
  }
}

/// Simple mic button with tap instruction overlay
class InstructionalMicButton extends StatelessWidget {
  const InstructionalMicButton({
    super.key,
    this.size = 80,
    this.showInstructions = true,
  });

  final double size;
  final bool showInstructions;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        MicButton(size: size),
        if (showInstructions)
          Positioned(
            bottom: size * 0.7,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                'Tap to chat',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
