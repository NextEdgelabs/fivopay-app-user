/// Policy and legal content strings
/// Update these with actual content when available
class PolicyStrings {
  // Privacy Policy Content
  static const String privacyPolicyTitle = 'Privacy Policy';
  static const String privacyPolicyLastUpdated = 'Last Updated: March 10, 2026';
  static const String privacyPolicyContent = '''
1. Introduction

Welcome to JanSeva Cooperative Credit Society. We are committed to protecting your personal information and your right to privacy. This Privacy Policy describes how we collect, use, store, and share your information when you use our mobile application.

2. Information We Collect

We collect personal information that you voluntarily provide to us when you register on the app, including:
• Name and contact information (phone number, email, address)
• Government identification (Aadhaar number for verification)
• Financial information (account details, transaction history)
• Nominee information
• Device information and usage data

3. How We Use Your Information

We use your personal information for the following purposes:
• To create and manage your account
• To process your transactions and loan applications
• To verify your identity and prevent fraud
• To communicate with you about your account and services
• To improve our app and services
• To comply with legal obligations

4. Data Security

We implement appropriate technical and organizational security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. This includes:
• Encrypted data transmission
• Secure storage systems
• Access controls and authentication
• Regular security assessments

5. Data Sharing

We do not sell your personal information. We may share your information with:
• Service providers who assist in our operations
• Regulatory authorities as required by law
• Third parties with your consent

6. Your Rights

You have the right to:
• Access your personal information
• Correct inaccurate data
• Request deletion of your data (subject to legal requirements)
• Opt-out of marketing communications
• Withdraw consent where applicable

7. Data Retention

We retain your personal information for as long as necessary to fulfill the purposes outlined in this policy or as required by law. Financial records are retained according to regulatory requirements.

8. Children's Privacy

Our services are not directed to individuals under the age of 18. We do not knowingly collect personal information from children.

9. Changes to This Policy

We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy on this page and updating the "Last Updated" date.

10. Contact Us

If you have questions or concerns about this Privacy Policy, please contact us:

Email: support@janseva.coop
Phone: +91-XXXX-XXXXXX
Address: JanSeva Cooperative Credit Society, [Address]
''';

  // Terms of Service Content
  static const String termsOfServiceTitle = 'Terms of Service';
  static const String termsOfServiceLastUpdated =
      'Last Updated: March 10, 2026';
  static const String termsOfServiceContent = '''
1. Acceptance of Terms

By accessing and using the JanSeva Cooperative Credit Society mobile application, you accept and agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our services.

2. Eligibility

To use our services, you must:
• Be at least 18 years of age
• Be a resident of India
• Have the legal capacity to enter into binding contracts
• Provide accurate and complete information during registration

3. Account Registration

When you create an account, you agree to:
• Provide truthful, accurate, and complete information
• Maintain the security of your account credentials
• Notify us immediately of any unauthorized access
• Accept responsibility for all activities under your account

4. Membership

Membership in JanSeva Cooperative Credit Society is subject to:
• Acceptance of your application
• Payment of required membership fees and share capital
• Compliance with society bylaws and regulations
• KYC (Know Your Customer) verification

5. Services Provided

JanSeva offers the following services through the app:
• Savings account management
• Fixed deposits
• Loan applications and management
• Share purchases
• Transaction history and statements
• Digital payments and transfers

6. Financial Transactions

All financial transactions are subject to:
• Verification of available balance
• Processing times and cut-off hours
• Transaction limits and charges
• Reserve Bank of India regulations
• Society policies and bylaws

7. Loan Services

Loan applications are subject to:
• Credit assessment and approval
• Required documentation
• Collateral requirements (where applicable)
•   context.read<AuthProvider>().isEthicalBanking
                        ? 'Profit Rate'
                        : 'Interest Rate's and repayment terms
• Penalty charges for late payments

8. Prohibited Activities

You agree not to:
• Use the app for any illegal purpose
• Attempt to gain unauthorized access
• Transmit viruses or malicious code
• Impersonate any person or entity
• Interfere with the app's operation
• Use automated systems to access the app

9. Fees and Charges

You agree to pay all applicable fees including:
• Membership fees
• Transaction charges
• Loan processing fees
• Late payment penalties
• Other charges as notified

10. Intellectual Property

All content, features, and functionality of the app are owned by JanSeva Cooperative Credit Society and are protected by copyright, trademark, and other intellectual property laws.

11. Limitation of Liability

JanSeva shall not be liable for:
• Indirect, incidental, or consequential damages
• Loss of profits, data, or business opportunities
• Damages resulting from unauthorized access
• Service interruptions or technical issues

12. Indemnification

You agree to indemnify and hold harmless JanSeva Cooperative Credit Society from any claims, losses, or damages arising from your use of the app or violation of these terms.

13. Termination

We reserve the right to:
• Suspend or terminate your account
• Refuse service to anyone
• Modify or discontinue services
• Take action for violations of these terms

14. Governing Law

These Terms shall be governed by the laws of India. Any disputes shall be subject to the jurisdiction of courts in [City/State].

15. Changes to Terms

We reserve the right to modify these Terms at any time. Continued use of the app after changes constitutes acceptance of the revised terms.

16. Contact Information

For questions about these Terms of Service:

Email: support@janseva.coop
Phone: +91-XXXX-XXXXXX
Address: JanSeva Cooperative Credit Society, [Address]
''';

