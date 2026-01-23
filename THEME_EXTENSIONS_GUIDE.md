# App Theme Extensions - Usage Guide

This guide explains how to use the new extension-based theme system in your Flutter app.

## Overview

The theme extension system provides a clean and intuitive way to access theme properties throughout your app using context extensions. This approach eliminates the need to import constants directly and provides better IDE autocomplete support.

## Files Created

1. **`theme_extensions.dart`** - Core extension definitions
2. **`theme_usage_example.dart`** - Example widgets demonstrating usage

## Key Features

### 1. Context Extensions

Access theme properties directly from `BuildContext`:

```dart
// Access colors
context.colors.primary
context.colors.textPrimary

// Access text styles
context.textStyles.heading1
context.textStyles.body1

// Access sizes
context.sizes.paddingM
context.sizes.radiusL

// Access decorations
context.decorations.card
context.decorations.primaryGradient

// Check if dark mode
context.isDarkMode
```

### 2. Color Extensions

Manipulate colors easily:

```dart
// Lighten a color
context.colors.primary.lighten(0.2)

// Darken a color
context.colors.primary.darken(0.2)

// Set opacity
context.colors.primary.withAlpha(0.5)
```

### 3. TextStyle Extensions

Modify text styles on the fly:

```dart
// Make text bold
context.textStyles.body1.bold

// Change color
context.textStyles.body1.withColor(context.colors.primary)

// Change size
context.textStyles.body1.withSize(18)

// Make italic
context.textStyles.body1.italic

// Combine multiple modifications
context.textStyles.body1.bold.withColor(Colors.red).withSize(20)
```

### 4. Size Helpers

Quick access to EdgeInsets:

```dart
// Padding helpers
context.sizes.paddingAllM
context.sizes.paddingHorizontalL
context.sizes.paddingVerticalM

// Border radius helpers
context.decorations.borderRadiusM
context.decorations.borderRadiusL
```

## Usage Examples

### Basic Widget with Theme Extensions

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: context.decorations.card,
      padding: context.sizes.paddingAllM,
      child: Text(
        'Hello World',
        style: context.textStyles.heading2,
      ),
    );
  }
}
```

### Custom Card Widget

```dart
class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: context.decorations.cardOutlined,
      padding: context.sizes.paddingAllL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textStyles.body2.withColor(
              context.colors.textSecondary,
            ),
          ),
          SizedBox(height: context.sizes.paddingS),
          Text(
            value,
            style: context.textStyles.heading1.withColor(
              context.colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
```

### Form Field with Theme

```dart
Widget buildTextField(BuildContext context) {
  return TextField(
    decoration: context.decorations.inputDecoration(
      labelText: 'Email',
      hintText: 'Enter your email',
      prefixIcon: Icon(Icons.email),
    ),
    style: context.textStyles.body1,
  );
}
```

### Button with Gradient

```dart
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: context.decorations.primaryGradient,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: context.decorations.borderRadiusM,
          child: Container(
            height: context.sizes.buttonHeight,
            alignment: Alignment.center,
            child: Text(
              text,
              style: context.textStyles.button,
            ),
          ),
        ),
      ),
    );
  }
}
```

### Spacing and Layout

```dart
Widget buildLayout(BuildContext context) {
  return Column(
    children: [
      Text('First Section', style: context.textStyles.heading2),
      SizedBox(height: context.sizes.sectionSpacing),
      
      Container(
        decoration: context.decorations.card,
        padding: context.sizes.paddingAllM,
        child: Text('Content'),
      ),
      
      SizedBox(height: context.sizes.cardSpacing),
      
      Container(
        decoration: context.decorations.card,
        padding: context.sizes.paddingAllM,
        child: Text('More content'),
      ),
    ],
  );
}
```

## Available Properties

### Colors (`context.colors`)

- **Primary:** `primary`, `primaryLight`, `primaryDark`
- **Secondary:** `secondary`, `secondaryLight`, `secondaryDark`
- **Background:** `background`, `surface`, `cardBackground`
- **Text:** `textPrimary`, `textSecondary`, `textLight`
- **Status:** `success`, `successLight`, `warning`, `error`, `info`
- **Border:** `border`, `borderLight`
- **Shadow:** `shadow`, `shadowLight`

### Text Styles (`context.textStyles`)

- **Headings:** `heading1`, `heading2`, `heading3`
- **Body:** `body1`, `body2`, `caption`
- **Button:** `button`
- **Variants:** `subtitle1`, `subtitle2`, `overline`

### Sizes (`context.sizes`)

- **Padding:** `paddingXS`, `paddingS`, `paddingM`, `paddingL`, `paddingXL`, `padding2XL`
- **Radius:** `radiusS`, `radiusM`, `radiusL`, `radiusXL`
- **Icons:** `iconSizeS`, `iconSizeM`, `iconSizeL`, `iconSizeXL`
- **Components:** `buttonHeight`, `inputHeight`
- **Spacing:** `cardSpacing`, `sectionSpacing`

### Decorations (`context.decorations`)

- **Cards:** `card`, `cardFlat`, `cardOutlined`
- **Gradients:** `primaryGradient`, `successGradient`
- **Input:** `inputDecoration()`
- **Borders:** `borderRadiusS`, `borderRadiusM`, `borderRadiusL`, `borderRadiusXL`
- **Divider:** `divider`

## Migration Guide

### Before (Direct Import)

```dart
import 'package:your_app/utils/constants.dart';

Container(
  decoration: BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(AppSizes.radiusM),
  ),
  padding: EdgeInsets.all(AppSizes.paddingM),
  child: Text(
    'Hello',
    style: AppTextStyles.heading2,
  ),
)
```

### After (Using Extensions)

```dart
import 'package:your_app/utils/theme_extensions.dart';

Container(
  decoration: context.decorations.card,
  padding: context.sizes.paddingAllM,
  child: Text(
    'Hello',
    style: context.textStyles.heading2,
  ),
)
```

## Benefits

1. **Cleaner Code** - No need to import constants in every file
2. **Better Autocomplete** - IDE suggests available properties
3. **Type Safety** - Compile-time checking of theme properties
4. **Consistency** - Enforces use of design system
5. **Maintainability** - Easy to update theme globally
6. **Readability** - More intuitive API

## Best Practices

1. **Always use context extensions** instead of importing constants directly
2. **Combine extensions** for complex styling needs
3. **Create reusable widget components** that leverage the theme system
4. **Use semantic naming** when creating custom variants
5. **Test with different themes** to ensure consistency

## Examples in Action

See `theme_usage_example.dart` for complete working examples including:

- Color showcase
- Text style variations
- Decoration examples
- Spacing demonstrations
- Color manipulation
- TextStyle modifications
- Custom widgets (cards, buttons, text fields)

## Next Steps

1. Import `theme_extensions.dart` in your widget files
2. Replace direct constant imports with context extensions
3. Explore the example file to see all available options
4. Create custom widgets using the extension system
5. Enjoy a cleaner, more maintainable codebase!
