import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:janseva/modules/loan/utils/loan_utils.dart';
import 'package:janseva/routes/arguments.dart';
import 'package:janseva/routes/navigator.dart';
import 'package:janseva/routes/routes.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/loan_provider.dart';
import 'loan_application_screen.dart';

class LoanDetailScreen extends StatefulWidget {
  final LoanDetailScreenArguments args;

  const LoanDetailScreen({Key? key, required this.args}) : super(key: key);

  @override
  State<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          _buildLoanSummaryCard(),
          _buildTabBarSliver(),
          _buildTabContent(),
        ],
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      backgroundColor: LoanUtils.getLoanTypeColor(widget.args.loan.loanType),
      flexibleSpace: FlexibleSpaceBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 20 , left: 20, right: 20),
          child: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            widget.args.loan.categoryName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                LoanUtils.getLoanTypeColor(widget.args.loan.loanType),
                LoanUtils.getLoanTypeColor(widget.args.loan.loanType).withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              Icon(
                LoanUtils.getLoanTypeIcon(widget.args.loan.loanType),
                size: 60,
                color: Colors.white.withOpacity(0.9),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.args.loan.loanType.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: _shareLoadDetails,
          icon: const Icon(Icons.share, color: Colors.white),
        ),
        IconButton(
          onPressed: _addToFavorites,
          icon: Consumer<LoanProvider>(
            builder: (context, loanProvider, child) {
              final isFavorite = loanProvider.isFavorite(widget.args.loan);
              return Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoanSummaryCard() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loan Summary',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryItem(
                        'Amount Range',
                        widget.args.loan.loanAmountRange,
                        Icons.account_balance_wallet,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryItem(
                        'Interest Rate',
                        widget.args.loan.formattedInterestRate,
                        Icons.percent,
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryItem(
                        'Tenure',
                        widget.args.loan.formattedTenure,
                        Icons.schedule,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryItem(
                        'Processing Fee',
                        widget.args.loan.processingFee.formattedFee,
                        Icons.receipt,
                        Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  widget.args.loan.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarSliver() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverTabBarDelegate(
        TabBar(
          controller: _tabController,
          labelColor: LoanUtils.getLoanTypeColor(widget.args.loan.loanType),
          unselectedLabelColor: Colors.grey,
          indicatorColor: LoanUtils.getLoanTypeColor(widget.args.loan.loanType),
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Details', icon: Icon(Icons.info_outline, size: 20)),
            Tab(text: 'Eligibility', icon: Icon(Icons.checklist, size: 20)),
            Tab(text: 'Features', icon: Icon(Icons.star_outline, size: 20)),
            Tab(
              text: 'Charges',
              icon: Icon(Icons.calculate_outlined, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return SliverFillRemaining(
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildDetailsTab(),
          _buildEligibilityTab(),
          _buildFeaturesTab(),
          _buildChargesTab(),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Loan Details', [
            _buildDetailRow(
              'Loan Type',
              widget.args.loan.loanType.toUpperCase(),
            ),
            _buildDetailRow('Status', widget.args.loan.status.toUpperCase()),
            _buildDetailRow(
              'Minimum Amount',
              widget.args.loan.formattedMinAmount,
            ),
            _buildDetailRow(
              'Maximum Amount',
              widget.args.loan.formattedMaxAmount,
            ),
            _buildDetailRow(
              'Interest Rate',
              widget.args.loan.formattedInterestRate,
            ),
            _buildDetailRow(
              'Minimum Tenure',
              '${widget.args.loan.minTenureMonths} months',
            ),
            _buildDetailRow(
              'Maximum Tenure',
              '${widget.args.loan.maxTenureMonths} months',
            ),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Terms & Conditions', [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                widget.args.loan.termsAndConditions,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildEligibilityTab() {
    final criteria = widget.args.loan.eligibilityCriteria;
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Eligibility Criteria', [
            _buildDetailRow('Age Range', criteria.formattedAgeRange),
            _buildDetailRow('Minimum Income', criteria.formattedMinIncome),
            _buildDetailRow('Credit Score', criteria.formattedCreditScore),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Required Documents',
            criteria.requiredDocuments
                .map(
                  (doc) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Icon(
                          Icons.description,
                          size: 20,
                          color: LoanUtils.getLoanTypeColor(widget.args.loan.loanType),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            doc,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesTab() {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: _buildInfoCard(
        'Loan Features',
        widget.args.loan.features
            .map(
              (feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: LoanUtils.getLoanTypeColor(widget.args.loan.loanType),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildChargesTab() {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoCard('Processing Charges', [
            _buildDetailRow(
              'Type',
              widget.args.loan.processingFee.type.toUpperCase(),
            ),
            _buildDetailRow(
              'Amount',
              widget.args.loan.processingFee.formattedFee,
            ),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Prepayment Charges', [
            _buildDetailRow(
              'Type',
              widget.args.loan.prepaymentCharges.type.toUpperCase(),
            ),
            _buildDetailRow(
              'Amount',
              widget.args.loan.prepaymentCharges.formattedCharges,
            ),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Late Payment Charges', [
            _buildDetailRow(
              'Type',
              widget.args.loan.latePaymentCharges.type.toUpperCase(),
            ),
            _buildDetailRow(
              'Amount',
              widget.args.loan.latePaymentCharges.formattedCharges,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: LoanUtils.getLoanTypeColor(widget.args.loan.loanType),
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
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
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _calculateEMI,
              icon: const Icon(Icons.calculate),
              label: const Text('Calculate EMI'),
              style: OutlinedButton.styleFrom(
                foregroundColor: LoanUtils.getLoanTypeColor(widget.args.loan.loanType),
                side: BorderSide(
                  color: LoanUtils.getLoanTypeColor(widget.args.loan.loanType),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: _applyForLoan,
              icon: const Icon(Icons.send),
              label: const Text('Apply Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: LoanUtils.getLoanTypeColor(widget.args.loan.loanType),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _shareLoadDetails() {
    // Implement share functionality
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon!')),
    );
  }

  void _addToFavorites() {
    // Implement add to favorites functionality
    HapticFeedback.lightImpact();
    context.read<LoanProvider>().toggleFavorite(widget.args.loan);

    final isFavorite = context.read<LoanProvider>().isFavorite(
      widget.args.loan,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite ? 'Added to favorites!' : 'Removed from favorites!',
        ),
      ),
    );
  }

  void _calculateEMI() {
    // Navigate to EMI calculator
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => _buildEMICalculatorDialog(),
    );
  }

  Widget _buildEMICalculatorDialog() {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController tenureController = TextEditingController();

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.calculate,
            color: LoanUtils.getLoanTypeColor(widget.args.loan.loanType),
          ),
          const SizedBox(width: 8),
          const Text('EMI Calculator'),
        ],
      ),
      content: StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Loan Amount',
                    prefixText: '₹',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: tenureController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Tenure (Months)',
                    suffixText: 'months',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 16),
                Consumer<LoanProvider>(
                  builder: (context, loanProvider, child) {
                    if (amountController.text.isNotEmpty &&
                        tenureController.text.isNotEmpty) {
                      final amount =
                          double.tryParse(amountController.text) ?? 0;
                      final tenure = int.tryParse(tenureController.text) ?? 0;

                      if (amount > 0 && tenure > 0) {
                        final emiData = loanProvider.calculateEMI(
                          principal: amount,
                          annualRate: widget.args.loan.interestRate,
                          tenureMonths: tenure,
                        );

                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildEMIRow(
                                  'Monthly EMI',
                                  '₹${emiData['emi']!.toStringAsFixed(0)}',
                                ),
                                _buildEMIRow(
                                  'Total Amount',
                                  '₹${emiData['totalAmount']!.toStringAsFixed(0)}',
                                ),
                                _buildEMIRow(
                                  'Total Interest',
                                  '₹${emiData['totalInterest']!.toStringAsFixed(0)}',
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }

                    return const Text(
                      'Enter amount and tenure to calculate EMI',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildEMIRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _applyForLoan() {
    // Navigate to loan application
    HapticFeedback.lightImpact();
    push(
      NamedRoutes.loanApplicationForm,
      arguments: LoanDetailScreenArguments(loan: widget.args.loan),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
