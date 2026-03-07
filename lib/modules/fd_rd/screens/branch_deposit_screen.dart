import 'package:flutter/material.dart';
import 'package:janseva/modules/fd_rd/model/deposit_category_model.dart';
import 'package:janseva/modules/fd_rd/model/deposit_product_model.dart';
import 'package:janseva/utils/app_size.dart';
import 'package:janseva/utils/constants.dart';
import 'package:janseva/utils/theme_extension.dart';
import 'package:janseva/widgets/gradient_button.dart';

class BranchDepositScreen extends StatefulWidget {
  final DepositCategory category;
  final DepositProduct product;
  final double amount;
  final String fdName;

  const BranchDepositScreen({
    Key? key,
    required this.category,
    required this.product,
    required this.amount,
    required this.fdName,
  }) : super(key: key);

  @override
  State<BranchDepositScreen> createState() => _BranchDepositScreenState();
}

class _BranchDepositScreenState extends State<BranchDepositScreen> {
  String? _selectedBranch;

  final List<Map<String, String>> _branches = [
    {
      'name': 'Main Branch - Mumbai',
      'address': '123 MG Road, Mumbai - 400001',
      'phone': '+91 22 1234 5678',
      'timing': 'Mon-Fri: 10:00 AM - 5:00 PM\nSat: 10:00 AM - 2:00 PM',
    },
    {
      'name': 'Andheri Branch',
      'address': '456 Link Road, Andheri West, Mumbai - 400053',
      'phone': '+91 22 8765 4321',
      'timing': 'Mon-Fri: 10:00 AM - 5:00 PM\nSat: 10:00 AM - 2:00 PM',
    },
    {
      'name': 'Borivali Branch',
      'address': '789 Station Road, Borivali East, Mumbai - 400066',
      'phone': '+91 22 9876 5432',
      'timing': 'Mon-Fri: 10:00 AM - 5:00 PM\nSat: 10:00 AM - 2:00 PM',
    },
  ];

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
        title: const Text('Branch Deposit'),
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
                ],
              ),
            ),
            SizedBox(height: 24.dh),

            // Instructions
            Container(
              padding: EdgeInsets.all(AppSizes.paddingL.dw),
              decoration: BoxDecoration(
                color: context.colors.brandColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusL),
                border: Border.all(
                  color: context.colors.brandColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: context.colors.brandColor,
                    size: 20.dw,
                  ),
                  SizedBox(width: 12.dw),
                  Expanded(
                    child: Text(
                      'Visit your nearest branch with this booking reference and required documents',
                      style: AppTextStyles.body2.copyWith(
                        color: context.colors.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.dh),

            // Select Branch
            Text(
              'Select Branch',
              style: AppTextStyles.heading3.copyWith(fontSize: 16.dw),
            ),
            SizedBox(height: 12.dh),

            // Branch List
            ...List.generate(_branches.length, (index) {
              final branch = _branches[index];
              final isSelected = _selectedBranch == branch['name'];
              return Padding(
                padding: EdgeInsets.only(bottom: 12.dh),
                child: _buildBranchCard(
                  branch: branch,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedBranch = branch['name'];
                    });
                  },
                ),
              );
            }),

            SizedBox(height: 24.dh),

            // Documents Required
            Text(
              'Documents Required',
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
                  _buildDocumentItem('Aadhaar Card'),
                  SizedBox(height: 8.dh),
                  _buildDocumentItem('PAN Card'),
                  SizedBox(height: 8.dh),
                  _buildDocumentItem('Passport size photo'),
                  SizedBox(height: 8.dh),
                  _buildDocumentItem('Cash/Cheque for deposit amount'),
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
            onTap: _selectedBranch != null
                ? () {
                    // TODO: Confirm branch booking
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Branch booking at $_selectedBranch confirmed!',
                        ),
                      ),
                    );
                  }
                : null,
            text: 'Confirm Branch Visit',
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

  Widget _buildBranchCard({
    required Map<String, String> branch,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusL),
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingL.dw),
        decoration: BoxDecoration(
          color: context.colors.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          border: Border.all(
            color: isSelected
                ? context.colors.brandColor
                : context.colors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.paddingM.dw),
              decoration: BoxDecoration(
                color: context.colors.brandColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on,
                color: context.colors.brandColor,
                size: 20.dw,
              ),
            ),
            SizedBox(width: 12.dw),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    branch['name']!,
                    style: AppTextStyles.heading3.copyWith(fontSize: 14.dw),
                  ),
                  SizedBox(height: 8.dh),
                  Row(
                    children: [
                      Icon(
                        Icons.place,
                        size: 14.dw,
                        color: context.colors.textSecondary,
                      ),
                      SizedBox(width: 4.dw),
                      Expanded(
                        child: Text(
                          branch['address']!,
                          style: AppTextStyles.body2.copyWith(
                            color: context.colors.textSecondary,
                            fontSize: 12.dw,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.dh),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 14.dw,
                        color: context.colors.textSecondary,
                      ),
                      SizedBox(width: 4.dw),
                      Text(
                        branch['phone']!,
                        style: AppTextStyles.body2.copyWith(
                          color: context.colors.textSecondary,
                          fontSize: 12.dw,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.dh),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14.dw,
                        color: context.colors.textSecondary,
                      ),
                      SizedBox(width: 4.dw),
                      Expanded(
                        child: Text(
                          branch['timing']!,
                          style: AppTextStyles.body2.copyWith(
                            color: context.colors.textSecondary,
                            fontSize: 12.dw,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: context.colors.brandColor,
                size: 24.dw,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentItem(String document) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_outline,
          color: context.colors.brandColor,
          size: 18.dw,
        ),
        SizedBox(width: 8.dw),
        Text(
          document,
          style: AppTextStyles.body2.copyWith(color: context.colors.text),
        ),
      ],
    );
  }
}
