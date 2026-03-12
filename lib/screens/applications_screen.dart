import 'package:flutter/material.dart';
import 'package:janseva/modules/fd_rd/deposit_provider.dart';
import 'package:janseva/modules/loan/models/loan_application_response.dart';
import 'package:janseva/modules/loan/providers/loan_provider.dart';
import 'package:janseva/modules/loan/screens/esign/view_pdf.dart';
import 'package:janseva/routes/arguments.dart';
import 'package:janseva/routes/navigator.dart';
import 'package:janseva/routes/routes.dart';
import 'package:janseva/utils/app_color_extension.dart';
import 'package:janseva/utils/theme_extension.dart';
import 'package:provider/provider.dart';
import '../modules/auth/provider/auth_provider.dart';
import '../modules/fd_rd/model/term_deposit_model.dart';
import '../providers/user_provider.dart';
import '../models/fixed_deposit.dart';
import '../services/common_utils.dart';
import '../utils/constants.dart';
import '../components/components.dart';
import '../utils/app_color_extension.dart';
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
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            color: context.colors.specialCard,
            border: Border.all(color: context.colors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: context.colors.shadowWithOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with professional design
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                decoration: BoxDecoration(
                  color: context.colors.specialCardTwo,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.radiusM),
                    topRight: Radius.circular(AppSizes.radiusM),
                  ),
                  border: Border(
                    bottom: BorderSide(color: context.colors.border, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingS),
                      decoration: BoxDecoration(
                        color: context.colors.brandColor,
                        borderRadius: BorderRadius.circular(AppSizes.radiusS),
                      ),
                      child: Icon(
                        Icons.account_balance,
                        color: context.colors.buttonLabelText,
                        size: AppSizes.iconSizeS,
                      ),
                    ),
                    const SizedBox(width: AppSizes.paddingS),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fixed Deposit',
                            style: AppTextStyles.heading3.copyWith(
                              color: context.colors.heading,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Account: ${fd.accountNumber ?? fd.depositId ?? 'N/A'}',
                            style: AppTextStyles.caption.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(fd.status, context),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                child: Column(
                  children: [
                    // Amount highlight
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                      decoration: BoxDecoration(
                        color: context.colors.selectedField,
                        borderRadius: BorderRadius.circular(AppSizes.radiusS),
                        border: Border.all(
                          color: context.colors.fieldBorder,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Deposit Amount',
                            style: AppTextStyles.body2.copyWith(
                              fontWeight: FontWeight.w500,
                              color: context.colors.textSecondary,
                            ),
                          ),
                          Text(
                            '₹${(fd.depositAmount ?? 0).toStringAsFixed(2)}',
                            style: AppTextStyles.heading2.copyWith(
                              color: context.colors.brandColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSizes.paddingM),

                    // Grid of info
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.calendar_today_outlined,
                            label: 'Tenure',
                            value:
                                '${fd.productId?.lockInPeriodMonths ?? 0} months',
                          ),
                        ),
                        const SizedBox(width: AppSizes.paddingS),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.calendar_month_outlined,
                            label: 'Opened On',
                            value: _formatDate(fd.createdAt!).trim(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSizes.paddingS),

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
                          ),
                        ),
                        const SizedBox(width: AppSizes.paddingS),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.account_balance_wallet_outlined,
                            label: 'Current Balance',
                            value:
                                '₹${(fd.currentBalance ?? 0).toStringAsFixed(0)}',
                          ),
                        ),
                      ],
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
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            color: context.colors.specialCard,
            border: Border.all(color: context.colors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: context.colors.shadowWithOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with professional design
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                decoration: BoxDecoration(
                  color: context.colors.specialCardTwo,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.radiusM),
                    topRight: Radius.circular(AppSizes.radiusM),
                  ),
                  border: Border(
                    bottom: BorderSide(color: context.colors.border, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingS),
                      decoration: BoxDecoration(
                        gradient: context.colors.brandLinearGradient,
                        borderRadius: BorderRadius.circular(AppSizes.radiusS),
                      ),
                      child: Icon(
                        Icons.receipt_long,
                        color: context.colors.buttonLabelText,
                        size: AppSizes.iconSizeS,
                      ),
                    ),
                    const SizedBox(width: AppSizes.paddingS),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Loan Application',
                            style: AppTextStyles.heading3.copyWith(
                              color: context.colors.heading,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'ID: ${loan.id}',
                            style: AppTextStyles.caption.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(loan.approvalStatus, context),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                child: Column(
                  children: [
                    // Amount highlight
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                      decoration: BoxDecoration(
                        color: context.colors.selectedField,
                        borderRadius: BorderRadius.circular(AppSizes.radiusS),
                        border: Border.all(
                          color: context.colors.fieldBorder,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Loan Amount',
                            style: AppTextStyles.body2.copyWith(
                              fontWeight: FontWeight.w500,
                              color: context.colors.textSecondary,
                            ),
                          ),
                          Text(
                            '₹${loan.amount.toStringAsFixed(2)}',
                            style: AppTextStyles.heading2.copyWith(
                              color: context.colors.brandColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSizes.paddingM),

                    // Grid of info
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.calendar_today_outlined,
                            label: 'Applied Date',
                            value: _formatDate(loan.createdAt),
                          ),
                        ),
                        const SizedBox(width: AppSizes.paddingS),
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
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSizes.paddingM),

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
                          },
                          icon: Icon(
                            Icons.visibility_outlined,
                            size: AppSizes.iconSizeS,
                          ),
                          label: const Text('View Details'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.brandColor,
                            foregroundColor: context.colors.buttonLabelText,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSizes.paddingM,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusS,
                              ),
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
                          icon: Icon(
                            Icons.draw_outlined,
                            size: AppSizes.iconSizeS,
                          ),
                          label: const Text('Sign Agreement'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.alert3,
                            foregroundColor: context.colors.buttonLabelText,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSizes.paddingM,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusS,
                              ),
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
    bool fullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingS),
      decoration: BoxDecoration(
        color: context.appColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: context.appColors.border, width: 1),
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
              Icon(
                icon,
                size: AppSizes.iconSizeS,
                color: context.appColors.textSecondary,
              ),
              const SizedBox(width: AppSizes.paddingXS),
              Flexible(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: context.appColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingXS),
          Text(
            value,
            style: AppTextStyles.body2.copyWith(
              fontWeight: FontWeight.w600,
              color: context.appColors.text,
            ),
            textAlign: fullWidth ? TextAlign.left : TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
      case 'approved':
      case 'success':
        backgroundColor = context.appColors.alert1.withOpacity(0.1);
        textColor = context.appColors.alert1;
        break;
      case 'pending':
        backgroundColor = context.appColors.alert3.withOpacity(0.1);
        textColor = context.appColors.alert3;
        break;
      case 'rejected':
      case 'failed':
        backgroundColor = context.appColors.alert2.withOpacity(0.1);
        textColor = context.appColors.alert2;
        break;
      case 'matured':
      case 'info':
        backgroundColor = context.appColors.alert4.withOpacity(0.1);
        textColor = context.appColors.alert4;
        break;
      default:
        backgroundColor = context.appColors.disabled;
        textColor = context.appColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingS,
        vertical: AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
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
