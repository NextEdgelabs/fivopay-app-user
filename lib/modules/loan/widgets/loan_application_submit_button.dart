import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/app_color_extension.dart';

class LoanApplicationSubmitButton extends StatelessWidget {
  final bool agreeToTerms;
  final VoidCallback onSubmit;
  final String loanType;

  const LoanApplicationSubmitButton({
    Key? key,
    required this.agreeToTerms,
    required this.onSubmit,
    required this.loanType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanProvider>(
      builder: (context, loanProvider, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: agreeToTerms && !loanProvider.isApplying
                ? onSubmit
                : null,
            icon: loanProvider.isApplying
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.send),
            label: Text(
              loanProvider.isApplying ? 'Submitting...' : 'Submit Application',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.appColors.brandColor,
              foregroundColor: context.appColors.buttonLabelText,
              elevation: 0,
              minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusS),
              ),
              textStyle: AppTextStyles.button,
            ),
          ),
        );
      },
    );
  }
}
