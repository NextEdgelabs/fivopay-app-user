# JanSeva - Cooperative Credit Society Banking App

A modern, ismorphic banking application for JanSeva Cooperative Credit Society built with Flutter. This app provides a complete banking experience with phone number OTP login, account creation, membership management, and referral system.

## 🚀 Features

### Authentication & Security
- **Phone Number OTP Login**: Secure authentication using phone number and OTP verification
- **Modern UI**: Clean, ismorphic design with white background and subtle shadows
- **Session Management**: Automatic login state management

### Account Management
- **User Registration**: Multi-step registration process for new members
- **Profile Management**: Complete user profile with personal, address, and nominee information
- **Account Details**: View account number, balance, and membership status

### Banking Features
- **Dashboard**: Modern dashboard with account overview and quick actions
- **Balance Display**: Real-time account balance with deposit/withdraw options
- **Transaction History**: View and manage transaction records
- **Quick Actions**: Transfer money, pay bills, loan requests, and support

### Referral System
- **Referral Code**: Unique referral codes for each member
- **Invite Friends**: Share referral codes via WhatsApp, SMS, or other platforms
- **Rewards**: Earn ₹100 for each successful referral, friends get ₹50 welcome bonus
- **Referral Tracking**: View referred users and earnings

### Modern UI/UX
- **Ismorphic Design**: Clean, modern interface with subtle shadows and rounded corners
- **Responsive Layout**: Works seamlessly across different screen sizes
- **Smooth Animations**: Fluid transitions and micro-interactions
- **Accessibility**: Designed with accessibility in mind

## 🛠️ Technology Stack

- **Framework**: Flutter 3.8.1+
- **State Management**: Provider
- **HTTP Client**: http package
- **Local Storage**: SharedPreferences & Flutter Secure Storage
- **UI Components**: Custom widgets with Material Design 3
- **OTP Input**: pin_code_fields package

## 📱 Screenshots

### Login & Authentication
- Phone number input with validation
- OTP verification with PIN code input
- Test mode with OTP: 123456

### Dashboard
- Account balance display
- Quick action cards
- Member information
- Navigation tabs

### Registration
- Multi-step registration process
- Personal information
- Address details
- Nominee information

### Referral System
- Referral code display
- Share options (WhatsApp, SMS, More)
- Referral rewards and statistics
- Referred users list

### Profile Management
- User profile with avatar
- Editable account information
- Membership details
- Settings and actions

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Android SDK / Xcode (for mobile development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd janseva
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Test Mode
For development and testing purposes, the app includes a test mode:
- Use any phone number for login
- OTP code: `123456`
- All features are functional with mock data

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── user.dart            # User data model
├── providers/
│   └── auth_provider.dart   # Authentication state management
├── screens/
│   ├── login_screen.dart    # Phone login screen
│   ├── otp_screen.dart      # OTP verification screen
│   ├── registration_screen.dart # User registration
│   ├── dashboard_screen.dart # Main dashboard
│   ├── referral_screen.dart # Referral management
│   └── profile_screen.dart  # User profile
├── services/
│   └── auth_service.dart    # Authentication API service
├── utils/
│   ├── constants.dart       # App constants and colors
│   └── theme.dart          # App theme configuration
└── widgets/
    ├── custom_button.dart   # Custom button widget
    └── custom_text_field.dart # Custom text field widget
```

## 🎨 Design System

### Colors
- **Primary**: Blue (#2563EB)
- **Secondary**: Green (#10B981)
- **Background**: White (#FFFFFF)
- **Surface**: Light Gray (#F8FAFC)
- **Text**: Dark Gray (#1E293B)
- **Border**: Light Gray (#E2E8F0)

### Typography
- **Font Family**: Poppins
- **Headings**: Bold, 24-32px
- **Body**: Regular, 14-16px
- **Caption**: Regular, 12px

### Spacing
- **XS**: 4px
- **S**: 8px
- **M**: 16px
- **L**: 24px
- **XL**: 32px

### Border Radius
- **S**: 8px
- **M**: 12px
- **L**: 16px
- **XL**: 24px

## 🔧 Configuration

### API Configuration
Update the API base URL in `lib/services/auth_service.dart`:
```dart
static const String baseUrl = 'https://your-api-domain.com';
```

### Theme Customization
Modify colors and styles in `lib/utils/constants.dart` and `lib/utils/theme.dart`.

## 🧪 Testing

### Manual Testing
1. **Login Flow**
   - Enter any phone number
   - Use OTP: 123456
   - Verify successful login

2. **Registration Flow**
   - Complete multi-step registration
   - Verify member creation

3. **Dashboard Features**
   - Check balance display
   - Test quick actions
   - Verify navigation

4. **Referral System**
   - Copy referral code
   - Test share functionality
   - View referral statistics

### Automated Testing
```bash
flutter test
```

## 📦 Build & Deploy

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

## 🔮 Future Enhancements

- [ ] Real-time notifications
- [ ] Biometric authentication
- [ ] Advanced transaction features
- [ ] Loan application system
- [ ] Bill payment integration
- [ ] Multi-language support
- [ ] Dark mode theme
- [ ] Offline functionality

---

**JanSeva Cooperative Credit Society** - Empowering communities through modern banking solutions.
