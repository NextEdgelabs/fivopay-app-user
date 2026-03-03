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
    bgColors: Color(0xFF0A0F1A), // Deep dark blue-black
    specialCard: Color(0xFF14192A), // Dark card with blue tint
    specialCardTwo: Color(0xFF1A2138), // Slightly lighter card
    cardBackground: Color(0xFF121829), // Card background with blue
    navBar: Color(0xFF080D18), // Darker navigation bar
    popupBg: Color(0xFF14192A), // Popup background
    smallCardBg: Color(0xFF161D30), // Small card background
    searchFieldFill: Color(0xFF151C2F), // Search field fill
    // Text Colors (Dark Mode)
    heading: Color(0xFFE6F0FF), // Light blue-white for headings
    subheading: Color(0xFFC5D9F5), // Soft blue-gray for subheadings
    text: Color(0xFFB8D4F0), // Blue-tinted text
    textSecondary: Color(0xFFA2BCD8), // Secondary text with blue
    subtext: Color(0xFF8899B8), // Muted blue-gray
    navBarText: Color(0xFFA6BDD8), // Nav bar text
    buttonLabelText: Color(0xFFFFFBFF), // Button label text
    disableButtonText: Color(0xFF7C8CA8), // Disabled text
    // Brand & Accent Colors
    brandColor: Color(0xFF3D7AFF), // Primary brand blue (lighter for dark mode)
    gradientOne: Color(0xFF2A64D9), // Gradient start (primary blue)
    gradientTwo: Color(0xFF5B96FF), // Gradient end (lighter blue)
    // Interactive Elements
    backIcon: Color(0xFF6B8AAE), // Back icon color
    backIconBorder: Color(0xFF1F2A3D), // Back icon border
    divider: Color(0xFF1F2838), // Divider lines
    border: Color(0xFF2F3D52), // Border color
    fieldBorder: Color(0xFF2E3A4F), // Field border
    selectedField: Color(0xFF1F2D42), // Selected field background
    disabled: Color(0xFF1E2534), // Disabled state
    // Status & Alert Colors
    alert1: Color(0xFF4ADE80), // Success green
    alert2: Color(0xFFEF4444), // Error red
    alert3: Color(0xFFFBBC05), // Warning amber
    alert4: Color(0xFF3D7AFF), // Info blue
    call: Color(0xFF86EFAC), // Call green
    // Legacy/Special Colors
    famerStrokeGrey: Color(0xFF3D4A5F),
    famerStrokeOrange: Color(0xFFC4D9F7),
    buttonColorLight: Color(0xFF1F2D42),
    textLight: Color(0xFFC5C7CB),
    // alert4: Color(0xFF5416D8), // Info purple (secondary brand)
    // call: Color(0xFF86EFAC), // Call green
    // // Legacy/Special Colors
    // famerStrokeGrey: Color(0xFF344047),
    // famerStrokeOrange: Color(0xFFECF9FF),
    // buttonColorLight: Color(0xFF1F2F3A),
    // textLight: Color.fromARGB(255, 255, 255, 255),
  );
  static const light = NewAppColors(
    textLight: Color.fromARGB(255, 231, 231, 231),
    // Background & Surface Colors (Light Mode)
    bgColors: Color(0xFFF5F8FD), // Very light blue-white background
    specialCard: Color.fromARGB(255, 255, 255, 255), // Pure white card
    specialCardTwo: Color(0xFFE8F0FC), // Slightly darker blue card
    cardBackground: Color(0xFFF5F8FD), // Card background with blue tint
    navBar: Color(0xFFFAFBFF), // Navigation bar
    popupBg: Color(0xFFFFFFFF), // Pure white popup
    smallCardBg: Color(0xFFF7F9FD), // Small card background
    searchFieldFill: Color(0xFFF0F5FC), // Search field fill
    // Text Colors (Light Mode)
    heading: Color(0xFF1F2D42), // Deep blue-black for headings
    subheading: Color(0xFF354A68), // Dark blue for subheadings
    text: Color.fromARGB(255, 0, 0, 0), // Dark Black text
    textSecondary: Color(0xFF777777), // Secondary gray text
    subtext: Color(0xFF8F9DBB), // Muted blue text
    navBarText: Color(0xFF687B9A), // Nav bar text
    buttonLabelText: Color(0xFFFFFFFF), // White button text
    disableButtonText: Color(0xFFAAB8CC), // Disabled text
    // Brand & Accent Colors
    brandColor: Color(0xFF2A64D9), // Primary brand blue
    gradientOne: Color(0xFF2A64D9), // Gradient start (brand)
    gradientTwo: Color(0xFF5B96FF), // Gradient end (lighter blue)
    // Interactive Elements
    backIcon: Color(0xFF526B8A), // Back icon color
    backIconBorder: Color(0xFFDDE8F5), // Back icon border
    divider: Color(0xFFE0EBFA), // Divider lines
    border: Color(0xFFDCDCDC), // Border color
    fieldBorder: Color(0xFFC3D5EF), // Field border
    selectedField: Color(0xFFE6F0FF), // Selected field background
    disabled: Color(0xFFE6F0F8), // Disabled state
    // Status & Alert Colors
    alert1: Color(0xFF22C55E), // Success green
    alert2: Color(0xFFDC2626), // Error red
    alert3: Color(0xFFF59E0B), // Warning amber
    alert4: Color(0xFF2A64D9), // Info blue
    call: Color(0xFF4ADE80), // Call green
    // Legacy/Special Colors
    famerStrokeGrey: Color(0xFF8F9DBB),
    famerStrokeOrange: Color(0xFFC4D9F7),
    buttonColorLight: Color(0xFFEBF3FF),
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
