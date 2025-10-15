# API Integration Documentation

## Overview
Integrated Sandbox KYC API for real-time PAN verification in the KYC module. The integration replaces the previous mock OTP-based verification with actual API calls.

## API Details

### Sandbox KYC API
- **Base URL**: `https://api.sandbox.co.in`
- **Endpoint**: `/kyc/pan/verify`
- **Authentication**: JWT Bearer Token + API Key
- **Version**: 2.0

### Configuration
All API configuration is centralized in `lib/config/api_config.dart`:
- Base URL
- API Token (JWT)
- API Key: `key_live_c018d67e91bc4761b35d212fce69e17d`
- Workspace ID
- Request headers

## Integrated Locations

The PAN verification API is now integrated in **TWO** places:

1. **✅ KYC/Onboarding Screen** (`lib/screens/kyc_screen.dart`)
   - During user registration flow
   - Validates PAN before KYC submission
   - Mandatory verification before proceeding

2. **✅ Loan Application Screen** (`lib/widgets/pan_verification_widget.dart`)
   - During loan application process
   - For self or relative verification
   - Part of loan eligibility checks

## Architecture

### 1. Configuration Layer
**File**: `lib/config/api_config.dart`

Contains:
- API credentials and endpoints
- Header configuration
- Environment-specific settings

### 2. Service Layer
**File**: `lib/services/kyc_service.dart`

**Main Method**: `verifyPan()`
```dart
Future<PanVerificationResponse> verifyPan({
  required String panNumber,
  required String name,
  String? dateOfBirth,
})
```

**Models**:
- `PanVerificationResponse` - Complete API response
  - `code`: HTTP status code
  - `timestamp`: Response timestamp
  - `data`: PanData object
  - `transactionId`: Unique transaction identifier
  - Helper methods: `isSuccess`, `isValid`

- `PanData` - Verification details
  - `status`: Valid/Invalid status
  - `nameMatch`: Name matching result
  - `dobMatch`: Date of birth matching result (if provided)
  - `category`: PAN category (Individual/Company/etc.)
  - `aadhaarSeedingStatus`: Aadhaar linking status
  - Helper methods: `isAadhaarSeeded`

**Error Handling**:
- `KycApiException` - Custom exception class
  - `message`: Error description
  - `statusCode`: HTTP status code
  - `errorDetails`: Additional error information

### 3. UI Layer
**File**: `lib/screens/pan_confirmation_screen.dart`

Displays verification results with:
- Status icon (success/error)
- Verification details card showing:
  - PAN Number
  - Verification Status
  - Name Match Status
  - PAN Category
  - Aadhaar Seeding Status
- Transaction ID
- Action buttons:
  - "Confirm & Continue" (on success)
  - "Try Again" (on failure)
  - "Cancel"

### 4. Widget Integration - Loan Application
**File**: `lib/widgets/pan_verification_widget.dart`

**Changes Made**:
- Removed OTP-based flow
- Added name field (required by API)
- Integrated KycService for verification
- Added navigation to confirmation screen
- Improved error handling with visual indicators
- Added loading states

**Flow**:
1. User enters PAN number and name
2. Widget calls `KycService.verifyPan()`
3. Shows loading state during API call
4. Navigates to confirmation screen with results
5. User confirms or retries
6. Updates provider state on confirmation

### 4b. Screen Integration - KYC/Onboarding
**File**: `lib/screens/kyc_screen.dart`

**Changes Made**:
- Added KycService import and initialization
- Added name field for PAN verification
- Added `_verifyPAN()` method with API call
- Added verification state tracking (`_isPanVerified`)
- Made PAN verification mandatory before KYC submission
- Auto-fills name from user profile
- Shows verified badge when successful
- Disables fields after successful verification

**Flow**:
1. User enters PAN and name (auto-filled from profile)
2. Clicks "Verify PAN" button
3. API call made to Sandbox
4. Confirmation screen shown with results
5. On success: Fields disabled, verified badge shown
6. On failure: User can retry with correct details
7. KYC submission only allowed if PAN is verified

### 5. Provider Updates
**File**: `lib/providers/loan_provider.dart`

**New Method**: `setPANVerified()`
```dart
Future<void> setPANVerified(String pan, dynamic verificationResponse) async
```

Updates:
- Stores verified PAN number
- Sets verification status
- Saves verification timestamp
- Stores transaction ID in secure storage
- Notifies listeners

## API Request/Response

### Request
```json
{
  "@entity": "in.co.sandbox.kyc.pan.request",
  "pan": "ABCDE1234F",
  "name": "John Doe",
  "dob": "01/01/1990"  // Optional
}
```

### Success Response
```json
{
  "code": 200,
  "timestamp": "2024-01-15T10:30:00Z",
  "data": {
    "status": "VALID",
    "name_match": "100% Match",
    "dob_match": "Match",
    "category": "Person",
    "aadhaar_seeding_status": "Seeded"
  },
  "transaction_id": "txn_123456789"
}
```

### Error Response
```json
{
  "code": 400,
  "message": "Invalid PAN number",
  "error_details": {
    "field": "pan",
    "reason": "Format validation failed"
  }
}
```

