# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

JanSeva is a cross-platform banking application for JanSeva Cooperative Credit Society built with Flutter. It features phone-based OTP authentication, member management, and banking operations including transactions, loans, and fixed deposits.

## Development Commands

### Essential Commands
```bash
# Install dependencies
flutter pub get

# Run in development mode
flutter run

# Run tests
flutter test

# Analyze code for errors and warnings
flutter analyze

# Format code
dart format .
```

### Build Commands
```bash
# Android
flutter build apk --release

# iOS (requires macOS with Xcode)
flutter build ios --release

# Web
flutter build web --release
```

### Development Tips
- **Test Mode**: Use any phone number with OTP `123456` for testing
- **Hot Reload**: Press `r` while app is running for hot reload
- **Hot Restart**: Press `R` for full restart

## Architecture Overview

### State Management
The app uses **Provider** pattern for state management with the following providers:
- `AuthProvider`: Manages authentication state and user sessions
- `UserProvider`: Handles user profile data and updates
- `TransactionProvider`: Manages transaction history and operations
- `ReferralProvider`: Handles referral system and rewards

### Service Layer
- `AuthService`: API calls for authentication, registration, and user management
- All API calls currently point to mock endpoints in the service

### Navigation Flow
1. **Splash Screen** (2s) → Check auth state
2. **Login/Registration** → Phone + OTP authentication
3. **Dashboard** → Main app navigation with bottom tabs
4. **Feature Screens** → Transactions, Profile, Referrals, etc.

### Data Models
- `User`: Complete user profile with personal, address, and nominee info
- `Transaction`: Transaction records with type, amount, and status
- `LoanApplication`: Loan application data
- `FixedDeposit`: Fixed deposit information

## Key Design Patterns

### UI/UX Consistency
- **Theme**: Ismorphic design with white backgrounds and subtle shadows
- **Colors**: Primary blue (#2563EB), Secondary green (#10B981)
- **Font**: Poppins family throughout the app
- **Spacing**: Consistent padding using constants (8, 16, 24, 32)
- **Border Radius**: Standard radii (8, 12, 16, 24)

### Widget Structure
- Custom reusable widgets in `/lib/widgets/`
- Screen-specific components kept within screen files
- Consistent button and text field styling via custom widgets

### Error Handling
- API errors show user-friendly messages via SnackBars
- Form validation provides inline error messages
- Loading states managed by providers

## Testing Guidelines

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Test Structure
- Widget tests in `/test/`
- Currently minimal test coverage
- Mock data available for testing flows

## API Configuration

### Current Setup
- Base URL hardcoded in `AuthService`
- Mock endpoints return test data
- No environment configuration files

### Updating API Endpoint
Edit `/lib/services/auth_service.dart`:
```dart
static const String baseUrl = 'https://your-api-domain.com';
```

## Important Considerations

### Security
- Sensitive data stored in `flutter_secure_storage`
- User tokens managed by `AuthProvider`
- No credentials should be committed to repository

### Platform-Specific
- Android minimum SDK: Check `android/app/build.gradle`
- iOS deployment target: Check `ios/Podfile`
- Permissions handled by `permission_handler` package

### Performance
- Images loaded from local assets
- Lazy loading implemented for lists
- Provider prevents unnecessary rebuilds

## Common Development Tasks

### Adding a New Screen
1. Create screen file in `/lib/screens/`
2. Add navigation route in relevant parent screen
3. Connect to providers if state management needed
4. Follow existing screen patterns for consistency

### Adding a New API Endpoint
1. Add method to `AuthService` or create new service
2. Update relevant provider to call the service
3. Handle loading and error states in provider
4. Update UI to reflect state changes

### Modifying Theme
1. Update colors in `/lib/utils/constants.dart`
2. Modify theme configuration in `/lib/utils/theme.dart`
3. Custom widget styles in respective widget files