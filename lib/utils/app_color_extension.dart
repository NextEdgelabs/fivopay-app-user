import 'package:flutter/material.dart';
import 'app_color.dart';

/// Extension on BuildContext to easily access app colors
extension AppColorExtension on BuildContext {
  /// Get the current theme's custom colors
  NewAppColors get appColors {
    final extension = Theme.of(this).extension<NewAppColors>();
    if (extension == null) {
      throw Exception(
        'NewAppColors extension not found in theme. '
        'Make sure to add it in ThemeData extensions.',
      );
    }
    return extension;
  }

  /// Quick access to check if current theme is dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Quick access to ColorScheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Quick access to TextTheme
  TextTheme get textTheme => Theme.of(this).textTheme;
}

/// Extension on NewAppColors for color variations and utilities
extension ColorVariations on NewAppColors {
  /// Get a lighter shade of the brand color
  Color get brandColorLight => Color.lerp(brandColor, Colors.white, 0.3)!;

  /// Get a darker shade of the brand color
  Color get brandColorDark => Color.lerp(brandColor, Colors.black, 0.2)!;

  /// Get a very light shade of the brand color (for backgrounds)
  Color get brandColorVeryLight => Color.lerp(brandColor, Colors.white, 0.8)!;

  /// Get brand color with opacity
  Color brandColorWithOpacity(double opacity) =>
      brandColor.withOpacity(opacity);

  /// Get gradient colors as a list
  List<Color> get brandGradient => [gradientOne, gradientTwo];

  /// Create a linear gradient from gradient colors (top-left to bottom-right)
  LinearGradient get brandLinearGradient => LinearGradient(
        colors: brandGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// Create a vertical gradient (top to bottom)
  LinearGradient get brandVerticalGradient => LinearGradient(
        colors: brandGradient,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  /// Create a horizontal gradient (left to right)
  LinearGradient get brandHorizontalGradient => LinearGradient(
        colors: brandGradient,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  /// Create a radial gradient
  RadialGradient get brandRadialGradient => RadialGradient(
        colors: brandGradient,
        center: Alignment.center,
        radius: 0.8,
      );

  /// Success color with opacity
  Color successWithOpacity(double opacity) => alert1.withOpacity(opacity);

  /// Success color light variant
  Color get successLight => Color.lerp(alert1, Colors.white, 0.3)!;

  /// Error color with opacity
  Color errorWithOpacity(double opacity) => alert2.withOpacity(opacity);

  /// Error color light variant
  Color get errorLight => Color.lerp(alert2, Colors.white, 0.3)!;

  /// Warning color with opacity
  Color warningWithOpacity(double opacity) => alert3.withOpacity(opacity);

  /// Warning color light variant
  Color get warningLight => Color.lerp(alert3, Colors.white, 0.3)!;

  /// Info color with opacity
  Color infoWithOpacity(double opacity) => alert4.withOpacity(opacity);

  /// Info color light variant
  Color get infoLight => Color.lerp(alert4, Colors.white, 0.3)!;

  /// Get shadow color with custom opacity
  Color shadowWithOpacity(double opacity) => Colors.black.withOpacity(opacity);
}

/// Helper class for common color operations
class AppColorHelper {
  AppColorHelper._(); // Private constructor to prevent instantiation

  /// Convert hex string to Color
  /// Accepts formats: 'RRGGBB', '#RRGGBB', 'AARRGGBB', '#AARRGGBB'
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    String cleanHex = hexString.replaceFirst('#', '');
    
    if (cleanHex.length == 6) {
      buffer.write('ff'); // Add full opacity if not specified
    }
    buffer.write(cleanHex);
    
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Convert Color to hex string (without alpha)
  static String toHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  /// Convert Color to hex string (with alpha)
  static String toHexWithAlpha(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }

  /// Lighten a color by percentage (0.0 to 1.0)
  static Color lighten(Color color, double percentage) {
    assert(percentage >= 0 && percentage <= 1, 'Percentage must be between 0 and 1');
    return Color.lerp(color, Colors.white, percentage)!;
  }

  /// Darken a color by percentage (0.0 to 1.0)
  static Color darken(Color color, double percentage) {
    assert(percentage >= 0 && percentage <= 1, 'Percentage must be between 0 and 1');
    return Color.lerp(color, Colors.black, percentage)!;
  }

  /// Mix two colors with a given percentage
  static Color mix(Color color1, Color color2, double percentage) {
    assert(percentage >= 0 && percentage <= 1, 'Percentage must be between 0 and 1');
    return Color.lerp(color1, color2, percentage)!;
  }

  /// Adjust color saturation
  static Color adjustSaturation(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final saturation = (hsl.saturation + amount).clamp(0.0, 1.0);
    return hsl.withSaturation(saturation).toColor();
  }

  /// Adjust color lightness
  static Color adjustLightness(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Get complementary color (opposite on color wheel)
  static Color complementary(Color color) {
    final hsl = HSLColor.fromColor(color);
    final hue = (hsl.hue + 180) % 360;
    return hsl.withHue(hue).toColor();
  }

  /// Check if color is light or dark
  static bool isLight(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5;
  }

  /// Get contrasting text color (black or white) based on background
  static Color getContrastingTextColor(Color backgroundColor) {
    return isLight(backgroundColor) ? Colors.black : Colors.white;
  }

  /// Calculate contrast ratio between two colors
  static double contrastRatio(Color color1, Color color2) {
    final lum1 = color1.computeLuminance();
    final lum2 = color2.computeLuminance();
    final lighter = lum1 > lum2 ? lum1 : lum2;
    final darker = lum1 > lum2 ? lum2 : lum1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Check if contrast ratio meets WCAG AA standard (4.5:1 for normal text)
  static bool meetsWCAGAA(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= 4.5;
  }

  /// Check if contrast ratio meets WCAG AAA standard (7:1 for normal text)
  static bool meetsWCAGAAA(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= 7.0;
  }
}

/// Extension on Color for additional utilities
extension ColorExtension on Color {
  /// Convert color to hex string
  String toHex() => AppColorHelper.toHex(this);

  /// Convert color to hex string with alpha
  String toHexWithAlpha() => AppColorHelper.toHexWithAlpha(this);

  /// Lighten the color
  Color lighten([double amount = 0.1]) => AppColorHelper.lighten(this, amount);

  /// Darken the color
  Color darken([double amount = 0.1]) => AppColorHelper.darken(this, amount);

  /// Get complementary color
  Color get complementary => AppColorHelper.complementary(this);

  /// Check if color is light
  bool get isLight => AppColorHelper.isLight(this);

  /// Check if color is dark
  bool get isDark => !isLight;

  /// Get contrasting text color
  Color get contrastingTextColor => AppColorHelper.getContrastingTextColor(this);

  /// Adjust saturation
  Color adjustSaturation(double amount) => AppColorHelper.adjustSaturation(this, amount);

  /// Adjust lightness
  Color adjustLightness(double amount) => AppColorHelper.adjustLightness(this, amount);
}
