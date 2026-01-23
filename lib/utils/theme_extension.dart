import 'package:flutter/material.dart';
import 'package:janseva/utils/app_color.dart';

extension ThemeExtensions on BuildContext {
  /// Get the AppColors extension from the current theme
  NewAppColors get colors => Theme.of(this).extension<NewAppColors>()!;
}
