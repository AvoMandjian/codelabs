import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/chat_cubit.dart';
import '../../../models/chat_state.dart';
import '../../../models/message.dart';
import 'chat.dart';

/// Widget that displays a list of chat messages using ChatCubit (Bloc).
class MessagesListCubit extends StatefulWidget {
  const MessagesListCubit({super.key, this.onPressedVoiceOutput});

  final Function(String text)? onPressedVoiceOutput;

  @override
  State<MessagesListCubit> createState() => _MessagesListCubitState();
}

class _MessagesListCubitState extends State<MessagesListCubit> {
  final _scrollController = ScrollController();
  List<Message>? _previousMessages;

  @override
  void dispose() {
    _scrollController.dispose();
    _previousMessages = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final messages = state.messages;

        if (messages.isEmpty) {
          return const Center(
            child: Text(
              'Describe a color to get started',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          );
        }

        // TODO: Add chat message list rendering, voice output, etc.
        // For now, just show a placeholder for migrated structure.
        return ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            // Replace with your actual message widget
            return MessageBubble(
              message: message,
              onPressedVoiceOutput: widget.onPressedVoiceOutput,
            );
          },
        );
      },
    );
  }
}
