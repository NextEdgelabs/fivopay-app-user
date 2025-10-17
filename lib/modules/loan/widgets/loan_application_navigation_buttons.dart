import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';

class LoanApplicationNavigationButtons extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final Color primaryColor;

  const LoanApplicationNavigationButtons({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    this.onPrevious,
    this.onNext,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanProvider>(
      builder: (context, loanProvider, child) {
        bool isCurrentStepValid = loanProvider.isStepValid(currentStep);
        List<String> validationErrors = loanProvider.getStepValidationErrors(
          currentStep,
        );

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Show validation summary if current step has errors
              if (!isCurrentStepValid && validationErrors.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Please complete all required fields',
                              style: TextStyle(
                                color: Colors.orange.shade700,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (validationErrors.length <= 2)
                              ...validationErrors
                                  .take(2)
                                  .map(
                                    (error) => Text(
                                      '• $error',
                                      style: TextStyle(
                                        color: Colors.orange.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                  .toList()
                            else
                              Text(
                                '• ${validationErrors.length} items need attention',
                                style: TextStyle(
                                  color: Colors.orange.shade600,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              Row(
                children: [
                  if (currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onPrevious,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: primaryColor),
                          foregroundColor: primaryColor,
                        ),
                        child: const Text('Previous'),
                      ),
                    ),
                  if (currentStep > 0) const SizedBox(width: 16),
                  if (currentStep < totalSteps - 1)
                    Expanded(
                      flex: currentStep > 0 ? 1 : 2,
                      child: ElevatedButton(
                        onPressed: onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isCurrentStepValid
                              ? primaryColor
                              : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(isCurrentStepValid ? 'Next' : 'Complete Step'),
                            const SizedBox(width: 8),
                            Icon(
                              isCurrentStepValid
                                  ? Icons.arrow_forward
                                  : Icons.warning_amber_rounded,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
