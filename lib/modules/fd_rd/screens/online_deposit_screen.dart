import 'package:flutter/material.dart';
import 'package:janseva/modules/fd_rd/model/deposit_category_model.dart';
import 'package:janseva/modules/fd_rd/model/deposit_product_model.dart';
import 'package:janseva/utils/app_size.dart';
import 'package:janseva/utils/constants.dart';
import 'package:janseva/utils/theme_extension.dart';
import 'package:janseva/widgets/gradient_button.dart';

class OnlineDepositScreen extends StatefulWidget {
  final DepositCategory category;
  final DepositProduct product;
  final double amount;
  final String fdName;

  const OnlineDepositScreen({
    Key? key,
    required this.category,
    required this.product,
    required this.amount,
    required this.fdName,
  }) : super(key: key);

  @override
  State<OnlineDepositScreen> createState() => _OnlineDepositScreenState();
}

class _OnlineDepositScreenState extends State<OnlineDepositScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: context.colors.text,
            size: 24.dw,
          ),
        ),
        title: const Text('Online Deposit'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.paddingL.dw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Container(
              padding: EdgeInsets.all(AppSizes.paddingL.dw),
              decoration: BoxDecoration(
                color: context.colors.cardBackground,
                borderRadius: BorderRadius.circular(AppSizes.radiusL),
                border: Border.all(color: context.colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deposit Summary',
                    style: AppTextStyles.heading3.copyWith(fontSize: 16.dw),
                  ),
                  SizedBox(height: 16.dh),
                  _buildSummaryRow('Category', widget.category.categoryName),
                  SizedBox(height: 12.dh),
                  _buildSummaryRow('Product', widget.product.productName),
                  SizedBox(height: 12.dh),
                  _buildSummaryRow('FD Name', widget.fdName),
                  SizedBox(height: 12.dh),
                  _buildSummaryRow(
                    'Amount',
                    '₹ ${widget.amount.toStringAsFixed(0)}',
                    isHighlighted: true,
                  ),
                  SizedBox(height: 12.dh),
                  _buildSummaryRow(
                    'Interest Rate',
                    '${widget.product.defaultInterestRate.toStringAsFixed(2)}% p.a',
                  ),
                  SizedBox(height: 12.dh),
                  _buildSummaryRow(
                    'Tenure',
                    '${widget.product.maxTenureMonths} months',
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.dh),

            // Payment Instructions
            Text(
              'Payment Instructions',
              style: AppTextStyles.heading3.copyWith(fontSize: 16.dw),
            ),
            SizedBox(height: 12.dh),
            Container(
              padding: EdgeInsets.all(AppSizes.paddingL.dw),
              decoration: BoxDecoration(
                color: context.colors.bgColors,
                borderRadius: BorderRadius.circular(AppSizes.radiusL),
                border: Border.all(color: context.colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInstructionStep(
                    '1',
                    'Use online banking or UPI to transfer funds',
                  ),
                  SizedBox(height: 12.dh),
                  _buildInstructionStep(
                    '2',
                    'Upload payment proof/transaction screenshot',
                  ),
                  SizedBox(height: 12.dh),
                  _buildInstructionStep(
                    '3',
                    'Your deposit will be activated after verification',
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.dh),

            // Bank Details Card
            Container(
              padding: EdgeInsets.all(AppSizes.paddingL.dw),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.colors.brandColor.withOpacity(0.1),
                    context.colors.gradientTwo.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusL),
                border: Border.all(
                  color: context.colors.brandColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance,
                        color: context.colors.brandColor,
                        size: 20.dw,
                      ),
                      SizedBox(width: 8.dw),
                      Text(
                        'Bank Account Details',
                        style: AppTextStyles.heading3.copyWith(
                          fontSize: 16.dw,
                          color: context.colors.brandColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.dh),
                  _buildBankDetail('Bank Name', 'JanSeva Co-operative Bank'),
                  SizedBox(height: 8.dh),
                  _buildBankDetail('Account Number', '1234567890123456'),
                  SizedBox(height: 8.dh),
                  _buildBankDetail('IFSC Code', 'JSEV0001234'),
                  SizedBox(height: 8.dh),
                  _buildBankDetail('Account Holder', 'JanSeva Deposits'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.paddingL.dw),
          child: GradientButton(
            onTap: () {
              // TODO: Implement payment proof upload
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment proof upload coming soon...'),
                ),
              );
            },
            text: 'Upload Payment Proof',
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body2.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.heading3.copyWith(
            fontSize: 14.dw,
            color: isHighlighted
                ? context.colors.brandColor
                : context.colors.text,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionStep(String number, String instruction) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24.dw,
          height: 24.dw,
          decoration: BoxDecoration(
            color: context.colors.brandColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: AppTextStyles.body2.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.dw),
        Expanded(
          child: Text(
            instruction,
            style: AppTextStyles.body2.copyWith(color: context.colors.text),
          ),
        ),
      ],
    );
  }

  Widget _buildBankDetail(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body2.copyWith(
            color: context.colors.textSecondary,
            fontSize: 13.dw,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 13.dw,
              ),
            ),
            SizedBox(width: 8.dw),
            InkWell(
              onTap: () {
                // TODO: Copy to clipboard
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('$label copied!')));
              },
              child: Icon(
                Icons.copy,
                size: 16.dw,
                color: context.colors.brandColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
