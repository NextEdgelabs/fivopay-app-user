import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:janseva/utils/app_color.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      background: AppColors.background,
      error: AppColors.error,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      colorScheme: colorScheme,
      scaffoldBackgroundColor: NewAppColors.light.bgColors,
      extensions: [NewAppColors.light],

      appBarTheme: AppBarTheme(
        backgroundColor: NewAppColors.light.bgColors,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.heading3,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: AppColors.shadow,
        margin: const EdgeInsets.all(0),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          shadowColor: AppColors.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
          textStyle: AppTextStyles.button,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
          textStyle: AppTextStyles.button.copyWith(color: colorScheme.primary),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: AppTextStyles.body1.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM,
          vertical: AppSizes.paddingM,
        ),
        hintStyle: AppTextStyles.body1.copyWith(color: AppColors.textLight),
        labelStyle: AppTextStyles.body1.copyWith(
          color: AppColors.textSecondary,
        ),
        errorStyle: AppTextStyles.caption.copyWith(color: AppColors.error),
      ),

      chipTheme: ChipThemeData(
        labelStyle: AppTextStyles.body2,
        secondaryLabelStyle: AppTextStyles.body2,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM,
          vertical: AppSizes.paddingS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          side: const BorderSide(color: AppColors.border),
        ),
        selectedColor: colorScheme.primary.withOpacity(0.12),
        backgroundColor: AppColors.surface,
      ),

      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          visualDensity: VisualDensity.standard,
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
          ),
          side: WidgetStateProperty.resolveWith((states) {
            final bool selected = states.contains(WidgetState.selected);
            return BorderSide(
              color: selected ? colorScheme.primary : AppColors.border,
              width: selected ? 2 : 1,
            );
          }),
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: AppColors.borderLight,
        circularTrackColor: AppColors.borderLight,
      ),

      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingL,
        ),
        iconColor: AppColors.textSecondary,
        textColor: AppColors.textPrimary,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        ),
      ),

      textTheme: TextTheme(
        displayLarge: AppTextStyles.heading1,
        displayMedium: AppTextStyles.heading2,
        displaySmall: AppTextStyles.heading3,
        bodyLarge: AppTextStyles.body1,
        bodyMedium: AppTextStyles.body2,
        bodySmall: AppTextStyles.caption,
        labelLarge: AppTextStyles.button,
      ),

      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: AppSizes.iconSizeM,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.cardBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        indicatorColor: colorScheme.primary.withOpacity(0.12),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: MaterialStateProperty.resolveWith((states) {
          final bool selected = states.contains(MaterialState.selected);
          return IconThemeData(
            color: selected ? colorScheme.primary : AppColors.textLight,
            size: AppSizes.iconSizeL,
          );
        }),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          final bool selected = states.contains(MaterialState.selected);
          return TextStyle(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? colorScheme.primary : AppColors.textLight,
          );
        }),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        shape: const CircleBorder(),
      ),
    );
  }

  static ThemeData get darkTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      colorScheme: colorScheme,
      extensions: const [NewAppColors.dark],
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.onBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.heading3.copyWith(
          color: colorScheme.onBackground,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primary.withOpacity(0.2),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}
