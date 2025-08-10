import 'package:flutter/material.dart';
import '../utils/constants.dart';

class StepHeader extends StatelessWidget {
  final String title;
  final int currentStep;
  final int totalSteps;

  const StepHeader({
    super.key,
    required this.title,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.heading2),
              Text(
                'Step $currentStep of $totalSteps',
                style: AppTextStyles.body2,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingS),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            child: LinearProgressIndicator(
              value: (currentStep) / totalSteps,
              minHeight: 8,
              backgroundColor: AppColors.borderLight,
            ),
          ),
        ],
      ),
    );
  }
}
