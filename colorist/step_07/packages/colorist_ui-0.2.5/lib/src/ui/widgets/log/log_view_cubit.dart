import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../colorist_ui.dart';
import '../../../cubit/log_cubit.dart';
import '../../utils/utils.dart';
import 'log.dart';

/// A view that displays a scrollable list of log entries using Bloc (Cubit).
/// It automatically scrolls to the bottom when new entries are added.
class LogViewCubit extends StatefulWidget {
  const LogViewCubit({super.key});

  @override
  State<LogViewCubit> createState() => _LogViewCubitState();
}

class _LogViewCubitState extends State<LogViewCubit> {
  final _scrollController = ScrollController();
  List<LogEntry>? _previousLogEntries;

  @override
  void dispose() {
    _scrollController.dispose();
    _previousLogEntries = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogCubit, LogState>(
      builder: (context, state) {
        final logEntries = state.logEntries;

        if (logEntries.isEmpty) {
          return const Center(
            child: Text(
              'No log entries yet',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          );
        }

        if (_previousLogEntries != null && _previousLogEntries != logEntries) {
          _scrollController.scrollToBottomAfterFrame();
        }
        _previousLogEntries = logEntries;

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: logEntries.length,
          itemBuilder: (context, index) {
            return LogEntryWidget(entry: logEntries[index]);
          },
        );
      },
    );
  }
}
