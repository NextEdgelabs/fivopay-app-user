import 'package:janseva/utils/constants.dart';

extension AppSizeExtension on num {
  /// Responsive width based on a standard 393 width screen
  double get dw => this * (AppSizes.dW / 393);

  /// Responsive height based on a standard 852 height screen
  double get dh => this * (AppSizes.dH / 852);
}
