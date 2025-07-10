// Copyright 2025 Brett Morgan. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/color_cubit.dart';
import '../../../models/color_state.dart';

/// Displays a colored box representing the currently selected color using Cubit.
class ColorDisplayCubit extends StatelessWidget {
  const ColorDisplayCubit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorCubit, ColorState>(
      builder: (context, state) {
        final colorData = state.currentColor;
        return Container(
          height: 200,
          decoration: BoxDecoration(
            color: colorData.color,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
        );
      },
    );
  }
}
