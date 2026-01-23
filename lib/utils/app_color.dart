import 'package:flutter/material.dart';

/// Custom theme extension for app-specific colors
class NewAppColors extends ThemeExtension<NewAppColors> {
  final Color specialCard;
  final Color specialCardTwo;
  final Color textSecondary;
  final Color border;
  final Color disabled;

  // Additional colors

  final Color brandColor;
  final Color gradientOne;
  final Color gradientTwo;
  final Color famerStrokeGrey;
  final Color famerStrokeOrange;
  final Color heading;
  final Color subheading;
  final Color subtext;
  final Color text;
  final Color textLight;
  final Color cardBackground;
  final Color navBar;
  final Color backIcon;
  final Color backIconBorder;
  final Color buttonLabelText;
  final Color navBarText;
  final Color disableButtonText;
  final Color divider;
  final Color fieldBorder;
  final Color selectedField;
  final Color smallCardBg;
  final Color alert1;
  final Color alert2;
  final Color popupBg;
  final Color searchFieldFill;
  final Color alert3;
  final Color call;
  final Color alert4;
  final Color bgColors;
  final Color buttonColorLight;

  const NewAppColors({
    required this.specialCard,
    required this.specialCardTwo,
    required this.textSecondary,
    required this.border,
    required this.disabled,
    required this.bgColors,
    required this.textLight,

    // Extra colors
    required this.brandColor,
    required this.gradientOne,
    required this.gradientTwo,
    required this.famerStrokeGrey,
    required this.famerStrokeOrange,
    required this.heading,
    required this.subheading,
    required this.subtext,
    required this.text,
    required this.cardBackground,
    required this.navBar,
    required this.backIcon,
    required this.backIconBorder,
    required this.buttonLabelText,
    required this.navBarText,
    required this.disableButtonText,
    required this.divider,
    required this.fieldBorder,
    required this.selectedField,
    required this.smallCardBg,
    required this.alert1,
    required this.alert2,
    required this.popupBg,
    required this.searchFieldFill,
    required this.alert3,
    required this.call,
    required this.alert4,
    required this.buttonColorLight,
  });

