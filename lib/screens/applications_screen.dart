import 'package:flutter/material.dart';
import 'package:janseva/modules/loan/models/loan_application_response.dart';
import 'package:janseva/modules/loan/providers/loan_provider.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/fixed_deposit.dart';
import '../models/loan_application.dart';
import '../utils/constants.dart';
import '../components/components.dart';

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
      context.read<LoanProvider>().getmmyLoanApplications();
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
      body: Consumer2<UserProvider, LoanProvider>(
        builder: (context, userProvider, loanProvider, child) {
          final user = userProvider.currentUser;
          if (user == null) {
            return const Center(
              child: Text('Please log in to view applications'),
            );
          }

          final fixedDeposits = user.fixedDeposits ?? [];
          final loanApplications = loanProvider.myLoanApplications ?? [];

          final filteredApplications = _getFilteredApplications(
            fixedDeposits,
            loanApplications,
          );

          return RefreshIndicator(
            onRefresh: () async {
              await userProvider.initializeUser();
              await loanProvider.getmmyLoanApplications();
            },
            child: filteredApplications.isEmpty
                ? const EmptyState(
                    icon: Icons.description_outlined,
                    title: 'No Applications Found',
                    subtitle: 'You have not applied for any FD or Loan yet.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSizes.paddingL),
                    itemCount: filteredApplications.length,
                    itemBuilder: (context, index) {
                      final application = filteredApplications[index];
                      if (application is FixedDeposit) {
                        return _buildFDCard(application);
                      } else if (application is LoanApplicationData) {
                        return _buildLoanCard(application);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
          );
        },
      ),
    );
  }

  List<dynamic> _getFilteredApplications(
    List<FixedDeposit> fixedDeposits,
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

  Widget _buildFDCard(FixedDeposit fd) {
    return FormSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListCard(
            leading: Container(
              padding: const EdgeInsets.all(AppSizes.paddingS),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusS),
              ),
              child: const Icon(
                Icons.account_balance,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            title: 'Fixed Deposit',
            subtitle: 'FD ID: ${fd.id}',
            trailing: _buildStatusChip(fd.status),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'Amount',
                  '₹${fd.amount.toStringAsFixed(2)}',
                ),
              ),
              Expanded(
                child: _buildInfoItem('Tenure', '${fd.tenureMonths} months'),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingS),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'Expected Profit',
                  '₹${fd.expectedProfit.toStringAsFixed(2)}',
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  'Deposit Method',
                  _getDepositMethodText(fd.depositMethod),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingS),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem('Start Date', _formatDate(fd.startDate)),
              ),
              Expanded(
                child: _buildInfoItem(
                  'Maturity Date',
                  _formatDate(fd.maturityDate),
                ),
              ),
            ],
          ),
          if (fd.depositMethod == 'cash_collection' &&
              fd.collectionDate != null) ...[
            const SizedBox(height: AppSizes.paddingS),
            _buildInfoItem('Collection Date', _formatDate(fd.collectionDate!)),
          ],
          if (fd.depositMethod == 'branch' && fd.branchName != null) ...[
            const SizedBox(height: AppSizes.paddingS),
            _buildInfoItem('Branch', fd.branchName!),
          ],
        ],
      ),
    );
  }

  Widget _buildLoanCard(LoanApplicationData loan) {
    return FormSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListCard(
            leading: Container(
              padding: const EdgeInsets.all(AppSizes.paddingS),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusS),
              ),
              child: const Icon(
                Icons.receipt_long,
                color: AppColors.secondary,
                size: 20,
              ),
            ),
            title: 'Loan Application',
            subtitle: 'Loan ID: ${loan.id}',
            trailing: _buildStatusChip(loan.approvalStatus),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'Amount',
                  '₹${loan.amount.toStringAsFixed(2)}',
                ),
              ),
              // Expanded(
              //   child: _buildInfoItem('Tenure', '${loan,} months'),
              // ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingS),

          // Row(
          //   children: [
          //     Expanded(
          //       child: _buildInfoItem(
          //         'Monthly EMI',
          //         loan.monthlyInstallment != null
          //             ? '₹${loan.monthlyInstallment!.toStringAsFixed(2)}'
          //             : 'TBD',
          //       ),
          //     ),
          //     Expanded(child: _buildInfoItem('Purpose', loan.purpose)),
          //   ],
          // ),
          // const SizedBox(height: AppSizes.paddingS),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'Applied Date',
                  _formatDate(loan.createdAt),
                ),
              ),
              // if (loan.approvalDate != null)
              //   Expanded(
              //     child: _buildInfoItem(
              //       'Approved Date',
              //       _formatDate(loan.approvalDate!),
              //     ),
              //   ),
            ],
          ),
          // if (loan.notes != null && loan.notes!.isNotEmpty) ...[
          //   const SizedBox(height: AppSizes.paddingS),
          //   _buildInfoItem('Notes', loan.notes!),
          // ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return InfoRow(label: label, value: value);
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

  String _getDepositMethodText(String method) {
    switch (method) {
      case 'online':
        return 'Online';
      case 'cash_collection':
        return 'Cash Collection';
      case 'branch':
        return 'Branch';
      default:
        return method;
    }
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