## Testing

### Test Data
From `env.dart`:
- **Valid PAN**: ANVPY9553G
- **Valid Name**: (Use actual name associated with PAN)

### Test Cases
1. **Valid PAN with correct name**
   - Expected: Success with "VALID" status
   - Expected: Name match confirmed
   - Expected: Aadhaar seeding status displayed

2. **Valid PAN with incorrect name**
   - Expected: Success but name mismatch shown
   - Expected: User can decide to proceed or retry

3. **Invalid PAN format**
   - Expected: Client-side validation error
   - Expected: No API call made

4. **Invalid PAN number**
   - Expected: API returns "INVALID" status
   - Expected: Error shown on confirmation screen
   - Expected: "Try Again" option available

5. **Network error**
   - Expected: Exception caught
   - Expected: Error message displayed
   - Expected: User can retry

### Testing on Device
1. Connect Samsung device (SM S921B)
2. Hot reload the app
3. Navigate to loan application
4. Enter PAN and name
5. Verify API call in debug logs
6. Check confirmation screen displays correctly
7. Verify transaction ID is stored

## Debug Logging

The `kyc_service.dart` includes debug print statements:
- Request details (PAN, name, DOB)
- Full response JSON
- Error details

Look for logs prefixed with:
- `"[KYC] Verifying PAN:"`
- `"[KYC] Response:"`
- `"[KYC] Error:"`

## Security Considerations

1. **API Token**: Stored in `api_config.dart` (should move to env variables in production)
2. **Transaction ID**: Stored in secure storage using FlutterSecureStorage
3. **PAN Data**: Never logged in production builds (debug logs only)
4. **HTTPS**: All API calls use HTTPS encryption
5. **Headers**: Proper authentication headers on all requests

## Next Steps

### Immediate
- [x] Create API configuration
- [x] Implement KYC service
- [x] Create confirmation screen
- [x] Update PAN verification widget
- [x] Update provider
- [ ] Test on Samsung device
- [ ] Verify API calls work

### Future Enhancements
1. **Aadhaar Verification**: Implement similar flow for Aadhaar
2. **DOB Validation**: Add optional DOB field and validation
3. **Retry Logic**: Add exponential backoff for network failures
4. **Caching**: Cache verification results to avoid duplicate API calls
5. **Transaction History**: Store all verification attempts with transaction IDs
6. **Analytics**: Track verification success/failure rates
7. **Production Config**: Move API credentials to environment variables
8. **Error Recovery**: Better error messages and recovery suggestions

## Migration Notes

### Breaking Changes
- Removed OTP verification flow
- PAN verification now requires name field
- Changed from mock service to real API

### Backward Compatibility
- Existing `verifyPAN()` and `verifyPANOTP()` methods still exist in provider
- No changes to existing loan application models
- UI changes are contained to PAN verification widget

## Support

### API Documentation
- Sandbox API Docs: https://api.sandbox.co.in/docs
- KYC Endpoints: https://api.sandbox.co.in/docs/kyc

### Troubleshooting

**Issue**: API call fails with 401
- Check API token in `api_config.dart`
- Verify token hasn't expired
- Check API key is correct

**Issue**: API call fails with 400
- Validate PAN format (10 characters, format: ABCDE1234F)
- Check name is provided and not empty
- Verify request payload structure

**Issue**: Network timeout
- Check internet connectivity
- Verify API URL is accessible
- Check for firewall/proxy issues

**Issue**: Confirmation screen not showing
- Check navigation logic in widget
- Verify PanConfirmationScreen is properly imported
- Check for errors in console

## File Structure
```
lib/
├── config/
│   └── api_config.dart                    # API configuration
├── services/
│   └── kyc_service.dart                   # KYC API service
├── screens/
│   ├── pan_confirmation_screen.dart       # Verification results screen
│   └── kyc_screen.dart                    # ✅ KYC/Onboarding (API integrated)
├── widgets/
│   └── pan_verification_widget.dart       # ✅ Loan PAN widget (API integrated)
└── providers/
    └── loan_provider.dart                 # State management
```

## Integration Summary

| Screen | File | Status | Usage |
|--------|------|--------|-------|
| KYC/Onboarding | `kyc_screen.dart` | ✅ Integrated | New user registration |
| Loan Application | `pan_verification_widget.dart` | ✅ Integrated | Loan eligibility check |
| Confirmation | `pan_confirmation_screen.dart` | ✅ Shared | Both flows use this |

## API Response Mapping

| API Field | Model Property | Display Name |
|-----------|---------------|--------------|
| status | PanData.status | Verification Status |
| name_match | PanData.nameMatch | Name Match |
| dob_match | PanData.dobMatch | DOB Match |
| category | PanData.category | PAN Category |
| aadhaar_seeding_status | PanData.aadhaarSeedingStatus | Aadhaar Status |
| transaction_id | PanVerificationResponse.transactionId | Transaction ID |

---

**Last Updated**: January 2024
**Version**: 1.0
**Status**: ✅ Implementation Complete, Testing Pending