  static const dark = NewAppColors(
    // Background & Surface Colors (Dark Mode)
    bgColors: Color(0xFF0F0A15), // Deep dark purple-black
    specialCard: Color(0xFF1C1420), // Dark card with purple tint
    specialCardTwo: Color(0xFF221828), // Slightly lighter card
    cardBackground: Color(0xFF1A1522), // Card background with purple
    navBar: Color(0xFF0D0812), // Darker navigation bar
    popupBg: Color(0xFF1C1420), // Popup background
    smallCardBg: Color(0xFF1F1625), // Small card background
    searchFieldFill: Color(0xFF1D1723), // Search field fill
    // Text Colors (Dark Mode)
    heading: Color(0xFFF0E6F5), // Light purple-white for headings
    subheading: Color(0xFFD4C5DC), // Soft purple-gray for subheadings
    text: Color(0xFFC8B8D4), // Purple-tinted text
    textSecondary: Color(0xFFB4A2C0), // Secondary text with purple
    subtext: Color(0xFF9688A6), // Muted purple-gray
    navBarText: Color(0xFFB8A6C4), // Nav bar text
    buttonLabelText: Color(0xFFF5F0FA), // Button label text
    disableButtonText: Color(0xFF8A7C98), // Disabled text
    // Brand & Accent Colors
    brandColor: Color(0xFFAD2DBA), // Primary brand purple (ARGB 255,173,45,186)
    gradientOne: Color(0xFFAD2DBA), // Gradient start (brand)
    gradientTwo: Color(0xFFC855D4), // Gradient end (lighter purple)
    // Interactive Elements
    backIcon: Color(0xFF8A7298), // Back icon color
    backIconBorder: Color(0xFF2D2235), // Back icon border
    divider: Color(0xFF2B2133), // Divider lines
    border: Color(0xFF3D2F47), // Border color
    fieldBorder: Color(0xFF3A2E44), // Field border
    selectedField: Color(0xFF2D1F3A), // Selected field background
    disabled: Color(0xFF2A2232), // Disabled state
    // Status & Alert Colors
    alert1: Color(0xFF4ADE80), // Success green
    alert2: Color(0xFFEF4444), // Error red
    alert3: Color(0xFFFBBC05), // Warning amber
    alert4: Color(0xFF8B5CF6), // Info purple
    call: Color(0xFF86EFAC), // Call green
    // Legacy/Special Colors
    famerStrokeGrey: Color(0xFF3D3447),
    famerStrokeOrange: Color(0xFFE8C4F7),
    buttonColorLight: Color(0xFF2D1F3A),
    textLight: Color(0xFF777777),
  );
  static const light = NewAppColors(
    textLight: Color.fromARGB(255, 231, 231, 231),
    // Background & Surface Colors (Light Mode)
    bgColors: Color(0xFFF6F6F6), // Very light purple-white background
    specialCard: Color.fromARGB(255, 255, 255, 255), // Light purple card
    specialCardTwo: Color(0xFFEAD9F2), // Slightly darker purple card
    cardBackground: Color(0xFFF8F2FC), // Card background with purple tint
    navBar: Color(0xFFFFFAFF), // Navigation bar
    popupBg: Color(0xFFFFFFFF), // Pure white popup
    smallCardBg: Color(0xFFFBF7FD), // Small card background
    searchFieldFill: Color(0xFFF5EFFA), // Search field fill
    // Text Colors (Light Mode)
    heading: Color(0xFF2D1F3A), // Deep purple-black for headings
    subheading: Color(0xFF4A3558), // Dark purple for subheadings
    text: Color.fromARGB(255, 0, 0, 0), // Dark Black text
    textSecondary: Color(0xFF777777), // Secondary purple-gray text
    subtext: Color(0xFF9D8FAA), // Muted purple text
    navBarText: Color(0xFF7A6888), // Nav bar text
    buttonLabelText: Color(0xFFFFFFFF), // White button text
    disableButtonText: Color(0xFFB8AABF), // Disabled text
    // Brand & Accent Colors
    brandColor: Color(0xFFAD2DBA), // Primary brand purple (ARGB 255,173,45,186)
    gradientOne: Color(0xFFAD2DBA), // Gradient start (brand)
    gradientTwo: Color(0xFFC855D4), // Gradient end (lighter purple)
    // Interactive Elements
    backIcon: Color(0xFF6B5278), // Back icon color
    backIconBorder: Color(0xFFE8DDF0), // Back icon border
    divider: Color(0xFFEBE0F2), // Divider lines
    border: Color(0xFFDCDCDC), // Border color with purple
    fieldBorder: Color(0xFFD6C3E3), // Field border
    selectedField: Color(0xFFF2E6FA), // Selected field background
    disabled: Color(0xFFF0E6F5), // Disabled state
    // Status & Alert Colors
    alert1: Color(0xFF22C55E), // Success green
    alert2: Color(0xFFDC2626), // Error red
    alert3: Color(0xFFF59E0B), // Warning amber
    alert4: Color(0xFF9333EA), // Info purple
    call: Color(0xFF4ADE80), // Call green
    // Legacy/Special Colors
    famerStrokeGrey: Color(0xFF9D8FAA),
    famerStrokeOrange: Color(0xFFE8C4F7),
    buttonColorLight: Color(0xFFF5EBFA),
  );