  // Support Content
  static const String supportTitle = 'Support';
  static const String supportDescription =
      'We\'re here to help! Choose how you\'d like to reach us.';

  static const List<Map<String, String>> supportOptions = [
    {
      'title': 'Email Support',
      'subtitle': 'Get help via email',
      'value': 'support@janseva.coop',
      'icon': 'email',
    },
    {
      'title': 'Phone Support',
      'subtitle': 'Call us during business hours',
      'value': '+91-XXXX-XXXXXX',
      'icon': 'phone',
    },
    {
      'title': 'WhatsApp Support',
      'subtitle': 'Chat with us on WhatsApp',
      'value': '+91-XXXX-XXXXXX',
      'icon': 'whatsapp',
    },
    {
      'title': 'Visit Branch',
      'subtitle': 'Find our nearest branch',
      'value': 'View Locations',
      'icon': 'location',
    },
  ];

  static const String supportFaqTitle = 'Frequently Asked Questions';
  static const List<Map<String, String>> supportFaqs = [
    {
      'question': 'How do I open a new account?',
      'answer':
          'To open a new account, download the app, complete the registration process with your phone number, and submit your KYC documents. Our team will verify your details and activate your account within 2-3 business days.',
    },
    {
      'question': 'What documents are required for KYC?',
      'answer':
          'You need to provide:\n• Aadhaar Card\n• PAN Card\n• Proof of Address\n• Recent Passport Size Photograph\n• Nominee Details\n\nAll documents can be uploaded directly through the app.',
    },
    {
      'question': 'How long does loan approval take?',
      'answer':
          'Loan approval typically takes 3-5 business days after all required documents are submitted. Emergency loans may be processed faster subject to eligibility and documentation.',
    },
    {
      'question': 'What are the transaction limits?',
      'answer':
          'Daily transaction limits vary based on your account type:\n• Savings Account: ₹50,000 per day\n• Current Account: ₹1,00,000 per day\n• UPI Transactions: ₹1,00,000 per day\n\nHigher limits can be requested by contacting support.',
    },
    {
      'question': 'How do I reset my password?',
      'answer':
          'Click on "Forgot Password" on the login screen. Enter your registered phone number and follow the OTP verification process to reset your password.',
    },
    {
      'question': 'Is my money safe with JanSeva?',
      'answer':
          'Yes, JanSeva Cooperative Credit Society is registered and regulated under the Cooperative Societies Act. All deposits are insured and protected as per regulatory guidelines.',
    },
  ];

  static const String supportBusinessHours = '''
Business Hours:
Monday - Friday: 9:00 AM - 5:00 PM
Saturday: 9:00 AM - 1:00 PM
Sunday: Closed

Public Holidays: Closed
''';

  static const String supportAddress = '''
Head Office:
JanSeva Cooperative Credit Society
[Street Address]
[City, State - PIN Code]
India
''';
}
