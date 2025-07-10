import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/chat_state.dart';
import '../models/message.dart';

/// Cubit to manage chat state, migrated from ChatStateNotifier (Riverpod)
class ChatCubit extends Cubit<ChatState> {
  /// TEMP: Global instance for migration hack. Remove after full migration.
  static late ChatCubit globalInstance;

  ChatCubit() : super(ChatState.initial()) {
    // Set global instance for non-widget access (temporary, for migration only)
    globalInstance = this;
  }

  /// Adds a new user message to the chat and returns the newly added message.
  Message addUserMessage(String content) {
    emit(state.addUserMessage(content));
    return state.messages.last;
  }

  /// Adds a new LLM (Large Language Model) message to the chat and returns it.
  Message addLlmMessage(String content, MessageState messageState) {
    emit(state.addLlmMessage(content, messageState));
    return state.messages.last;
  }

  /// Create a new LLM message in streaming state.
  Message createLlmMessage() => addLlmMessage('', MessageState.streaming);

  /// Appends additional content to an existing message in the chat.
  void appendToMessage(String id, String addContent) {
    emit(state.appendToMessage(id, addContent));
  }

  /// Finalizes a message in the chat, marking it as complete and trimming whitespace.
  void finalizeMessage(String id) {
    emit(state.finalizeMessage(id));
  }

  /// Reset state.
  void reset() {
    emit(ChatState.initial());
  }
}
