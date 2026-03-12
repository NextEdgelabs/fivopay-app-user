# Design System: JanSeva Cooperative Credit Society
**Project:** fivopay-app-user (Flutter Codebase)

## 1. Visual Theme & Atmosphere
The application uses a **clean, modern, and minimal** aesthetic. It relies on a "breathable UI" philosophy with generous padding, subtle borders, and very soft drop shadows. The overall mood is **trustworthy and utilitarian**, heavily utilizing variations of blue (cyan blue and deep blue) to convey financial security and professionalism. Interfaces prioritize readability and high contrast over flashy gradients, relying mostly on structured cards and flat design patterns.

## 2. Color Palette & Roles

The app uses two interconnected color systems: a legacy `AppColors` and a more robust `NewAppColors` accessed via `AppColorExtension`.

### Primary Brand & Interactive Colors
* **Primary Brand Blue** (`#2A64D9` in Light, `#3D7AFF` in Dark): Used for branded elements like app bar icons, top tabs text and underlines, and primary interactive elements.
* **Cyan Blue Accent** (`#1EBDFF`): Legacy primary color, highly vibrant.
* **Purple Gradient End** (`#8B5CF6`): Used for decorative gradients alongside the primary blue.

### Background & Surface
* **Main Background** (`#F5F8FD`): Very light blue-white used for the `Scaffold` background, giving a slightly cooler and softer tone than pure white.
* **Pure White Card** (`#FFFFFF`): Used for primary cards (`specialCard`) to create contrast against the slightly blue background.
* **Secondary Card** (`#E8F0FC`): A slightly darker blue card (`specialCardTwo`) used for secondary callouts or nested elements.
* **Navigation Bar** (`#FAFBFF`): Used to slightly separate bottom navigation from the main canvas.

### Text Colors
* **Primary Heading Text** (`#1F2D42` in Light, `#E6F0FF` in Dark): Deep blue-black for high contrast readability on headings.
* **Secondary Text** (`#777777`): Standard medium gray for supporting text and icons.
* **Muted Subtext** (`#8F9DBB`): A blue-tinted gray for timestamps, captions, or disabled states.

### Status & Alerts
* **Success Green** (`#22C55E`): Used for "Completed" KYC status or positive financial markers.
* **Error Red** (`#DC2626`): Warnings or negative balances.
* **Warning Amber** (`#F59E0B`): Pending or cautionary states.

### Borders & Dividers
* **Standard Border** (`#DCDCDC`): Light gray for subtle definition around cards or list items.
* **Selected Field** (`#E6F0FF`): Light blue background for active or highlighted fields.

## 3. Typography Rules
The application uniformly uses the **Poppins** font family to provide a geometric, friendly, and highly legible reading experience.

* **Heading 1:** 24px, Bold. Used for major screen titles (e.g., "Fixed Deposit").
* **Heading 2:** 20px, Semi-Bold (w600). Used for major section headers (e.g., "Recent Transactions", App Bar Title).
* **Heading 3:** 18px, Semi-Bold (w600). Used for card titles or moderately important sections.
* **Body 1:** 14px, Normal. Primary reading text, standard buttons, and input labels.
* **Body 2:** 13px, Normal. Used for secondary text, list item descriptions.
* **Caption:** 11px, Normal. Used for very small labels or error texts.
* **Button Text:** 14px, Semi-Bold (w600). White text standard for primary buttons.

## 4. Component Stylings

### Buttons
* **Shape:** Subtly rounded corners (`radiusM` = 10px).
* **Size:** Minimum height of 52px for comfortable touch targets.
* **Hierarchy:**
  * **Elevated (Primary):** Solid primary color background with white text, no elevation (`elevation: 0`).
  * **Outlined (Secondary):** Transparent background with a 1.5px primary color stroke.
  * **Text Buttons:** Primary colored text, no background (used for "See All" actions).

### Cards/Containers
* **Shape:** Generally uses custom radiuses (ranging from 10px up to 24px for large bottom sheets).
* **Elevation:** Minimal to none (`elevation: 0`).
* **Shadows:** Extremely subtle drop shadows (`#000000` at 5% opacity for standard, 2% for light) allowing the off-white/blue backgrounds to define edges rather than heavy shadows.

### Inputs/Forms
* **Shape:** Rounded corners (`radiusM` = 10px).
* **Style:** Filled background (`surface` color) with subtle gray borders (`#E5E7EB`). 
* **Focus State:** Border turns into a 2px solid primary color line.

## 5. Layout Principles

### Spacing Scale
The UI breathes through a structured `AppSizes` padding scale:
* `paddingXS` (6px): Tight localized grouping.
* `paddingS` (10px): Small internal padding inside distinct components.
* `paddingM` (16px): Standard gap between side-by-side elements (e.g., Row gap between two cards).
* `paddingL` (20px): The master margin used for screen edges (left/right padding on `SingleChildScrollView`).
* `paddingXL` (28px) & `padding2XL` (36px): Used selectively for centering large empty states or hero components.

### Layout Patterns
* **Vertical Stacks:** Entire screens are built using `Column` inside a `SingleChildScrollView`, with consistent vertical separation.
* **Section Separation:** `sectionSpacing` (24px) is strictly used as the vertical gap between distinct conceptual blocks (e.g., between the Balance Card and the User Info Card, or before the "Recent Transactions" list).
* **Horizontal Scroll Segments:** Top tab navigation (e.g., "Bank", "Fixed Deposit") utilizes a `SingleChildScrollView` set to `Axis.horizontal`, styled with a subtle 1px bottom border. Selected tabs show a 3px thick `brandColor` underline.
* **Dashboard Header:** Leverages a prominent `BalanceCard` followed by smaller informational widgets (`UserInfoCard`, `SmallStatCard` in an `Expanded` Row), culminating in a `ListView` for transactions.
