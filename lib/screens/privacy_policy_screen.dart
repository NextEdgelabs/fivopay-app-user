import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:janseva/utils/theme_extension.dart';
import '../utils/constants.dart';
import '../utils/policy_strings.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: context.colors.brandColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          PolicyStrings.privacyPolicyTitle,
          style: AppTextStyles.heading2.copyWith(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header Section with Gradient
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSizes.paddingL),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.colors.brandColor,
                      context.colors.gradientTwo,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppSizes.radiusXXL),
                    bottomRight: Radius.circular(AppSizes.radiusXXL),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSizes.paddingL),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(
                        Iconsax.shield_tick,
                        color: Colors.white,
                        size: AppSizes.dW * 0.15,
                      ),
                    ),
                    SizedBox(height: AppSizes.paddingM),
                    Text(
                      'Your Privacy Matters',
                      style: AppTextStyles.heading2.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSizes.paddingS),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingM,
                        vertical: AppSizes.paddingS,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppSizes.radiusL),
                      ),
                      child: Text(
                        PolicyStrings.privacyPolicyLastUpdated,
                        style: AppTextStyles.body2.copyWith(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content Section
              Padding(
                padding: EdgeInsets.all(AppSizes.paddingL),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSizes.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        PolicyStrings.privacyPolicyContent,
                        style: AppTextStyles.body1.copyWith(
                          fontSize: 14,
                          height: 1.8,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer with Contact Info
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.paddingL,
                  0,
                  AppSizes.paddingL,
                  AppSizes.paddingXL,
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSizes.paddingL),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        context.colors.brandColor.withOpacity(0.1),
                        context.colors.gradientTwo.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                    border: Border.all(
                      color: context.colors.brandColor.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Iconsax.message_question,
                        color: context.colors.brandColor,
                        size: AppSizes.iconSizeXL,
                      ),
                      SizedBox(height: AppSizes.paddingM),
                      Text(
                        'Have Questions?',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingS),
                      Text(
                        'Contact our support team for any privacy-related queries',
                        style: AppTextStyles.body2,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSizes.paddingM),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/support');
                        },
                        icon: const Icon(Iconsax.headphone, size: 18),
                        label: const Text('Contact Support'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.brandColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingXL,
                            vertical: AppSizes.paddingM,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusL,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
