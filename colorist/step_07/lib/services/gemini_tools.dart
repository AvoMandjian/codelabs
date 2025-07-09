// Copyright 2025 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:colorist_ui/colorist_ui.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemini_tools.g.dart';

class GeminiTools {
  GeminiTools(this.ref);

  final Ref ref;

  FunctionDeclaration get setColorFuncDecl => FunctionDeclaration(
    'set_color',
    'Set the color of the display square based on red, green, and blue values.',
    parameters: {
      'red': Schema.number(description: 'Red component value (0.0 - 1.0)'),
      'green': Schema.number(description: 'Green component value (0.0 - 1.0)'),
      'blue': Schema.number(description: 'Blue component value (0.0 - 1.0)'),
    },
  );

  // --- Flutter Actions FunctionDeclarations ---
  FunctionDeclaration get navigateToFuncDecl => FunctionDeclaration(
    'navigate_to',
    'Navigates to a new page, replacing the current page in the navigation stack.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'navigate_to',
      ),
      'value': Schema.string(description: 'The path to navigate to'),
      'meta_data': Schema.object(
        properties: {},
        description: 'Optional metadata for the next action',
      ),
    },
  );

  FunctionDeclaration get navigatePushFuncDecl => FunctionDeclaration(
    'navigate_push',
    'Navigates to a new page, pushing the current page onto the navigation stack.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'navigate_push',
      ),
      'value': Schema.string(description: 'The path to navigate to'),
      'meta_data': Schema.object(
        properties: {},
        description: 'Optional metadata for the next action',
      ),
    },
  );

  FunctionDeclaration get navigateBackFuncDecl => FunctionDeclaration(
    'navigate_back',
    'Navigates back to the previous page in the navigation stack.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'navigate_back',
      ),
    },
  );

  FunctionDeclaration get navigateToTabFuncDecl => FunctionDeclaration(
    'navigate_to_tab',
    'Navigates to a specific tab within a tab view by its widget_id.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'navigate_to_tab',
      ),
      'value': Schema.string(
        description: 'The widget_id of the tab to navigate to',
      ),
    },
  );

  FunctionDeclaration get closeRightDrawerFuncDecl => FunctionDeclaration(
    'close_right_drawer',
    'Closes the currently open right drawer.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'close_right_drawer',
      ),
    },
  );

  FunctionDeclaration get closeLeftDrawerFuncDecl => FunctionDeclaration(
    'close_left_drawer',
    'Closes the currently open left drawer.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'close_left_drawer',
      ),
    },
  );

  FunctionDeclaration get refreshPowerListFuncDecl => FunctionDeclaration(
    'refresh_power_list',
    'Refreshes the power list widget.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'refresh_power_list',
      ),
      'value': Schema.string(description: 'The recordset_id of the list'),
    },
  );

  FunctionDeclaration get scrollToItemFuncDecl => FunctionDeclaration(
    'scroll_to_item',
    'Scrolls to a specific item in a scrollable list by its ID.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'scroll_to_item',
      ),
      'value': Schema.string(description: 'The ID of the item to scroll to'),
    },
  );

  FunctionDeclaration get selectItemFuncDecl => FunctionDeclaration(
    'select_item',
    'Simulates a click and highlights the specified item by its ID.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'select_item',
      ),
      'value': Schema.string(description: 'The ID of the item to select'),
    },
  );

  FunctionDeclaration get clearFilterFuncDecl => FunctionDeclaration(
    'clear_filter',
    'Clears the filter of the power list widget.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'clear_filter',
      ),
      'meta_data': Schema.object(
        properties: {},
        description: 'Optional metadata',
      ),
    },
  );

  FunctionDeclaration get closeMenuFuncDecl => FunctionDeclaration(
    'close_menu',
    'Closes the options menu in the header.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'close_menu',
      ),
    },
  );

  FunctionDeclaration get showLoaderFuncDecl => FunctionDeclaration(
    'show_loader',
    'Shows a loading animation on the screen.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'show_loader',
      ),
    },
  );

  FunctionDeclaration get hideLoaderFuncDecl => FunctionDeclaration(
    'hide_loader',
    'Hides the loading animation if it is visible.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'hide_loader',
      ),
    },
  );

  FunctionDeclaration get updateWidgetFuncDecl => FunctionDeclaration(
    'update_widget',
    'Calls the refreshWidget method of the widget.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'update_widget',
      ),
      'update_widgets': Schema.array(
        items: Schema.object(
          properties: {
            'widget_id': Schema.string(description: 'The widget id to notify'),
            'value': Schema.object(
              properties: {},
              description: 'Action and value for widget',
            ),
          },
        ),
        description: 'List of widgets to update',
      ),
    },
  );

  FunctionDeclaration get openFileFuncDecl => FunctionDeclaration(
    'open_file',
    'Opens the file in a new tab.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'open_file',
      ),
      'value': Schema.object(
        properties: {
          'file_url': Schema.string(description: 'URL of the file'),
          'file_name': Schema.string(description: 'Name of the file'),
        },
        description: 'Object containing file URL and name',
      ),
    },
  );

  FunctionDeclaration get openRightDrawerFuncDecl => FunctionDeclaration(
    'open_right_drawer',
    'Opens the right slide over.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'open_right_drawer',
      ),
      'value': Schema.object(
        properties: {},
        description: 'Widget UI JSON within the slide over',
      ),
    },
  );

  FunctionDeclaration get openLeftDrawerFuncDecl => FunctionDeclaration(
    'open_left_drawer',
    'Opens the left slide over.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'open_left_drawer',
      ),
      'value': Schema.object(
        properties: {},
        description: 'Widget UI JSON within the slide over',
      ),
    },
  );

  FunctionDeclaration get doActionFuncDecl => FunctionDeclaration(
    'do_action',
    'Allows calling any do_action.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'do_action',
      ),
      'meta_data': Schema.object(
        properties: {},
        description: 'Payload for do_action',
      ),
    },
  );

  FunctionDeclaration get globalMetaDataFuncDecl => FunctionDeclaration(
    'global_meta_data',
    'Adds keys and values to the payload globally (replaces global meta data).',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'global_meta_data',
      ),
      'value': Schema.object(
        properties: {},
        description: 'Object to be passed to subsequent payloads',
      ),
    },
  );

  FunctionDeclaration get globalMetaDataMergeFuncDecl => FunctionDeclaration(
    'global_meta_data_merge',
    'Adds keys and values to the payload globally (merges with global meta data).',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'global_meta_data_merge',
      ),
      'value': Schema.object(
        properties: {},
        description: 'Object to be merged to subsequent payloads',
      ),
    },
  );

  FunctionDeclaration get showMessageFuncDecl => FunctionDeclaration(
    'show_message',
    'Shows a popup dialogue or snackbar.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'show_message',
      ),
      'value': Schema.object(
        properties: {},
        description: 'Confirmation/message dialog data',
      ),
    },
  );

  FunctionDeclaration get downloadFileFuncDecl => FunctionDeclaration(
    'download_file',
    'Downloads the file.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'download_file',
      ),
      'value': Schema.object(
        properties: {
          'file_url': Schema.string(description: 'URL of the file'),
          'file_name': Schema.string(description: 'Name of the file'),
        },
      ),
    },
  );

  FunctionDeclaration get printFileFuncDecl => FunctionDeclaration(
    'print_file',
    'Opens the print dialog.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'print_file',
      ),
      'value': Schema.object(
        properties: {
          'file_url': Schema.string(description: 'URL of the file'),
          'file_name': Schema.string(description: 'Name of the file'),
        },
      ),
    },
  );

  FunctionDeclaration get refreshFormFuncDecl => FunctionDeclaration(
    'refresh_form',
    'Refreshes the recordset form screen.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'refresh_form',
      ),
      'value': Schema.string(description: 'The recordset_id of the page'),
    },
  );

  FunctionDeclaration get removeAppCacheIdsFuncDecl => FunctionDeclaration(
    'remove_app_cache_ids',
    'Removes specific app cache ids from local storage.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'remove_app_cache_ids',
      ),
      'value': Schema.array(
        items: Schema.string(),
        description: 'List of app cache ids',
      ),
    },
  );

  FunctionDeclaration get clearAppCacheIdsFuncDecl => FunctionDeclaration(
    'clear_app_cache_ids',
    'Clears all saved responses in local storage.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'clear_app_cache_ids',
      ),
    },
  );

  FunctionDeclaration get removeSessionCacheIdsFuncDecl => FunctionDeclaration(
    'remove_session_cache_ids',
    'Removes specific session cache ids from session storage.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'remove_session_cache_ids',
      ),
      'value': Schema.array(
        items: Schema.string(),
        description: 'List of session cache ids',
      ),
    },
  );

  FunctionDeclaration get clearSessionCacheIdsFuncDecl => FunctionDeclaration(
    'clear_session_cache_ids',
    'Clears all saved responses in session storage.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'clear_session_cache_ids',
      ),
    },
  );

  FunctionDeclaration get openUrlFuncDecl => FunctionDeclaration(
    'open_url',
    'Opens a link in a new tab or browser.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'open_url',
      ),
      'value': Schema.string(description: 'The URL to open'),
    },
  );

  FunctionDeclaration get preloadJinjaFuncDecl => FunctionDeclaration(
    'preload_jinja',
    'Saves jinja scripts in local storage for later usage.',
    parameters: {
      'flutter_action': Schema.string(
        description: 'The flutter action to perform',
        title: 'preload_jinja',
      ),
      'value': Schema.array(
        items: Schema.object(properties: {'jinja_script_id': Schema.string()}),
        description: 'List of jinja scripts and their ids',
      ),
    },
  );
  FunctionDeclaration get combineFlutterActionsFuncDecl => FunctionDeclaration(
    'combine_flutter_actions',
    'Combines multiple flutter actions into a single JSON object.',
    parameters: {
      'flutter_actions': Schema.array(
        items: Schema.object(
          properties: {
            'flutter_action': Schema.string(
              description: 'the action that is being called',
            ),
            'value': Schema.object(
              properties: {},
              description: 'the JSON of the flutter action',
            ),
          },
          description: 'Flutter action',
        ),
        description: 'List of flutter actions',
      ),
    },
  );

  List<Tool> get tools => [
    Tool.functionDeclarations([
      setColorFuncDecl,
      navigateToFuncDecl,
      navigatePushFuncDecl,
      navigateBackFuncDecl,
      navigateToTabFuncDecl,
      closeRightDrawerFuncDecl,
      closeLeftDrawerFuncDecl,
      refreshPowerListFuncDecl,
      scrollToItemFuncDecl,
      selectItemFuncDecl,
      clearFilterFuncDecl,
      closeMenuFuncDecl,
      showLoaderFuncDecl,
      hideLoaderFuncDecl,
      updateWidgetFuncDecl,
      openFileFuncDecl,
      openRightDrawerFuncDecl,
      openLeftDrawerFuncDecl,
      doActionFuncDecl,
      globalMetaDataFuncDecl,
      globalMetaDataMergeFuncDecl,
      showMessageFuncDecl,
      downloadFileFuncDecl,
      printFileFuncDecl,
      refreshFormFuncDecl,
      removeAppCacheIdsFuncDecl,
      clearAppCacheIdsFuncDecl,
      removeSessionCacheIdsFuncDecl,
      clearSessionCacheIdsFuncDecl,
      openUrlFuncDecl,
      preloadJinjaFuncDecl,
      combineFlutterActionsFuncDecl,
    ]),
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
