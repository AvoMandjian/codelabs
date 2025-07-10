import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/log_state.dart';

/// Cubit to manage log state, migrated from LogStateNotifier (Riverpod)
class LogCubit extends Cubit<LogState> {
  /// TEMP: Global instance for migration hack. Remove after full migration.
  static late LogCubit globalInstance;

  LogCubit() : super(LogState.initial()) {
    // Set global instance for non-widget access (temporary, for migration only)
    globalInstance = this;
  }

  /// Adds a new user text log entry.
  void logUserText(String text) {
    emit(state.logUserText(text));
  }

  /// Adds a new LLM text log entry.
  void logLlmText(String text) {
    emit(state.logLlmText(text));
  }

  /// Adds a new function call log entry.
  void logFunctionCall(String functionName, Map<String, Object?> args) {
    emit(state.logFunctionCall(functionName, args));
  }

  /// Adds a new function results log entry.
  void logFunctionResults(Map<String, Object?> results) {
    emit(state.logFunctionResults(results));
  }

  /// Adds a new error log entry.
  void logError(Object e, {StackTrace? st}) {
    emit(state.logError(e, st: st));
  }

  /// Adds a new warning log entry.
  void logWarning(String warning) {
    emit(state.logWarning(warning));
  }

  /// Adds a new info log entry.
  void logInfo(String info) {
    emit(state.logInfo(info));
  }

  /// Resets the log state to initial (empty).
  void reset() {
    emit(LogState.initial());
  }
}
