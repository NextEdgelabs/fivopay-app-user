import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';

class LoanApplicationProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color primaryColor;

  const LoanApplicationProgressIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanProvider>(
      builder: (context, loanProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: List.generate(totalSteps, (index) {
                  bool isValid = index < totalSteps - 1
                      ? loanProvider.isStepValid(index)
                      : true; // Last step (review) is always valid
                  bool isCurrent = index == currentStep;
                  bool isPassed = index < currentStep;

                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index < totalSteps - 1 ? 8 : 0,
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: isPassed
                                  ? Colors.white
                                  : isCurrent
                                  ? (isValid ? Colors.white : Colors.orange)
                                  : Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (isPassed || (isCurrent && isValid))
                            Icon(
                              isPassed
                                  ? Icons.check_circle
                                  : Icons.radio_button_checked,
                              color: Colors.white,
                              size: 16,
                            )
                          else if (isCurrent && !isValid)
                            Icon(
                              Icons.error_outline,
                              color: Colors.orange,
                              size: 16,
                            )
                          else
                            Icon(
                              Icons.radio_button_unchecked,
                              color: Colors.white.withOpacity(0.5),
                              size: 16,
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),
              Text(
                'Step ${currentStep + 1} of $totalSteps',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _getStepTitle(currentStep),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),

              // Show validation status for current step
              if (!loanProvider.isStepValid(currentStep) &&
                  currentStep < totalSteps - 1)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orange, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Incomplete',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Loan Details';
      case 1:
        return 'Personal Information';
      case 2:
        return 'Employment Details';
      case 3:
        return 'Review & Submit';
      default:
        return '';
    }
  }
}
