import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/loan_provider.dart';
import '../utils/loan_utils.dart';

class LoanApplicationProductSelectionWidget extends StatefulWidget {
  final LoanCategory loanCategory;

  const LoanApplicationProductSelectionWidget({
    Key? key,
    required this.loanCategory,
  }) : super(key: key);

  @override
  State<LoanApplicationProductSelectionWidget> createState() =>
      _LoanApplicationProductSelectionWidgetState();
}

class _LoanApplicationProductSelectionWidgetState
    extends State<LoanApplicationProductSelectionWidget> {
  @override
  void initState() {
    super.initState();
    // Initialize products when widget is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loanProvider = context.read<LoanProvider>();
      // Only fetch products if they're not already loaded for this category
      if (loanProvider.availableProducts.isEmpty ||
          loanProvider.selectedLoanCategory?.id != widget.loanCategory.id) {
        loanProvider.getLoanProducts(widget.loanCategory.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanProvider>(
      builder: (context, loanProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(),
              const SizedBox(height: 20),
              _buildProductList(loanProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LoanUtils.getLoanTypeColor(
          widget.loanCategory.loanType,
        ).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: LoanUtils.getLoanTypeColor(
            widget.loanCategory.loanType,
          ).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LoanUtils.getLoanTypeIcon(widget.loanCategory.loanType),
                color: LoanUtils.getLoanTypeColor(widget.loanCategory.loanType),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Select ${widget.loanCategory.categoryName} Product',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Choose the loan product that best fits your needs',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(LoanProvider loanProvider) {
    if (loanProvider.availableProducts.isEmpty) {
      return Center(
        child: Text(
          'No products available for ${widget.loanCategory.categoryName}',
        ),
      );
    }
    if (loanProvider.loadingproducts) {
      return Center(
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Loading loan products...',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Column(
      children: loanProvider.availableProducts.map((product) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildProductCard(product, loanProvider),
        );
      }).toList(),
    );
  }

  Widget _buildProductCard(LoanProduct product, LoanProvider loanProvider) {
    final isSelected = loanProvider.selectedProduct?.id == product.id;
    final primaryColor = LoanUtils.getLoanTypeColor(
      widget.loanCategory.loanType,
    );

    return GestureDetector(
      onTap: () => loanProvider.selectLoanProduct(product),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? primaryColor.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? primaryColor : Colors.grey[400]!,
                      width: 2,
                    ),
                    color: isSelected ? primaryColor : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? primaryColor
                              : const Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip(
                  'Rate: ${product.interestRate}% p.a.',
                  Icons.percent,
                  primaryColor,
                ),
                // const SizedBox(width: 8),
                // _buildInfoChip(
                //   product.processingTime,
                //   Icons.schedule,
                //   primaryColor,
                // ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildInfoChip(
                  '₹${_formatAmount(product.minAmount)} - ₹${_formatAmount(product.maxAmount)}',
                  Icons.account_balance_wallet,
                  primaryColor,
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  '${product.minTenureMonths}-${product.maxTenureMonths} months',
                  Icons.access_time,
                  primaryColor,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: product.features!.take(3).map((feature) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: primaryColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    feature,
                    style: TextStyle(
                      fontSize: 12,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(int amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(1)}Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toString();
  }
}
