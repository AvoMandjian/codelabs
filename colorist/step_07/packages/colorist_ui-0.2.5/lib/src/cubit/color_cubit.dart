// Copyright 2025 Brett Morgan. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/color_state.dart';
import '../models/color_data.dart';

/// A Cubit that manages the state of the color picker, including
/// selecting colors from history, updating the current color, and resetting.
class ColorCubit extends Cubit<ColorState> {
  /// TEMP: Global instance for migration hack. Remove after full migration.
  static late ColorCubit globalInstance;

  ColorCubit() : super(ColorState.initial()) {
    // Set global instance for non-widget access (temporary, for migration only)
    globalInstance = this;
  }

  /// Selects a color from the color history and updates the current color.
  void selectColorFromHistory(int index) {
    emit(state.selectColorFromHistory(index));
  }

  /// Updates the current color with new [red], [green], and [blue] values.
  ColorData updateColor({
    required double red,
    required double green,
    required double blue,
  }) {
    emit(state.updateColor(red: red, green: green, blue: blue));
    return state.currentColor;
  }

  /// Resets the color state to initial values.
  void reset() {
    emit(ColorState.initial());
  }
}
