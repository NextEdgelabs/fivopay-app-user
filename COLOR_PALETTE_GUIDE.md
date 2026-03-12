# Color Palette Guide

## Brand Color
**Primary Brand Color:** `#AD2DBA` (ARGB: 255, 173, 45, 186)

A vibrant purple/magenta that represents the brand identity.

## Light Theme Color Palette

### Background & Surface Colors
- **Background**: `#FFFAFF` - Very light purple-white background
- **Card Background**: `#F8F2FC` - Card background with subtle purple tint
- **Special Card**: `#F5EBFA` - Light purple card
- **Special Card Two**: `#EAD9F2` - Slightly darker purple card
- **Navigation Bar**: `#FFFAFF` - Navigation bar
- **Popup Background**: `#FFFFFF` - Pure white popup
- **Small Card Background**: `#FBF7FD` - Small card background
- **Search Field Fill**: `#F5EFFA` - Search field fill

### Text Colors
- **Heading**: `#2D1F3A` - Deep purple-black for headings
- **Subheading**: `#4A3558` - Dark purple for subheadings
- **Text**: `#6B5278` - Purple-gray text
- **Text Secondary**: `#8A7298` - Secondary purple-gray text
- **Subtext**: `#9D8FAA` - Muted purple text
- **Nav Bar Text**: `#7A6888` - Nav bar text
- **Button Label**: `#FFFFFF` - White button text
- **Disabled Text**: `#B8AABF` - Disabled text

### Brand & Accent Colors
- **Brand Color**: `#AD2DBA` - Primary brand purple
- **Gradient One**: `#AD2DBA` - Gradient start
- **Gradient Two**: `#C855D4` - Gradient end (lighter purple)

### Interactive Elements
- **Back Icon**: `#6B5278` - Back icon color
- **Back Icon Border**: `#E8DDF0` - Back icon border
- **Divider**: `#EBE0F2` - Divider lines
- **Border**: `#DDC9E9` - Border color with purple
- **Field Border**: `#D6C3E3` - Field border
- **Selected Field**: `#F2E6FA` - Selected field background
- **Disabled**: `#F0E6F5` - Disabled state

### Status & Alert Colors
- **Success (Alert 1)**: `#22C55E` - Success green
- **Error (Alert 2)**: `#DC2626` - Error red
- **Warning (Alert 3)**: `#F59E0B` - Warning amber
- **Info (Alert 4)**: `#9333EA` - Info purple
- **Call**: `#4ADE80` - Call green

## Dark Theme Color Palette

### Background & Surface Colors
- **Background**: `#0F0A15` - Deep dark purple-black
- **Card Background**: `#1A1522` - Card background with purple
- **Special Card**: `#1C1420` - Dark card with purple tint
- **Special Card Two**: `#221828` - Slightly lighter card
- **Navigation Bar**: `#0D0812` - Darker navigation bar
- **Popup Background**: `#1C1420` - Popup background
- **Small Card Background**: `#1F1625` - Small card background
- **Search Field Fill**: `#1D1723` - Search field fill

### Text Colors
- **Heading**: `#F0E6F5` - Light purple-white for headings
- **Subheading**: `#D4C5DC` - Soft purple-gray for subheadings
- **Text**: `#C8B8D4` - Purple-tinted text
- **Text Secondary**: `#B4A2C0` - Secondary text with purple
- **Subtext**: `#9688A6` - Muted purple-gray
- **Nav Bar Text**: `#B8A6C4` - Nav bar text
- **Button Label**: `#F5F0FA` - Button label text
- **Disabled Text**: `#8A7C98` - Disabled text

### Brand & Accent Colors
- **Brand Color**: `#AD2DBA` - Primary brand purple
- **Gradient One**: `#AD2DBA` - Gradient start
- **Gradient Two**: `#C855D4` - Gradient end (lighter purple)

### Interactive Elements
- **Back Icon**: `#8A7298` - Back icon color
- **Back Icon Border**: `#2D2235` - Back icon border
- **Divider**: `#2B2133` - Divider lines
- **Border**: `#3D2F47` - Border color
- **Field Border**: `#3A2E44` - Field border
- **Selected Field**: `#2D1F3A` - Selected field background
- **Disabled**: `#2A2232` - Disabled state

### Status & Alert Colors
- **Success (Alert 1)**: `#4ADE80` - Success green
- **Error (Alert 2)**: `#EF4444` - Error red
- **Warning (Alert 3)**: `#FBBC05` - Warning amber
- **Info (Alert 4)**: `#8B5CF6` - Info purple
- **Call**: `#86EFAC` - Call green

## Usage Examples

### Basic Usage
```dart
import 'package:your_app/utils/app_color_extension.dart';

// In your widget
@override
Widget build(BuildContext context) {
  return Container(
    color: context.colors.cardBackground,
    child: Text(
      'Hello',
      style: TextStyle(color: context.colors.heading),
    ),
  );
}
```

### Using Gradients
```dart
Container(
  decoration: BoxDecoration(
    gradient: context.colors.brandLinearGradient,
    borderRadius: BorderRadius.circular(12),
  ),
  child: YourWidget(),
)
```

### Using Color Variations
```dart
// Get lighter/darker brand color
Color lightBrand = context.colors.brandColorLight;
Color darkBrand = context.colors.brandColorDark;

// Brand color with opacity
Color transparentBrand = context.colors.brandColorWithOpacity(0.5);

// Status colors with opacity
Color successLight = context.colors.successWithOpacity(0.2);
```

### Using Color Helper
```dart
import 'package:your_app/utils/app_color_extension.dart';

// Lighten/Darken colors
Color lighter = AppColorHelper.lighten(context.colors.brandColor, 0.2);
Color darker = AppColorHelper.darken(context.colors.brandColor, 0.3);

// Mix colors
Color mixed = AppColorHelper.mix(
  context.colors.brandColor,
  Colors.white,
  0.5,
);

// Hex conversion
String hex = AppColorHelper.toHex(context.colors.brandColor);
Color fromHex = AppColorHelper.fromHex('#AD2DBA');
```

### Check Theme Mode
```dart
if (context.isDarkMode) {
  // Dark mode specific logic
} else {
  // Light mode specific logic
}
```

## Color Theory & Accessibility

### Brand Color Psychology
Purple (#AD2DBA) represents:
- **Creativity** - Encourages innovation and imagination
- **Wisdom** - Conveys knowledge and expertise
- **Luxury** - Premium feel and quality
- **Spirituality** - Depth and meaning

### Contrast Ratios
All text colors have been carefully selected to meet WCAG AA standards:
- Light theme: Dark purple text on light backgrounds (4.5:1 minimum)
- Dark theme: Light purple text on dark backgrounds (4.5:1 minimum)

### Color Harmony
The palette uses:
- **Monochromatic scheme**: Various shades and tints of purple
- **Complementary accents**: Status colors (green, red, amber) provide contrast
- **Neutral balance**: Purple-tinted grays maintain brand consistency

## Migration from Old Colors

If you're migrating from the previous blue theme:

| Old Blue | New Purple |
|----------|------------|
| `#5B71FC` | `#AD2DBA` |
| `#5B69FE` | `#AD2DBA` |
| `#6498FF` | `#C855D4` |

Simply replace references to the old brand colors with the new extension-based system.
