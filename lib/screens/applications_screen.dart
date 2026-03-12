import 'package:flutter/material.dart';
import 'package:janseva/modules/fd_rd/deposit_provider.dart';
import 'package:janseva/modules/loan/models/loan_application_response.dart';
import 'package:janseva/modules/loan/providers/loan_provider.dart';
import 'package:janseva/modules/loan/screens/esign/view_pdf.dart';
import 'package:janseva/routes/arguments.dart';
import 'package:janseva/routes/navigator.dart';
import 'package:janseva/routes/routes.dart';
import 'package:provider/provider.dart';
import '../modules/auth/provider/auth_provider.dart';
import '../modules/fd_rd/model/term_deposit_model.dart';
import '../providers/user_provider.dart';
import '../models/fixed_deposit.dart';
import '../services/common_utils.dart';
import '../utils/constants.dart';
import '../components/components.dart';
import 'document_viewer_screen.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      final userId = userProvider.currentUser?.id;

      context.read<LoanProvider>().getmmyLoanApplications();

      if (userId != null) {
        context.read<DepositProvider>().fetchUserTermDeposits(userId);
      }
    });
  }

  String _selectedFilter = 'all'; // all, fd, loan
  String _selectedStatus = 'all'; // all, active, pending, approved, rejected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Applications'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Consumer3<UserProvider, LoanProvider, DepositProvider>(
        builder: (context, userProvider, loanProvider, depositProvider, child) {
          final user = userProvider.currentUser;
          if (user == null) {
            return const Center(
              child: Text('Please log in to view applications'),
            );
          }

          final fixedDeposits = depositProvider.myTermDeposits;
          final loanApplications = loanProvider.myLoanApplications;
          // final depositApplications = ;

          final filteredApplications = _getFilteredApplications(
            fixedDeposits,
            loanApplications,
          );

          return RefreshIndicator(
            onRefresh: () async {
              await userProvider.initializeUser();
              await loanProvider.getmmyLoanApplications();

              final userId = userProvider.currentUser?.id;
              if (userId != null) {
                await depositProvider.refreshDeposits(userId);
              }
            },
            child: filteredApplications.isEmpty
                ? const EmptyState(
                    icon: Icons.description_outlined,
                    title: 'No Applications Found',
                    subtitle: 'You have not applied for any FD or Loan yet.',
                  )
                : NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!depositProvider.isLoadingMoreDeposits &&
                          depositProvider.hasMoreDeposits &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        depositProvider.loadMoreDeposits(user.id);
                      }
                      return false;
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppSizes.paddingL),
                      itemCount:
                          filteredApplications.length +
                          (depositProvider.isLoadingMoreDeposits ? 1 : 0),
                      itemBuilder: (context, index) {
                        // Show loading indicator at the bottom when loading more
                        if (index == filteredApplications.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final application = filteredApplications[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: application is DepositAccountModel
                              ? _buildFDCard(application)
                              : _buildLoanCard(application),
                        );
                      },
                    ),
                  ),
          );
        },
      ),
    );
  }

  List<dynamic> _getFilteredApplications(
    List<DepositAccountModel> fixedDeposits,
    List<LoanApplicationData> loanApplications,
  ) {
    List<dynamic> allApplications = [];

    // Add FD applications
    if (_selectedFilter == 'all' || _selectedFilter == 'fd') {
      allApplications.addAll(fixedDeposits);
    }

    // Add Loan applications
    if (_selectedFilter == 'all' || _selectedFilter == 'loan') {
      allApplications.addAll(loanApplications);
    }

    // Filter by status
    if (_selectedStatus != 'all') {
      allApplications = allApplications.where((app) {
        if (app is FixedDeposit) {
          return app.status == _selectedStatus;
        } else if (app is LoanApplicationData) {
          return app.approvalStatus == _selectedStatus;
        }
        return false;
      }).toList();
    }

    // Sort by date (newest first)
    allApplications.sort((a, b) {
      DateTime dateA = a is FixedDeposit ? a.startDate : a.createdAt;
      DateTime dateB = b is FixedDeposit ? b.startDate : b.createdAt;
      return dateB.compareTo(dateA);
    });

    return allApplications;
  }

  // Removed legacy empty state in favor of shared EmptyState component

  Widget _buildFDCard(DepositAccountModel fd) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          push(
            NamedRoutes.depositDetailScreen,
            arguments: DepositDetailScreenArguments(deposit: fd),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with professional design
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E3A8A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Fixed Deposit',
                            style: TextStyle(
                              color: Color(0xFF1F2937),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Account: ${fd.accountNumber ?? fd.depositId ?? 'N/A'}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(fd.status),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Amount highlight
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F9FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFBAE6FD),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Deposit Amount',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            '₹${(fd.depositAmount ?? 0).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Grid of info
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.calendar_today_outlined,
                            label: 'Tenure',
                            value:
                                '${fd.productId?.lockInPeriodMonths ?? 0} months',
                            color: const Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.calendar_month_outlined,
                            label: 'Opened On',
                            value: _formatDate(fd.createdAt!).trim(),
                            color: const Color(0xFF0891B2),
                            // fullWidth: true,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.percent_outlined,
                            label: context.read<AuthProvider>().isEthicalBanking
                                ? 'Profit Rate'
                                : 'Interest Rate',
                            value:
                                '${(fd.interestRate ?? 0).toStringAsFixed(2)}%',
                            color: const Color(0xFF7C3AED),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.account_balance_wallet_outlined,
                            label: 'Current Balance',
                            value:
                                '₹${(fd.currentBalance ?? 0).toStringAsFixed(0)}',
                            color: const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),

                    // if (fd.branchId?.branchName != null) ...[
                    //   const SizedBox(height: 8),
                    //   _buildInfoCard(
                    //     icon: Icons.location_on_outlined,
                    //     label: 'Branch',
                    //     value: fd.branchId!.branchName!,
                    //     color: const Color(0xFFEA580C),
                    //     fullWidth: true,
                    //   ),
                    // ],
                    // if (fd.createdAt != null) ...[
                    //   const SizedBox(height: 8),
                    //   _buildInfoCard(
                    //     icon: Icons.calendar_month_outlined,
                    //     label: 'Opened On',
                    //     value: _formatDate(fd.createdAt!),
                    //     color: const Color(0xFF0891B2),
                    //     fullWidth: true,
                    //   ),
                    // ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoanCard(LoanApplicationData loan) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          push(
            NamedRoutes.loanApplicationDetailScreen,
            arguments: LoanApplicationDetailScreenArguments(loan: loan),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with professional design
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.receipt_long,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Loan Application',
                            style: TextStyle(
                              color: Color(0xFF1F2937),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'ID: ${loan.id}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(loan.approvalStatus),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Amount highlight
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF5FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFE9D5FF),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Loan Amount',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            '₹${loan.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF7C3AED),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Grid of info
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.calendar_today_outlined,
                            label: 'Applied Date',
                            value: _formatDate(loan.createdAt),
                            color: const Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.draw_outlined,
                            label: 'Signed At',
                            value:
                                loan.esignStatus?.result?.document?.signedAt !=
                                    null
                                ? _formatDate(
                                    loan
                                        .esignStatus!
                                        .result!
                                        .document!
                                        .signedAt,
                                  )
                                : 'Not signed',
                            color: const Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Action buttons
                    if (loan.esignStatus != null)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DocumentViewerScreen(
                                  url: loan
                                      .esignStatus!
                                      .result!
                                      .document!
                                      .signedUrl,
                                  documentName:
                                      loan.esignStatus!.result!.document!.info,
                                  isPdf: isPdfDocument(
                                    loan
                                        .esignStatus!
                                        .result!
                                        .document!
                                        .signedUrl,
                                  ),
                                ),
                              ),
                            );
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => PdfViewScreen(
                            //       url: loan
                            //           .esignStatus!
                            //           .result!
                            //           .document!
                            //           .signedUrl,
                            //     ),
                            //   ),
                            // );
                          },
                          icon: const Icon(Icons.visibility_outlined, size: 18),
                          label: const Text('View Details'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      )
                    else if (loan.agreement?.estampId != null)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            push(
                              NamedRoutes.signAgreement,
                              arguments: EsignLoanArguments(loan: loan),
                            );
                          },
                          icon: const Icon(Icons.draw_outlined, size: 18),
                          label: const Text('Sign Agreement'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEA580C),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool fullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: fullWidth
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: fullWidth
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: fullWidth ? 13 : 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: fullWidth ? TextAlign.left : TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
        backgroundColor = AppColors.success;
        textColor = Colors.white;
        break;
      case 'pending':
        backgroundColor = AppColors.warning;
        textColor = Colors.white;
        break;
      case 'approved':
        backgroundColor = AppColors.success;
        textColor = Colors.white;
        break;
      case 'rejected':
        backgroundColor = AppColors.error;
        textColor = Colors.white;
        break;
      case 'matured':
        backgroundColor = AppColors.info;
        textColor = Colors.white;
        break;
      default:
        backgroundColor = AppColors.textLight;
        textColor = Colors.white;
    }

    return ChipBadge(
      text: status.toUpperCase(),
      color: backgroundColor,
      textColor: textColor,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Filter Applications'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type',
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  _buildFilterOption('All', 'all', _selectedFilter, (value) {
                    setState(() {
                      _selectedFilter = value;
                    });
                  }),
                  _buildFilterOption('Fixed Deposit', 'fd', _selectedFilter, (
                    value,
                  ) {
                    setState(() {
                      _selectedFilter = value;
                    });
                  }),
                  _buildFilterOption('Loan', 'loan', _selectedFilter, (value) {
                    setState(() {
                      _selectedFilter = value;
                    });
                  }),

                  const SizedBox(height: AppSizes.paddingL),
                  Text(
                    'Status',
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  _buildFilterOption('All', 'all', _selectedStatus, (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  }),
                  _buildFilterOption('Active', 'active', _selectedStatus, (
                    value,
                  ) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  }),
                  _buildFilterOption('Pending', 'pending', _selectedStatus, (
                    value,
                  ) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  }),
                  _buildFilterOption('Approved', 'approved', _selectedStatus, (
                    value,
                  ) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  }),
                  _buildFilterOption('Rejected', 'rejected', _selectedStatus, (
                    value,
                  ) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  }),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    this.setState(() {});
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildFilterOption(
    String label,
    String value,
    String groupValue,
    Function(String) onChanged,
  ) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: groupValue,
      onChanged: (String? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }
}
