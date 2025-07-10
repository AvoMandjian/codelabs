// Copyright 2025 Brett Morgan. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/chat_state.dart';
import '../models/message.dart';

/// A Cubit that manages the state of a chat conversation.
/// This cubit allows adding user and LLM messages, clearing the chat,
/// appending to existing messages, and finalizing messages.
class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState.initial());

  /// Adds a new user message to the chat and returns the newly added message.
  Message addUserMessage(String content) {
    emit(state.addUserMessage(content));
    return state.messages.last;
  }

  /// Adds a new LLM (Large Language Model) message to the chat and returns
  /// the newly added message. The [content] parameter is the text content of
  /// the LLM's message and the [messageState] parameter indicates the current
  /// state of the message (e.g., complete, streaming).
  Message addLlmMessage(String content, MessageState messageState) {
    emit(state.addLlmMessage(content, messageState));
    return state.messages.last;
  }

  /// Create a new LLM message to the chat and return the newly created message.
  /// Append content with the [appendToMessage] method, and finalize the message
  /// with [finalizeMessage].
  Message createLlmMessage() => addLlmMessage('', MessageState.streaming);

  /// Appends additional content to an existing message in the chat.
  /// Takes the [id] of the message to append to, and the text to append as
  /// [addContent].
  void appendToMessage(String id, String addContent) {
    emit(state.appendToMessage(id, addContent));
  }

  /// Finalizes a message in the chat, marking it as complete and trimming
  /// trailing whitespace. The call takes the [id] of the message to finalize.
  void finalizeMessage(String id) {
    emit(state.finalizeMessage(id));
  }

  /// Reset state.
  void reset() {
    emit(ChatState.initial());
  }
}
