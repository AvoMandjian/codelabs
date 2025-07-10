// Copyright 2025 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:colorist_ui/colorist_ui.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemini_tools.g.dart';

/// Handles backend-driven Flutter Actions and color commands for the app.
///
/// - All Flutter Actions are declared in a single static map for maintainability.
/// - All handlers except `set_color` are auto-generated to log and return payloads.
/// - Adding a new action is a one-line change in the `_actionDeclarations` map.

class FlutterActionsTools {
  FlutterActionsTools(this.ref);

  final Ref ref;

  /// Central registry of all Flutter Action FunctionDeclarations.
  static final Map<String, FunctionDeclaration> _actionDeclarations = {
    'navigate': FunctionDeclaration(
      'navigate',
      '''
Handles all navigation-related actions in the Flutter frontend.  
Set the "flutter_action" parameter to specify the type of navigation to perform.

Supported values for "flutter_action":
- "navigate_to": Replaces the current page with a new one. The user cannot return via the back button.
- "navigate_push": Pushes a new page onto the navigation stack. The user can return via the back button.
- "navigate_back": Pops the current page, returning to the previous one.
- "navigate_to_tab": Switches to a tab identified by its widget ID.

Required parameters per action:
- "navigate_to": requires "value" (String), optional "meta_data" (Object)
- "navigate_push": requires "value" (String), optional "meta_data" (Object)
- "navigate_back": no additional parameters
- "navigate_to_tab": requires "value" (String)
''',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The navigation action to perform. Must be one of: "navigate_to", "navigate_push", "navigate_back", or "navigate_to_tab".',
          title: 'Navigation Type',
        ),
        'value': Schema.string(
          description:
              'The target route (e.g., "/home", "/settings") or tab ID, depending on the action.',
        ),
        'meta_data': Schema.object(
          properties: {},
          description:
              'Optional object passed to the next page. Useful for query parameters, extra state, or context.',
        ),
      },
    ),
    'drawer': FunctionDeclaration(
      'drawer',
      '''
Handles all drawer-related actions in the Flutter frontend.
Set the "flutter_action".

Supported values for "flutter_action":
- "close_right_drawer": Closes the currently open right drawer.
- "close_left_drawer": Closes the currently open left drawer.
- "open_right_drawer": Opens a drawer and displays the provided widget UI JSON inside (value) must be a widget UI JSON object.
- "open_left_drawer": Opens a drawer and displays the provided widget UI JSON inside (value) must be a widget UI JSON object.
''',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The drawer operation to perform. Must be one of the Supported values for "flutter_action".',
          title: 'Drawer Action',
        ),
        'value': Schema.object(
          properties: {},
          description:
              'Widget UI JSON to render inside the drawer (required for "open" action only).',
          title: 'Drawer Side',
        ),
      },
    ),
    'widget_action': FunctionDeclaration(
      'widget_action',
      '''
Handles all widget and list-related actions in the Flutter frontend.
Set the "flutter_action" parameter to specify the widget/list operation.

Supported values for "flutter_action":
- "update_widget": Refreshes or updates one or more widgets. Requires "update_widgets" (array of objects with "widget_id" and "value").
- "refresh_power_list": Refreshes the contents of a power list widget. Requires "value" (string, recordset_id).
- "scroll_to_item": Scrolls a list to bring a specific item into view. Requires "value" (string, item ID).
- "select_item": Simulates a click/highlight on a specific item. Requires "value" (string, item ID).
- "clear_filter": Clears active filters on a power list. Optional "meta_data" (object).
''',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The widget or list operation to perform. Must be one of: "update_widget", "refresh_power_list", "scroll_to_item", "select_item", or "clear_filter".',
          title: 'Widget/List Action',
        ),
        'update_widgets': Schema.array(
          items: Schema.object(
            properties: {
              'widget_id': Schema.string(
                description: 'The unique ID of the widget to update.',
              ),
              'value': Schema.object(
                properties: {},
                description: 'The payload to send to the widget for updating.',
              ),
            },
          ),
          description:
              'A list of widgets to update (required for "update_widget").',
        ),
        'value': Schema.string(
          description:
              'The target recordset_id, item ID, or other string value (required for "refresh_power_list", "scroll_to_item", or "select_item").',
        ),
        'meta_data': Schema.object(
          properties: {},
          description:
              'Optional metadata for filter clearing (used with "clear_filter").',
        ),
      },
    ),
    'close_menu': FunctionDeclaration(
      'close_menu',
      'Instructs the Flutter frontend to close the currently open options or context menu in the application header. Use this action to dismiss any visible menu overlays.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "close_menu" for this action.',
          title: 'close_menu',
        ),
      },
    ),
    'loader': FunctionDeclaration(
      'loader',
      '''
Handles all loader-related actions in the Flutter frontend.
Set the "flutter_action" parameter to specify the loader operation.

Supported values for "flutter_action":
- "show_loader": Displays a loading animation or spinner on the screen.
- "hide_loader": Hides the loading animation or spinner.

No additional parameters are required for these actions.
''',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The loader operation to perform. Must be either "show_loader" or "hide_loader".',
          title: 'Loader Action',
        ),
      },
    ),
    'do_action': FunctionDeclaration(
      'do_action',
      'Requests the Flutter frontend to execute a generic or custom action, passing along any metadata required for the action. Use this for extensibility or actions not covered by other specific declarations.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "do_action" for this action.',
          title: 'do_action',
        ),
        'meta_data': Schema.object(
          properties: {},
          description:
              'A payload object containing any parameters or data needed for the custom action.',
        ),
      },
    ),
    'global_meta_data': FunctionDeclaration(
      'global_meta_data',
      '''
Handles all global metadata actions in the Flutter frontend.
Set the "flutter_action" parameter to specify the metadata operation.

Supported values for "flutter_action":
- "global_meta_data": Sets global metadata for the current session or UI context. Requires "value" (object with key-value pairs to set).
- "global_meta_data_merge": Merges the provided metadata into existing global metadata. Only the specified keys will be updated or added. Requires "value" (object with key-value pairs to merge).
''',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The metadata operation to perform. Must be either "global_meta_data" or "global_meta_data_merge".',
          title: 'Global Metadata Action',
        ),
        'value': Schema.object(
          properties: {},
          description:
              'A JSON object containing keys and values to set or merge as global metadata. Required for both actions.',
        ),
      },
    ),
    'refresh_form': FunctionDeclaration(
      'refresh_form',
      'Requests the Flutter frontend to refresh the current recordset form screen, reloading its data and UI. This is typically used after a form submission or data update.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "refresh_form" for this action.',
          title: 'refresh_form',
        ),
        'value': Schema.array(
          items: Schema.string(),
          description:
              'A list of cache IDs to remove (required for "remove_app_cache_ids" and "remove_session_cache_ids" only).',
        ),
      },
    ),
    'preload_jinja': FunctionDeclaration(
      'preload_jinja',
      'Requests the Flutter frontend to save (preload) Jinja scripts in local storage for later use. This is useful for caching templates or scripts that will be needed in future actions.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "preload_jinja" for this action.',
          title: 'preload_jinja',
        ),
        'value': Schema.array(
          items: Schema.object(
            properties: {'jinja_script_id': Schema.string()},
          ),
          description:
              'A list of Jinja scripts and their associated IDs to be preloaded.',
        ),
      },
    ),
    'combine_flutter_actions': FunctionDeclaration(
      'combine_flutter_actions',
      'Requests the Flutter frontend to execute a sequence of multiple Flutter actions in the given order. This allows for orchestrating complex UI flows by combining several actions into a single batch.',
      parameters: {
        'flutter_actions': Schema.array(
          items: Schema.object(
            properties: {
              'flutter_action': Schema.string(
                description:
                    'The name of the action to be called as part of the sequence.',
              ),
              'value': Schema.object(
                properties: {},
                description:
                    'The JSON payload for the specific flutter action in the sequence.',
              ),
            },
            description:
                'A single Flutter action and its parameters to combine.',
          ),
          description:
              'A list of Flutter actions to execute in sequence as a single batch.',
        ),
      },
    ),
    'cache': FunctionDeclaration(
      'cache',
      '''
Handles all cache-related actions in the Flutter frontend.
Set the "flutter_action" parameter to specify the cache operation.

Supported values for "flutter_action":
- "remove_app_cache_ids": Removes specific application cache IDs from local storage. Requires "value" (array of strings).
- "clear_app_cache_ids": Clears all saved responses and data from local storage. No additional parameters required.
- "remove_session_cache_ids": Removes specific session cache IDs from session storage. Requires "value" (array of strings).
- "clear_session_cache_ids": Clears all saved responses and data from session storage. No additional parameters required.
''',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The cache operation to perform. Must be one of: "remove_app_cache_ids", "clear_app_cache_ids", "remove_session_cache_ids", or "clear_session_cache_ids".',
          title: 'Cache Action',
        ),
        'value': Schema.array(
          items: Schema.string(),
          description:
              'A list of cache IDs to remove (required for "remove_app_cache_ids" and "remove_session_cache_ids" only).',
        ),
      },
    ),
    'file': FunctionDeclaration(
      'file',
      '''
Handles all file-related actions in the Flutter frontend.
Set the "flutter_action" parameter to specify the file operation.

Supported values for "flutter_action":
- "open_file": Opens a file in a new tab or view. Requires "value" (object with "file_url" and "file_name").
- "download_file": Initiates a file download for the user. Requires "value" (object with "file_url" and "file_name").
- "print_file": Opens the print dialog for a file. Requires "value" (object with "file_url" and "file_name").
''',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The file operation to perform. Must be one of: "open_file", "download_file", or "print_file".',
          title: 'File Action',
        ),
        'value': Schema.object(
          properties: {
            'file_url': Schema.string(
              description: 'The direct URL or path to the file.',
            ),
            'file_name': Schema.string(
              description:
                  'The display name of the file (for UI, download, or print dialog). if not provided by the user, take the name from URL',
            ),
          },
          description:
              'Object containing "file_url" and "file_name". Required for all file actions.',
        ),
      },
    ),
  };

  /// Returns all tools (FunctionDeclarations).

  List<Tool> get tools => [
    Tool.functionDeclarations([..._actionDeclarations.values]),
  ];

  Map<String, Object?> handleFunctionCall(
    String functionName,
    Map<String, Object?> arguments,
  ) {
    final logStateNotifier = ref.read(logStateNotifierProvider.notifier);
    logStateNotifier.logFunctionCall(functionName, arguments);
    return switch (functionName) {
      'navigate' => handleNavigate(arguments),
      'drawer' => handleDrawer(arguments),
      'loader' => handleLoader(arguments),
      'cache' => handleCache(arguments),
      'file' => handleFile(arguments),
      'widget_action' => handleWidgetAction(arguments),
      'global_meta_data' => handleGlobalMetaData(arguments),
      'preload_jinja' => handlePreloadJinja(arguments),
      'combine_flutter_actions' => handleCombineFlutterActions(arguments),
      'close_menu' => handleCloseMenu(arguments),
      'do_action' => handleDoAction(arguments),
      'refresh_form' => handleRefreshForm(arguments),
      _ => handleUnknownFunction(functionName),
    };
  }

  // --- Refactored Handlers for Combined Flutter Actions ---

  Map<String, Object?> handleCombineFlutterActions(
    Map<String, Object?> arguments,
  ) => _logAndReturn(arguments);
  Map<String, Object?> handleCloseMenu(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleDoAction(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleRefreshForm(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);

  Map<String, Object?> handleNavigate(Map<String, Object?> arguments) {
    final action = arguments['flutter_action'];
    switch (action) {
      case 'navigate_to':
      case 'navigate_push':
      case 'navigate_back':
      case 'navigate_to_tab':
        return _logAndReturn(arguments);
      default:
        return _unknownFlutterAction('navigate', action, arguments);
    }
  }

  Map<String, Object?> handleDrawer(Map<String, Object?> arguments) {
    final action = arguments['flutter_action'];
    switch (action) {
      case 'open_right_drawer':
      case 'open_left_drawer':
      case 'close_right_drawer':
      case 'close_left_drawer':
        return _logAndReturn(arguments);
      default:
        return _unknownFlutterAction('drawer', action, arguments);
    }
  }

  Map<String, Object?> handleLoader(Map<String, Object?> arguments) {
    final action = arguments['flutter_action'];
    switch (action) {
      case 'show_loader':
      case 'hide_loader':
        return _logAndReturn(arguments);
      default:
        return _unknownFlutterAction('loader', action, arguments);
    }
  }

  Map<String, Object?> handleCache(Map<String, Object?> arguments) {
    final action = arguments['flutter_action'];
    switch (action) {
      case 'remove_app_cache_ids':
      case 'clear_app_cache_ids':
      case 'remove_session_cache_ids':
      case 'clear_session_cache_ids':
        return _logAndReturn(arguments);
      default:
        return _unknownFlutterAction('cache', action, arguments);
    }
  }

  Map<String, Object?> handleFile(Map<String, Object?> arguments) {
    final action = arguments['flutter_action'];
    switch (action) {
      case 'open_file':
      case 'download_file':
      case 'print_file':
        return _logAndReturn(arguments);
      default:
        return _unknownFlutterAction('file', action, arguments);
    }
  }

  Map<String, Object?> handleWidgetAction(Map<String, Object?> arguments) {
    final action = arguments['flutter_action'];
    switch (action) {
      case 'update_widget':
      case 'refresh_power_list':
      case 'scroll_to_item':
      case 'select_item':
      case 'clear_filter':
        return _logAndReturn(arguments);
      default:
        return _unknownFlutterAction('widget_action', action, arguments);
    }
  }

  Map<String, Object?> handleGlobalMetaData(Map<String, Object?> arguments) {
    final action = arguments['flutter_action'];
    switch (action) {
      case 'global_meta_data':
      case 'global_meta_data_merge':
        return _logAndReturn(arguments);
      default:
        return _unknownFlutterAction('global_meta_data', action, arguments);
    }
  }

  Map<String, Object?> _unknownFlutterAction(
    String group,
    Object? action,
    Map<String, Object?> arguments,
  ) => {
    'error': 'Unknown flutter_action "$action" for group "$group"',
    'arguments': arguments,
  };

  Map<String, Object?> handlePreloadJinja(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);

  Map<String, Object?> _logAndReturn(Map<String, Object?> arguments) {
    final logStateNotifier = ref.read(logStateNotifierProvider.notifier);
    logStateNotifier.logFunctionResults(arguments);
    return {'success': true, ...arguments};
  }

  Map<String, Object?> handleUnknownFunction(String functionName) {
    final logStateNotifier = ref.read(logStateNotifierProvider.notifier);
    logStateNotifier.logWarning('Unsupported function call $functionName');
    return {
      'success': false,
      'reason': 'Unsupported function call $functionName',
    };
  }
}

@riverpod
FlutterActionsTools geminiTools(Ref ref) => FlutterActionsTools(ref);
