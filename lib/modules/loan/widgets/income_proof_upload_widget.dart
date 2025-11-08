import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';

/// Widget for uploading income proof documents
/// Allows users to select document type (Payslip, Bank Statement, ITR) and upload files
class IncomeProofUploadWidget extends StatefulWidget {
  final Color? primaryColor;
  final Function(String proofType)? onPickFile;

  const IncomeProofUploadWidget({
    Key? key,
    this.primaryColor,
    this.onPickFile,
  }) : super(key: key);

  @override
  State<IncomeProofUploadWidget> createState() =>
      _IncomeProofUploadWidgetState();
}

class _IncomeProofUploadWidgetState extends State<IncomeProofUploadWidget> {
  String? _selectedProofType;
  bool _isUploading = false;

  final List<Map<String, dynamic>> _proofTypes = [
    {
      'value': 'payslip',
      'label': 'Salary Slip / Payslip',
      'icon': Icons.receipt_long,
    },
    {
      'value': 'bank_statement',
      'label': 'Bank Statement',
      'icon': Icons.account_balance,
    },
    {
      'value': 'itr',
      'label': 'Income Tax Return (ITR)',
      'icon': Icons.description,
    },
  ];

  Color get primaryColor =>
      widget.primaryColor ?? Theme.of(context).colorScheme.primary;

  void _handlePickFile() async {
    if (_selectedProofType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select income proof type first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (widget.onPickFile != null) {
      setState(() => _isUploading = true);
      try {
        await widget.onPickFile!(_selectedProofType!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Income proof uploaded successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to upload: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isUploading = false);
        }
      }
    }
  }

  String? _getUploadedFileName() {
    if (_selectedProofType == null) return null;
    
    final loanProvider = context.watch<LoanProvider>();
    final documents = loanProvider.applicationData['documents'] as List?;
    
    if (documents != null) {
      for (var doc in documents) {
        final type = doc.documentType as String?;
        // Check if the document type matches the currently selected proof type
        if (type != null && type == 'income_proof_$_selectedProofType') {
          return doc.documentName as String?;
        }
      }
    }
    return null;
  }

  void _removeDocument() {
    if (_selectedProofType == null) return;
    
    final loanProvider = context.read<LoanProvider>();
    loanProvider.removeDocument('income_proof_$_selectedProofType');
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document removed successfully'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uploadedFileName = _getUploadedFileName();
    final hasUploadedFile = uploadedFileName != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.upload_file,
                color: primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Upload Income Proof',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
              if (hasUploadedFile)
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Document Type Dropdown
          Text(
            'Select Document Type *',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _selectedProofType != null
                    ? primaryColor
                    : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedProofType,
                hint: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(Icons.document_scanner, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Choose income proof type',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                items: _proofTypes.map((proof) {
                  return DropdownMenuItem<String>(
                    value: proof['value'],
                    child: Row(
                      children: [
                        Icon(
                          proof['icon'],
                          color: primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            proof['label'],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProofType = value;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Upload Button or File Display
          if (!hasUploadedFile)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isUploading ? null : _handlePickFile,
                icon: _isUploading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryColor),
                        ),
                      )
                    : Icon(Icons.cloud_upload, color: primaryColor),
                label: Text(
                  _isUploading ? 'Uploading...' : 'Choose File',
                  style: TextStyle(
                    color: _isUploading ? Colors.grey : primaryColor,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryColor, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.green.shade300,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green.shade700,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Document Uploaded',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          uploadedFileName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _removeDocument,
                    icon: Icon(
                      Icons.close,
                      color: Colors.red.shade700,
                    ),
                    tooltip: 'Remove document',
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // Info Text
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Supported formats: PDF, JPG, PNG (Max 5MB). Upload latest 3 months salary slip or 6 months bank statement or last year ITR.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
