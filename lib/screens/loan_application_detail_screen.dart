import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:janseva/modules/loan/models/document_model.dart';
import 'package:janseva/modules/loan/models/loan_application_response.dart';
import 'package:janseva/modules/loan/screens/esign/view_pdf.dart';
import 'package:janseva/routes/arguments.dart';
import 'package:janseva/routes/navigator.dart';
import 'package:janseva/routes/routes.dart';
import 'package:janseva/screens/document_viewer_screen.dart';
import 'package:janseva/utils/constants.dart';
import 'package:janseva/utils/theme_extension.dart';
import 'package:provider/provider.dart';

import '../modules/auth/provider/auth_provider.dart';
import '../services/common_utils.dart';

class LoanApplicationDetailScreen extends StatelessWidget {
  final LoanApplicationData loan;

  const LoanApplicationDetailScreen({super.key, required this.loan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bgColors,
      appBar: AppBar(
        title: const Text('Loan Application Details'),
        elevation: 0,
        backgroundColor: context.colors.brandColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            _buildStatusBanner(context),

            const SizedBox(height: AppSizes.paddingL),

            // Amount Card
            _buildAmountCard(context),

            const SizedBox(height: AppSizes.paddingL),

            // Application Details
            _buildSectionCard(
              context,
              title: 'Application Details',
              icon: Icons.description,
              children: [
                _buildDetailRow(
                  context,
                  'Application ID',
                  loan.id,
                  icon: Icons.tag,
                ),
                _buildDivider(context),
                _buildDetailRow(
                  context,
                  'Applied Date',
                  _formatDate(loan.createdAt),
                  icon: Icons.calendar_today,
                ),
                _buildDivider(context),
                _buildDetailRow(
                  context,
                  'Last Updated',
                  _formatDate(loan.updatedAt),
                  icon: Icons.update,
                ),
                if (loan.esignStatus?.result?.document?.signedAt != null) ...[
                  _buildDivider(context),
                  _buildDetailRow(
                    context,
                    'Signed At',
                    _formatDate(loan.esignStatus!.result!.document!.signedAt),
                    icon: Icons.draw,
                    valueColor: context.colors.alert1,
                  ),
                ],
              ],
            ),

            const SizedBox(height: AppSizes.paddingM),

            // Loan Product Details
            if (loan.product != null) ...[
              _buildSectionCard(
                context,
                title: 'Loan Product',
                icon: Icons.inventory_2,
                children: [
                  _buildDetailRow(
                    context,
                    'Product Name',
                    loan.product!.name,
                    icon: Icons.label,
                  ),
                  if (loan.product!.description.isNotEmpty) ...[
                    _buildDivider(context),
                    _buildDetailRow(
                      context,
                      'Description',
                      loan.product!.description,
                      icon: Icons.info_outline,
                    ),
                  ],
                  _buildDivider(context),
                  _buildDetailRow(
                    context,
                    context.read<AuthProvider>().isEthicalBanking
                        ? 'Profit Rate'
                        : 'Interest Rate',
                    '${loan.product!.interestRate}% p.a.',
                    icon: Icons.percent,
                    valueColor: context.colors.brandColor,
                    isBold: true,
                  ),
                  _buildDivider(context),
                  _buildDetailRow(
                    context,
                    'Processing Fee',
                    loan.product!.processingFee?.formattedCharges != null
                        ? '${loan.product!.processingFee?.formattedCharges} %'
                        : 'N/A',
                    icon: Icons.receipt,
                  ),
                  if (loan.product!.minAmount != null &&
                      loan.product!.maxAmount != null) ...[
                    _buildDivider(context),
                    _buildDetailRow(
                      context,
                      'Amount Range',
                      '₹${loan.product!.minAmount} - ₹${loan.product!.maxAmount}',
                      icon: Icons.money,
                    ),
                  ],
                  if (loan.product!.minTenureMonths != null &&
                      loan.product!.maxTenureMonths != null) ...[
                    _buildDivider(context),
                    _buildDetailRow(
                      context,
                      'Tenure Range',
                      '${loan.product!.minTenureMonths} - ${loan.product!.maxTenureMonths} months',
                      icon: Icons.schedule,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSizes.paddingM),
            ],

            // Category Details
            if (loan.category != null) ...[
              _buildSectionCard(
                context,
                title: 'Loan Category',
                icon: Icons.category,
                children: [
                  _buildDetailRow(
                    context,
                    'Category',
                    loan.category!.categoryName,
                    icon: Icons.folder,
                  ),
                  if (loan.category!.description.isNotEmpty) ...[
                    _buildDivider(context),
                    _buildDetailRow(
                      context,
                      'Description',
                      loan.category!.description,
                      icon: Icons.description,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSizes.paddingM),
            ],

            // Agreement Details
            if (loan.agreement != null) ...[
              _buildSectionCard(
                context,
                title: 'Agreement Information',
                icon: Icons.article,
                children: [
                  _buildDetailRow(
                    context,
                    'Agreement ID',
                    loan.agreement!.id ?? 'N/A',
                    icon: Icons.assignment,
                  ),
                  if (loan.agreement!.estampId != null) ...[
                    _buildDivider(context),
                    _buildDetailRow(
                      context,
                      'E-Stamp ID',
                      loan.agreement!.estampId!,
                      icon: Icons.verified,
                    ),
                  ],
                  if (loan.agreement!.createdAt != null) ...[
                    _buildDivider(context),
                    _buildDetailRow(
                      context,
                      'Agreement Date',
                      _formatDate(loan.agreement!.createdAt!),
                      icon: Icons.event,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSizes.paddingM),
            ],

            // Applicant Details
            if (loan.userId != null) ...[
              _buildSectionCard(
                context,
                title: 'Applicant Information',
                icon: Icons.person,
                children: [
                  _buildDetailRow(
                    context,
                    'Name',
                    '${loan.userId!.name ?? ''}'.trim(),
                    icon: Icons.person_outline,
                  ),
                  if (loan.userId!.phoneNumber != null) ...[
                    _buildDivider(context),
                    _buildDetailRow(
                      context,
                      'Phone',
                      loan.userId!.phoneNumber,
                      icon: Icons.phone,
                    ),
                  ],
                  if (loan.userId!.email != null) ...[
                    _buildDivider(context),
                    _buildDetailRow(
                      context,
                      'Email',
                      loan.userId!.email!,
                      icon: Icons.email,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSizes.paddingM),
            ],

            // Documents Section
            if (loan.documents.isNotEmpty) ...[
              _buildDocumentsSection(context),
              const SizedBox(height: AppSizes.paddingM),
            ],

            // Action Buttons
            _buildActionButtons(context),

            const SizedBox(height: AppSizes.paddingXL),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(BuildContext context) {
    final statusColor = _getStatusColor(loan.approvalStatus);
    final statusText = _getStatusText(loan.approvalStatus);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: statusColor.withOpacity(0.3), width: 2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            child: Icon(
              _getStatusIcon(loan.approvalStatus),
              color: statusColor,
              size: AppSizes.iconSizeL,
            ),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Application Status',
                  style: AppTextStyles.caption.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  statusText,
                  style: AppTextStyles.heading3.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountCard(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      padding: const EdgeInsets.all(AppSizes.paddingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colors.gradientOne, context.colors.gradientTwo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        boxShadow: [
          BoxShadow(
            color: context.colors.brandColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Loan Amount',
            style: AppTextStyles.body2.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            '₹${loan.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
          if (loan.product?.interestRate != null) ...[
            const SizedBox(height: AppSizes.paddingM),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingL,
                vertical: AppSizes.paddingS,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppSizes.radiusL),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.percent, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '${context.read<AuthProvider>().isEthicalBanking ? 'Profit:' : 'Interest:'} ${loan.product!.interestRate}% p.a.',
                    style: AppTextStyles.body2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      decoration: BoxDecoration(
        color: context.colors.bgColors,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: context.colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.colors.brandColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  ),
                  child: Icon(
                    icon,
                    size: AppSizes.iconSizeM,
                    color: context.colors.brandColor,
                  ),
                ),
                const SizedBox(width: AppSizes.paddingM),
                Text(
                  title,
                  style: AppTextStyles.heading3.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
          Container(height: 1, color: context.colors.border),
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    IconData? icon,
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: AppSizes.iconSizeS,
            color: context.colors.textSecondary,
          ),
          const SizedBox(width: AppSizes.paddingS),
        ],
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.body2.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: AppSizes.paddingM),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.body1.copyWith(
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: valueColor ?? context.colors.text,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSizes.paddingM),
      height: 1,
      color: context.colors.border,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      child: Column(
        children: [
          if (loan.esignStatus != null)
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DocumentViewerScreen(
                        url: loan.esignStatus!.result!.document!.signedUrl,
                        documentName: loan.esignStatus!.result!.document!.info,
                        isPdf: isPdfDocument(
                          loan.esignStatus!.result!.document!.signedUrl,
                        ),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.visibility_outlined, size: 20),
                label: const Text('View Signed Agreement'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.brandColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusL),
                  ),
                ),
              ),
            )
          else if (loan.agreement?.estampId != null)
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: ElevatedButton.icon(
                onPressed: () {
                  push(
                    NamedRoutes.signAgreement,
                    arguments: EsignLoanArguments(loan: loan),
                  );
                },
                icon: const Icon(Icons.draw_outlined, size: 20),
                label: const Text('Sign Agreement'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEA580C),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusL),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(String status) {
    return status.isNotEmpty
        ? status[0].toUpperCase() + status.substring(1).toLowerCase()
        : status;
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  Widget _buildDocumentsSection(BuildContext context) {
    // Parse documents from dynamic list
    List<LoanDocumentModel> documents = [];
    try {
      documents = loan.documents
          .map((doc) {
            if (doc is Map<String, dynamic>) {
              return LoanDocumentModel.fromJson(doc);
            }
            return null;
          })
          .whereType<LoanDocumentModel>()
          .toList();
    } catch (e) {
      // If parsing fails, documents list will remain empty
      print('Error parsing documents: $e');
    }

    if (documents.isEmpty) {
      return _buildSectionCard(
        context,
        title: 'Documents',
        icon: Icons.folder_open,
        children: [
          Text(
            'No documents available',
            style: AppTextStyles.body1.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      decoration: BoxDecoration(
        color: context.colors.bgColors,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: context.colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.colors.brandColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  ),
                  child: Icon(
                    Icons.folder_open,
                    size: AppSizes.iconSizeM,
                    color: context.colors.brandColor,
                  ),
                ),
                const SizedBox(width: AppSizes.paddingM),
                Text(
                  'Documents',
                  style: AppTextStyles.heading3.copyWith(fontSize: 16),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingM,
                    vertical: AppSizes.paddingS,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.brandColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  ),
                  child: Text(
                    '${documents.length}',
                    style: AppTextStyles.body2.copyWith(
                      color: context.colors.brandColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: context.colors.border),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSizes.paddingL),
            itemCount: documents.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSizes.paddingM),
            itemBuilder: (context, index) {
              final document = documents[index];
              return _buildDocumentItem(context, document);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(BuildContext context, LoanDocumentModel document) {
    final isPdf = isPdfDocument(document.documentUrl);
    final iconData = isPdf ? Icons.picture_as_pdf : Icons.image;
    final iconColor = isPdf ? Colors.red : Colors.blue;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DocumentViewerScreen(
              url: document.documentUrl,
              documentName: document.documentName,
              isPdf: isPdf,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(AppSizes.radiusM),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color: context.colors.bgColors,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(color: context.colors.border, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
              ),
              child: Icon(iconData, color: iconColor, size: AppSizes.iconSizeL),
            ),
            const SizedBox(width: AppSizes.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.documentName,
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isPdf ? 'PDF' : 'IMAGE',
                          style: AppTextStyles.caption.copyWith(
                            color: iconColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      // if (document.status != null) ...[
                      //   const SizedBox(width: AppSizes.paddingS),
                      //   Container(
                      //     padding: const EdgeInsets.symmetric(
                      //       horizontal: 8,
                      //       vertical: 2,
                      //     ),
                      //     decoration: BoxDecoration(
                      //       color: _getDocumentStatusColor(
                      //         document.status!,
                      //       ).withOpacity(0.1),
                      //       borderRadius: BorderRadius.circular(4),
                      //     ),
                      //     child: Text(
                      //       document.status!.name.toUpperCase(),
                      //       style: AppTextStyles.caption.copyWith(
                      //         color: _getDocumentStatusColor(document.status!),
                      //         fontWeight: FontWeight.w600,
                      //         fontSize: 10,
                      //       ),
                      //     ),
                      //   ),
                      // ],
                    ],
                  ),
                  if (document.uploadedAt != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Uploaded: ${_formatDate(document.uploadedAt!)}',
                      style: AppTextStyles.caption.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSizes.paddingS),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: context.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Color _getDocumentStatusColor(DocumentStatus status) {
    switch (status) {
      case DocumentStatus.approved:
        return AppColors.success;
      case DocumentStatus.pending:
        return AppColors.warning;
      case DocumentStatus.rejected:
        return AppColors.error;
    }
  }
}
