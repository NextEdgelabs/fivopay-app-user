import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:janseva/utils/theme_extension.dart';
import '../../../utils/constants.dart';

class InfoSection extends StatelessWidget {
  final String title;
  final List<String> points;

  const InfoSection({
    super.key,
    this.title = 'About Shares',
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.dW,
      padding: EdgeInsets.all(AppSizes.paddingXL),
      decoration: BoxDecoration(
        color: context.colors.brandColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        border: Border.all(
          color: context.colors.gradientOne.withOpacity(0.6),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: context.colors.gradientOne,
                  shape: BoxShape.circle,
                ),
                child: Icon(Iconsax.information, color: Colors.white, size: 16),
              ),
              SizedBox(width: AppSizes.paddingS),
              Text(
                title,
                style: AppTextStyles.body1.copyWith(
                  color: context.colors.gradientOne,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingM),
          ...points.map(
            (point) => Padding(
              padding: EdgeInsets.only(bottom: AppSizes.paddingS),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: AppTextStyles.body2.copyWith(
                      color: context.colors.gradientOne,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      point,
                      style: AppTextStyles.body2.copyWith(
                        color: context.colors.gradientOne,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
