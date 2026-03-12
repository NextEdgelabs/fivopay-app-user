import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:janseva/utils/theme_extension.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/constants.dart';
import '../utils/policy_strings.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  List<bool> _expandedFaqs = [];

  @override
  void initState() {
    super.initState();
    _expandedFaqs = List.generate(
      PolicyStrings.supportFaqs.length,
      (_) => false,
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open link'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'email':
        return Iconsax.sms;
      case 'phone':
        return Iconsax.call;
      case 'whatsapp':
        return Iconsax.message;
      case 'location':
        return Iconsax.location;
      default:
        return Iconsax.message_question;
    }
  }

  Color _getColorForType(String type, BuildContext context) {
    switch (type) {
      case 'email':
        return AppColors.error;
      case 'phone':
        return context.colors.brandColor;
      case 'whatsapp':
        return AppColors.success;
      case 'location':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

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
          PolicyStrings.supportTitle,
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
                        Iconsax.headphone,
                        color: Colors.white,
                        size: AppSizes.dW * 0.15,
                      ),
                    ),
                    SizedBox(height: AppSizes.paddingM),
                    Text(
                      'How can we help?',
                      style: AppTextStyles.heading2.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSizes.paddingS),
                    Text(
                      PolicyStrings.supportDescription,
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSizes.paddingL),

              // Contact Options
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contact Us', style: AppTextStyles.heading3),
                    SizedBox(height: AppSizes.paddingM),
                    ...PolicyStrings.supportOptions.map((option) {
                      return _buildContactCard(
                        context,
                        title: option['title']!,
                        subtitle: option['subtitle']!,
                        value: option['value']!,
                        iconType: option['icon']!,
                      );
                    }).toList(),
                  ],
                ),
              ),

              SizedBox(height: AppSizes.paddingXL),

              // FAQs Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      PolicyStrings.supportFaqTitle,
                      style: AppTextStyles.heading3,
                    ),
                    SizedBox(height: AppSizes.paddingM),
                    Container(
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
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: PolicyStrings.supportFaqs.length,
                        separatorBuilder: (context, index) =>
                            Divider(height: 1, color: AppColors.border),
                        itemBuilder: (context, index) {
                          final faq = PolicyStrings.supportFaqs[index];
                          return _buildFaqItem(
                            context,
                            question: faq['question']!,
                            answer: faq['answer']!,
                            isExpanded: _expandedFaqs[index],
                            onTap: () {
                              setState(() {
                                _expandedFaqs[index] = !_expandedFaqs[index];
                              });
                            },
                            isFirst: index == 0,
                            isLast:
                                index == PolicyStrings.supportFaqs.length - 1,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSizes.paddingXL),

              // Business Hours Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
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
                        Iconsax.clock,
                        color: context.colors.brandColor,
                        size: AppSizes.iconSizeXL,
                      ),
                      SizedBox(height: AppSizes.paddingM),
                      Text('Business Hours', style: AppTextStyles.heading3),
                      SizedBox(height: AppSizes.paddingS),
                      Text(
                        PolicyStrings.supportBusinessHours,
                        style: AppTextStyles.body2.copyWith(height: 1.6),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppSizes.paddingL),

              // Address Section
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
                    children: [
                      Icon(
                        Iconsax.building,
                        color: AppColors.textSecondary,
                        size: AppSizes.iconSizeXL,
                      ),
                      SizedBox(height: AppSizes.paddingM),
                      Text('Visit Us', style: AppTextStyles.heading3),
                      SizedBox(height: AppSizes.paddingS),
                      Text(
                        PolicyStrings.supportAddress,
                        style: AppTextStyles.body2.copyWith(height: 1.6),
                        textAlign: TextAlign.center,
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

  Widget _buildContactCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String value,
    required String iconType,
  }) {
    final color = _getColorForType(iconType, context);
    final icon = _getIconForType(iconType);

    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.paddingM),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            String url = '';
            if (iconType == 'email') {
              url = 'mailto:$value';
            } else if (iconType == 'phone') {
              url = 'tel:$value';
            } else if (iconType == 'whatsapp') {
              url = 'https://wa.me/${value.replaceAll(RegExp(r'[^0-9]'), '')}';
            }

            if (url.isNotEmpty) {
              _launchUrl(url);
            }
          },
          onLongPress: () {
            if (iconType != 'location') {
              _copyToClipboard(value, title);
            }
          },
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
          child: Padding(
            padding: EdgeInsets.all(AppSizes.paddingL),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSizes.paddingM),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusL),
                  ),
                  child: Icon(icon, color: color, size: AppSizes.iconSizeL),
                ),
                SizedBox(width: AppSizes.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.body1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingXS),
                      Text(subtitle, style: AppTextStyles.body2),
                      SizedBox(height: AppSizes.paddingXS),
                      Text(
                        value,
                        style: AppTextStyles.body2.copyWith(
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textLight,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(
    BuildContext context, {
    required String question,
    required String answer,
    required bool isExpanded,
    required VoidCallback onTap,
    required bool isFirst,
    required bool isLast,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? Radius.circular(AppSizes.radiusXL) : Radius.zero,
          bottom: isLast ? Radius.circular(AppSizes.radiusXL) : Radius.zero,
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.paddingM),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: context.colors.brandColor,
                      size: AppSizes.iconSizeM,
                    ),
                  ),
                ],
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: EdgeInsets.only(top: AppSizes.paddingM),
                  child: Text(
                    answer,
                    style: AppTextStyles.body2.copyWith(height: 1.6),
                  ),
                ),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
