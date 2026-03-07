import 'package:flutter/material.dart';
import 'package:janseva/modules/fd_rd/model/deposit_category_model.dart';
import 'package:janseva/modules/fd_rd/model/deposit_product_model.dart';
import 'package:janseva/utils/app_size.dart';
import 'package:janseva/utils/constants.dart';
import 'package:janseva/utils/theme_extension.dart';
import 'package:janseva/widgets/gradient_button.dart';

class CollectFromHomeScreen extends StatefulWidget {
  final DepositCategory category;
  final DepositProduct product;
  final double amount;
  final String fdName;

  const CollectFromHomeScreen({
    Key? key,
    required this.category,
    required this.product,
    required this.amount,
    required this.fdName,
  }) : super(key: key);

  @override
  State<CollectFromHomeScreen> createState() => _CollectFromHomeScreenState();
}

class _CollectFromHomeScreenState extends State<CollectFromHomeScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedTimeSlot;

  final List<String> _timeSlots = [
    '10:00 AM - 12:00 PM',
    '12:00 PM - 2:00 PM',
    '2:00 PM - 4:00 PM',
    '4:00 PM - 6:00 PM',
  ];

  @override
  void dispose() {
    _addressController.dispose();
    _landmarkController.dispose();
    _pincodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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
        title: const Text('Collect from Home'),
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
                    'Amount to Collect',
                    '₹ ${widget.amount.toStringAsFixed(0)}',
                    isHighlighted: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.dh),

            // Info Banner
            // Container(
            //   padding: EdgeInsets.all(AppSizes.paddingL.dw),
            //   decoration: BoxDecoration(
            //     color: context.colors.alert3.withOpacity(0.1),
            //     borderRadius: BorderRadius.circular(AppSizes.radiusL),
            //     border: Border.all(
            //       color: context.colors.alert3.withOpacity(0.3),
            //     ),
            //   ),
            //   child: Row(
            //     children: [
            //       Icon(
            //         Icons.info_outline,
            //         color: context.colors.alert3,
            //         size: 20.dw,
            //       ),
            //       SizedBox(width: 12.dw),
            //       Expanded(
            //         child: Text(
            //           'Our representative will visit your home to collect cash. A service charge of ₹50 will apply.',
            //           style: AppTextStyles.body2.copyWith(
            //             color: context.colors.text,
            //             fontSize: 12.dw,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 24.dh),

            // Collection Address
            Text(
              'Collection Address',
              style: AppTextStyles.heading3.copyWith(fontSize: 16.dw),
            ),
            SizedBox(height: 12.dh),
            _buildTextField(
              controller: _addressController,
              label: 'Complete Address',
              hint: 'Enter your full address',
              maxLines: 3,
            ),
            SizedBox(height: 12.dh),
            _buildTextField(
              controller: _landmarkController,
              label: 'Landmark',
              hint: 'Near...',
            ),
            SizedBox(height: 12.dh),
            _buildTextField(
              controller: _pincodeController,
              label: 'Pincode',
              hint: '400001',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12.dh),
            _buildTextField(
              controller: _phoneController,
              label: 'Contact Number',
              hint: '+91 98765 43210',
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 24.dh),

            // Preferred Date
            Text(
              'Preferred Collection Date',
              style: AppTextStyles.heading3.copyWith(fontSize: 16.dw),
            ),
            SizedBox(height: 12.dh),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now().add(const Duration(days: 1)),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(AppSizes.paddingL.dw),
                decoration: BoxDecoration(
                  color: context.colors.bgColors,
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(color: context.colors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate != null
                          ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                          : 'Select Date',
                      style: AppTextStyles.body1.copyWith(
                        color: _selectedDate != null
                            ? context.colors.text
                            : context.colors.textSecondary,
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: context.colors.brandColor,
                      size: 20.dw,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.dh),

            // Preferred Time Slot
            Text(
              'Preferred Time Slot',
              style: AppTextStyles.heading3.copyWith(fontSize: 16.dw),
            ),
            SizedBox(height: 12.dh),
            ...List.generate(_timeSlots.length, (index) {
              final slot = _timeSlots[index];
              final isSelected = _selectedTimeSlot == slot;
              return Padding(
                padding: EdgeInsets.only(bottom: 8.dh),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedTimeSlot = slot;
                    });
                  },
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  child: Container(
                    padding: EdgeInsets.all(AppSizes.paddingL.dw),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.colors.brandColor.withOpacity(0.1)
                          : context.colors.bgColors,
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      border: Border.all(
                        color: isSelected
                            ? context.colors.brandColor
                            : context.colors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: isSelected
                                  ? context.colors.brandColor
                                  : context.colors.textSecondary,
                              size: 20.dw,
                            ),
                            SizedBox(width: 12.dw),
                            Text(
                              slot,
                              style: AppTextStyles.body1.copyWith(
                                color: isSelected
                                    ? context.colors.brandColor
                                    : context.colors.text,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: context.colors.brandColor,
                            size: 20.dw,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.paddingL.dw),
          child: GradientButton(
            onTap: _isFormValid()
                ? () {
                    // TODO: Schedule home collection
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Home collection scheduled successfully!',
                        ),
                      ),
                    );
                  }
                : null,
            text: 'Schedule Collection',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body2.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(height: 8.dh),
        Container(
          decoration: BoxDecoration(
            color: context.colors.bgColors,
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            border: Border.all(color: context.colors.border),
          ),
          padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingM.dw),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.body2.copyWith(
                color: context.colors.textSecondary,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              contentPadding: EdgeInsets.symmetric(vertical: 14.dh),
            ),
            onChanged: (value) {
              setState(() {}); // Update button state
            },
          ),
        ),
      ],
    );
  }

  bool _isFormValid() {
    return _addressController.text.isNotEmpty &&
        _pincodeController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTimeSlot != null;
  }
}
