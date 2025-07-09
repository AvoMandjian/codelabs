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

class GeminiTools {
  GeminiTools(this.ref);

  final Ref ref;

  /// Central registry of all Flutter Action FunctionDeclarations.
  static final Map<String, FunctionDeclaration> _actionDeclarations = {
    'navigate_to': FunctionDeclaration(
      'navigate_to',
      'Requests the Flutter frontend to immediately navigate to a new page, replacing the current page in the navigation stack. This action is used when the current page should be discarded and the user should be taken to a new route. The navigation is not reversible by the back button.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "navigate_to" for this action.',
          title: 'navigate_to',
        ),
        'value': Schema.string(
          description:
              'The destination route path to navigate to (for example, "/home" or "/settings").',
        ),
        'meta_data': Schema.object(
          properties: {},
          description:
              'Optional metadata to pass to the next navigation action, such as query parameters or additional state.',
        ),
      },
    ),
    'navigate_push': FunctionDeclaration(
      'navigate_push',
      'Instructs the Flutter frontend to navigate to a new page, pushing the current page onto the navigation stack. This allows the user to return to the previous page using the back button. Use this action for standard forward navigation.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "navigate_push" for this action.',
          title: 'navigate_push',
        ),
        'value': Schema.string(
          description:
              'The destination route path to navigate to (e.g., "/details" or "/profile").',
        ),
        'meta_data': Schema.object(
          properties: {},
          description:
              'Optional metadata to pass to the next navigation action, such as query parameters or state.',
        ),
      },
    ),
    'navigate_back': FunctionDeclaration(
      'navigate_back',
      'Requests the Flutter frontend to navigate back to the previous page in the navigation stack. This simulates a back button press and returns the user to the last visited route.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "navigate_back" for this action.',
          title: 'navigate_back',
        ),
      },
    ),
    'navigate_to_tab': FunctionDeclaration(
      'navigate_to_tab',
      'Directs the Flutter frontend to switch to a specific tab within a tab view, identified by its widget ID. This action is used for tabbed navigation where the user interface contains multiple tabs.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "navigate_to_tab" for this action.',
          title: 'navigate_to_tab',
        ),
        'value': Schema.string(
          description:
              'The unique widget_id of the tab to navigate to (for example, "tab_home" or "tab_settings").',
        ),
      },
    ),
    'close_right_drawer': FunctionDeclaration(
      'close_right_drawer',
      'Requests the Flutter frontend to close the currently open right-side drawer or slide-over panel. Use this action to dismiss any open right drawers in the UI.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "close_right_drawer" for this action.',
          title: 'close_right_drawer',
        ),
      },
    ),
    'close_left_drawer': FunctionDeclaration(
      'close_left_drawer',
      'Requests the Flutter frontend to close the currently open left-side drawer or slide-over panel. Use this action to dismiss any open left drawers in the UI.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "close_left_drawer" for this action.',
          title: 'close_left_drawer',
        ),
      },
    ),
    'refresh_power_list': FunctionDeclaration(
      'refresh_power_list',
      'Instructs the Flutter frontend to refresh the contents of a power list widget. This is used to reload or update the list data, typically after a change in the underlying dataset.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "refresh_power_list" for this action.',
          title: 'refresh_power_list',
        ),
        'value': Schema.string(
          description: 'The unique recordset_id of the power list to refresh.',
        ),
      },
    ),
    'scroll_to_item': FunctionDeclaration(
      'scroll_to_item',
      'Requests the Flutter frontend to scroll a scrollable list to bring a specific item into view, identified by its unique ID. This is useful for focusing on or highlighting a particular list element.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "scroll_to_item" for this action.',
          title: 'scroll_to_item',
        ),
        'value': Schema.string(
          description:
              'The unique ID of the item to scroll to within the list.',
        ),
      },
    ),
    'select_item': FunctionDeclaration(
      'select_item',
      'Instructs the Flutter frontend to simulate a user click and highlight a specific item in a list, identified by its unique ID. This is commonly used to programmatically select or focus on an item.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "select_item" for this action.',
          title: 'select_item',
        ),
        'value': Schema.string(
          description: 'The unique ID of the item to select and highlight.',
        ),
      },
    ),
    'clear_filter': FunctionDeclaration(
      'clear_filter',
      'Requests the Flutter frontend to clear any active filters on a power list widget, restoring the list to its unfiltered state.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "clear_filter" for this action.',
          title: 'clear_filter',
        ),
        'meta_data': Schema.object(
          properties: {},
          description:
              'Optional metadata for filter clearing, such as filter context or previous state.',
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
    'show_loader': FunctionDeclaration(
      'show_loader',
      'Requests the Flutter frontend to display a loading animation or spinner on the screen. This is typically used to indicate that a background operation is in progress.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "show_loader" for this action.',
          title: 'show_loader',
        ),
      },
    ),
    'hide_loader': FunctionDeclaration(
      'hide_loader',
      'Requests the Flutter frontend to hide the loading animation or spinner if it is currently visible. Use this action when background processing is complete.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "hide_loader" for this action.',
          title: 'hide_loader',
        ),
      },
    ),
    'update_widget': FunctionDeclaration(
      'update_widget',
      'Requests the Flutter frontend to refresh or update one or more widgets by calling their refreshWidget method. This is typically used to trigger UI updates for specific widget instances after data changes.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "update_widget" for this action.',
          title: 'update_widget',
        ),
        'update_widgets': Schema.array(
          items: Schema.object(
            properties: {
              'widget_id': Schema.string(
                description:
                    'The unique ID of the widget to notify for update.',
              ),
              'value': Schema.object(
                properties: {},
                description:
                    'The action and value payload to send to the widget for updating.',
              ),
            },
          ),
          description:
              'A list of widgets to update, each with its widget_id and value.',
        ),
      },
    ),
    'open_file': FunctionDeclaration(
      'open_file',
      'Requests the Flutter frontend to open a file in a new tab or view. This is used for displaying file contents to the user, such as documents, images, or other supported file types.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "open_file" for this action.',
          title: 'open_file',
        ),
        'value': Schema.object(
          properties: {
            'file_url': Schema.string(
              description: 'The direct URL or path to the file to be opened.',
            ),
            'file_name': Schema.string(
              description:
                  'The display name of the file to be shown in the UI.',
            ),
          },
          description:
              'An object containing the file_url and file_name for the file to open.',
        ),
      },
    ),
    'open_right_drawer': FunctionDeclaration(
      'open_right_drawer',
      'Requests the Flutter frontend to open a right-side drawer or slide-over panel, displaying the provided widget UI JSON inside the drawer. This is typically used for contextual side panels.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "open_right_drawer" for this action.',
          title: 'open_right_drawer',
        ),
        'value': Schema.object(
          properties: {},
          description:
              'A JSON object describing the widget UI to render inside the right drawer.',
        ),
      },
    ),
    'open_left_drawer': FunctionDeclaration(
      'open_left_drawer',
      'Requests the Flutter frontend to open a left-side drawer or slide-over panel, displaying the provided widget UI JSON inside the drawer. This is typically used for contextual side panels.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "open_left_drawer" for this action.',
          title: 'open_left_drawer',
        ),
        'value': Schema.object(
          properties: {},
          description:
              'A JSON object describing the widget UI to render inside the left drawer.',
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
      'Requests the Flutter frontend to set or replace global metadata for all subsequent actions and payloads. This is useful for passing persistent information throughout a session.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "global_meta_data" for this action.',
          title: 'global_meta_data',
        ),
        'value': Schema.object(
          properties: {},
          description:
              'A JSON object containing keys and values to be set as global metadata for future actions.',
        ),
      },
    ),
    'global_meta_data_merge': FunctionDeclaration(
      'global_meta_data_merge',
      'Requests the Flutter frontend to merge new keys and values into the existing global metadata. This is used to update, but not replace, persistent information for all subsequent actions.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "global_meta_data_merge" for this action.',
          title: 'global_meta_data_merge',
        ),
        'value': Schema.object(
          properties: {},
          description:
              'A JSON object containing keys and values to be merged into the global metadata.',
        ),
      },
    ),
    'show_message': FunctionDeclaration(
      'show_message',
      'Requests the Flutter frontend to display a popup dialog, snackbar, or message notification to the user. This is used for confirmations, alerts, or user feedback.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "show_message" for this action.',
          title: 'show_message',
        ),
        'value': Schema.object(
          properties: {},
          description:
              'A JSON object containing the message, title, and any additional dialog configuration.',
        ),
      },
    ),
    'download_file': FunctionDeclaration(
      'download_file',
      'Requests the Flutter frontend to initiate a file download for the user, using the provided file URL and file name. This is used for exporting or saving files from the app.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "download_file" for this action.',
          title: 'download_file',
        ),
        'value': Schema.object(
          properties: {
            'file_url': Schema.string(
              description:
                  'The direct URL or path to the file to be downloaded.',
            ),
            'file_name': Schema.string(
              description: 'The display name for the downloaded file.',
            ),
          },
        ),
      },
    ),
    'print_file': FunctionDeclaration(
      'print_file',
      'Requests the Flutter frontend to open the print dialog for a given file. This allows the user to print the specified file directly from the application.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "print_file" for this action.',
          title: 'print_file',
        ),
        'value': Schema.object(
          properties: {
            'file_url': Schema.string(
              description: 'The direct URL or path to the file to be printed.',
            ),
            'file_name': Schema.string(
              description: 'The display name of the file for the print dialog.',
            ),
          },
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
        'value': Schema.string(
          description: 'The recordset_id of the form page to refresh.',
        ),
      },
    ),
    'remove_app_cache_ids': FunctionDeclaration(
      'remove_app_cache_ids',
      'Requests the Flutter frontend to remove specific application cache IDs from local storage. This is useful for clearing cached responses or data associated with certain IDs.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "remove_app_cache_ids" for this action.',
          title: 'remove_app_cache_ids',
        ),
        'value': Schema.array(
          items: Schema.string(),
          description: 'A list of app cache IDs to remove from local storage.',
        ),
      },
    ),
    'clear_app_cache_ids': FunctionDeclaration(
      'clear_app_cache_ids',
      'Requests the Flutter frontend to clear all saved responses and data from local storage. This action is used for a complete cache reset.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "clear_app_cache_ids" for this action.',
          title: 'clear_app_cache_ids',
        ),
      },
    ),
    'remove_session_cache_ids': FunctionDeclaration(
      'remove_session_cache_ids',
      'Requests the Flutter frontend to remove specific session cache IDs from session storage. This is useful for clearing cached session data associated with certain IDs.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "remove_session_cache_ids" for this action.',
          title: 'remove_session_cache_ids',
        ),
        'value': Schema.array(
          items: Schema.string(),
          description:
              'A list of session cache IDs to remove from session storage.',
        ),
      },
    ),
    'clear_session_cache_ids': FunctionDeclaration(
      'clear_session_cache_ids',
      'Requests the Flutter frontend to clear all saved responses and data from session storage. This action is used for a complete session cache reset.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "clear_session_cache_ids" for this action.',
          title: 'clear_session_cache_ids',
        ),
      },
    ),
    'open_url': FunctionDeclaration(
      'open_url',
      'Requests the Flutter frontend to open a specified URL in a new browser tab or window. This is used for external links or navigation to web resources.',
      parameters: {
        'flutter_action': Schema.string(
          description:
              'The exact name of the Flutter action being invoked. Always set to "open_url" for this action.',
          title: 'open_url',
        ),
        'value': Schema.string(
          description: 'The URL to open in a new browser tab or window.',
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
      'set_color' => handleSetColor(arguments),
      'navigate_to' => handleNavigateTo(arguments),
      'navigate_push' => handleNavigatePush(arguments),
      'navigate_back' => handleNavigateBack(arguments),
      'navigate_to_tab' => handleNavigateToTab(arguments),
      'close_right_drawer' => handleCloseRightDrawer(arguments),
      'close_left_drawer' => handleCloseLeftDrawer(arguments),
      'refresh_power_list' => handleRefreshPowerList(arguments),
      'scroll_to_item' => handleScrollToItem(arguments),
      'select_item' => handleSelectItem(arguments),
      'clear_filter' => handleClearFilter(arguments),
      'close_menu' => handleCloseMenu(arguments),
      'show_loader' => handleShowLoader(arguments),
      'hide_loader' => handleHideLoader(arguments),
      'update_widget' => handleUpdateWidget(arguments),
      'open_file' => handleOpenFile(arguments),
      'open_right_drawer' => handleOpenRightDrawer(arguments),
      'open_left_drawer' => handleOpenLeftDrawer(arguments),
      'do_action' => handleDoAction(arguments),
      'global_meta_data' => handleGlobalMetaData(arguments),
      'global_meta_data_merge' => handleGlobalMetaDataMerge(arguments),
      'show_message' => handleShowMessage(arguments),
      'download_file' => handleDownloadFile(arguments),
      'print_file' => handlePrintFile(arguments),
      'refresh_form' => handleRefreshForm(arguments),
      'remove_app_cache_ids' => handleRemoveAppCacheIds(arguments),
      'clear_app_cache_ids' => handleClearAppCacheIds(arguments),
      'remove_session_cache_ids' => handleRemoveSessionCacheIds(arguments),
      'clear_session_cache_ids' => handleClearSessionCacheIds(arguments),
      'open_url' => handleOpenUrl(arguments),
      'preload_jinja' => handlePreloadJinja(arguments),
      'combine_flutter_actions' => handleCombineFlutterActions(arguments),
      _ => handleUnknownFunction(functionName),
    };
  }

  // --- Handlers for Flutter Actions ---

  Map<String, Object?> handleCombineFlutterActions(
    Map<String, Object?> arguments,
  ) => _logAndReturn(arguments);
  Map<String, Object?> handleNavigateTo(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleNavigatePush(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleNavigateBack(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleNavigateToTab(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleCloseRightDrawer(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleCloseLeftDrawer(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleRefreshPowerList(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleScrollToItem(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleSelectItem(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleClearFilter(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleCloseMenu(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleShowLoader(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleHideLoader(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleUpdateWidget(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleOpenFile(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleOpenRightDrawer(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleOpenLeftDrawer(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleDoAction(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleGlobalMetaData(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleGlobalMetaDataMerge(
    Map<String, Object?> arguments,
  ) => _logAndReturn(arguments);
  Map<String, Object?> handleShowMessage(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleDownloadFile(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handlePrintFile(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleRefreshForm(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleRemoveAppCacheIds(
    Map<String, Object?> arguments,
  ) => _logAndReturn(arguments);
  Map<String, Object?> handleClearAppCacheIds(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handleRemoveSessionCacheIds(
    Map<String, Object?> arguments,
  ) => _logAndReturn(arguments);
  Map<String, Object?> handleClearSessionCacheIds(
    Map<String, Object?> arguments,
  ) => _logAndReturn(arguments);
  Map<String, Object?> handleOpenUrl(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);
  Map<String, Object?> handlePreloadJinja(Map<String, Object?> arguments) =>
      _logAndReturn(arguments);

  // Existing handlers
  Map<String, Object?> handleSetColor(Map<String, Object?> arguments) {
    final colorStateNotifier = ref.read(colorStateNotifierProvider.notifier);
    final red = (arguments['red'] as num).toDouble();
    final green = (arguments['green'] as num).toDouble();
    final blue = (arguments['blue'] as num).toDouble();
    final functionResults = {
      'success': true,
      'current_color': colorStateNotifier
          .updateColor(red: red, green: green, blue: blue)
          .toLLMContextMap(),
    };

    final logStateNotifier = ref.read(logStateNotifierProvider.notifier);
    logStateNotifier.logFunctionResults(functionResults);
    return functionResults;
  }

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
GeminiTools geminiTools(Ref ref) => GeminiTools(ref);