  @override
  ThemeExtension<NewAppColors> copyWith({
    Color? specialCard,
    Color? specialCardTwo,
    Color? textSecondary,
    Color? border,
    Color? disabled,
    Color? brandColor,
    Color? gradientOne,
    Color? gradientTwo,
    Color? famerStrokeGrey,
    Color? famerStrokeOrange,
    Color? heading,
    Color? subheading,
    Color? subtext,
    Color? text,
    Color? cardBackground,
    Color? navBar,
    Color? backIcon,
    Color? backIconBorder,
    Color? buttonLabelText,
    Color? navBarText,
    Color? disableButtonText,
    Color? divider,
    Color? fieldBorder,
    Color? selectedField,
    Color? smallCardBg,
    Color? alert1,
    Color? alert2,
    Color? popupBg,
    Color? searchFieldFill,
    Color? alert3,
    Color? call,
    Color? alert4,
    Color? bgColors,
    Color? buttonColorLight,
    Color? textLight,
  }) {
    return NewAppColors(
      textLight: textLight ?? this.textLight,
      bgColors: bgColors ?? this.bgColors,
      specialCard: specialCard ?? this.specialCard,
      specialCardTwo: specialCardTwo ?? this.specialCardTwo,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      disabled: disabled ?? this.disabled,
      brandColor: brandColor ?? this.brandColor,
      gradientOne: gradientOne ?? this.gradientOne,
      gradientTwo: gradientTwo ?? this.gradientTwo,
      famerStrokeGrey: famerStrokeGrey ?? this.famerStrokeGrey,
      famerStrokeOrange: famerStrokeOrange ?? this.famerStrokeOrange,
      heading: heading ?? this.heading,
      subheading: subheading ?? this.subheading,
      subtext: subtext ?? this.subtext,
      text: text ?? this.text,
      cardBackground: cardBackground ?? this.cardBackground,
      navBar: navBar ?? this.navBar,
      backIcon: backIcon ?? this.backIcon,
      backIconBorder: backIconBorder ?? this.backIconBorder,
      buttonLabelText: buttonLabelText ?? this.buttonLabelText,
      navBarText: navBarText ?? this.navBarText,
      disableButtonText: disableButtonText ?? this.disableButtonText,
      divider: divider ?? this.divider,
      fieldBorder: fieldBorder ?? this.fieldBorder,
      selectedField: selectedField ?? this.selectedField,
      smallCardBg: smallCardBg ?? this.smallCardBg,
      alert1: alert1 ?? this.alert1,
      alert2: alert2 ?? this.alert2,
      popupBg: popupBg ?? this.popupBg,
      searchFieldFill: searchFieldFill ?? this.searchFieldFill,
      alert3: alert3 ?? this.alert3,
      call: call ?? this.call,
      alert4: alert4 ?? this.alert4,
      buttonColorLight: buttonColorLight ?? this.buttonColorLight,
    );
  }

  @override
  ThemeExtension<NewAppColors> lerp(
    ThemeExtension<NewAppColors>? other,
    double t,
  ) {
    if (other is! NewAppColors) return this;
    return NewAppColors(
      textLight: Color.lerp(textLight, other.textLight, t)!,
      bgColors: Color.lerp(bgColors, other.bgColors, t)!,
      specialCard: Color.lerp(specialCard, other.specialCard, t)!,
      specialCardTwo: Color.lerp(specialCardTwo, other.specialCardTwo, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      brandColor: Color.lerp(brandColor, other.brandColor, t)!,
      gradientOne: Color.lerp(gradientOne, other.gradientOne, t)!,
      gradientTwo: Color.lerp(gradientTwo, other.gradientTwo, t)!,
      famerStrokeGrey: Color.lerp(famerStrokeGrey, other.famerStrokeGrey, t)!,
      famerStrokeOrange: Color.lerp(
        famerStrokeOrange,
        other.famerStrokeOrange,
        t,
      )!,
      heading: Color.lerp(heading, other.heading, t)!,
      subheading: Color.lerp(subheading, other.subheading, t)!,
      subtext: Color.lerp(subtext, other.subtext, t)!,
      text: Color.lerp(text, other.text, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      navBar: Color.lerp(navBar, other.navBar, t)!,
      backIcon: Color.lerp(backIcon, other.backIcon, t)!,
      backIconBorder: Color.lerp(backIconBorder, other.backIconBorder, t)!,
      buttonLabelText: Color.lerp(buttonLabelText, other.buttonLabelText, t)!,
      navBarText: Color.lerp(navBarText, other.navBarText, t)!,
      disableButtonText: Color.lerp(
        disableButtonText,
        other.disableButtonText,
        t,
      )!,
      divider: Color.lerp(divider, other.divider, t)!,
      fieldBorder: Color.lerp(fieldBorder, other.fieldBorder, t)!,
      selectedField: Color.lerp(selectedField, other.selectedField, t)!,
      smallCardBg: Color.lerp(smallCardBg, other.smallCardBg, t)!,
      alert1: Color.lerp(alert1, other.alert1, t)!,
      alert2: Color.lerp(alert2, other.alert2, t)!,
      popupBg: Color.lerp(popupBg, other.popupBg, t)!,
      searchFieldFill: Color.lerp(searchFieldFill, other.searchFieldFill, t)!,
      alert3: Color.lerp(alert3, other.alert3, t)!,
      call: Color.lerp(call, other.call, t)!,
      alert4: Color.lerp(alert4, other.alert4, t)!,
      buttonColorLight: Color.lerp(
        buttonColorLight,
        other.buttonColorLight,
        t,
      )!,
    );
  }
}
