import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onActionPressed;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.heading3),
              if (subtitle != null) ...[
                const SizedBox(height: AppSizes.paddingXS),
                Text(subtitle!, style: AppTextStyles.body2),
              ],
            ],
          ),
        ),
        if (actionText != null && onActionPressed != null)
          TextButton(onPressed: onActionPressed, child: Text(actionText!)),
      ],
    );
  }
}
