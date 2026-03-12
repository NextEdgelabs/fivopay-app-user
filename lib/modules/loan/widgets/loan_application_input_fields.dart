import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../../../utils/app_color_extension.dart';

class LoanApplicationInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? prefix;
  final String? suffix;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Color focusColor;

  const LoanApplicationInputField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
    required this.focusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body2.copyWith(
            fontWeight: FontWeight.w600,
            color: context.appColors.heading,
          ),
        ),
        const SizedBox(height: AppSizes.paddingS),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          onChanged: onChanged,
          style: AppTextStyles.body1.copyWith(color: context.appColors.text),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.body1.copyWith(
              color: context.appColors.textSecondary,
            ),
            prefixText: prefix,
            suffixText: suffix,
            filled: true,
            fillColor: context.appColors.selectedField.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingM,
              vertical: AppSizes.paddingM,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
              borderSide: BorderSide(
                color: context.appColors.fieldBorder.withOpacity(0.5),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
              borderSide: BorderSide(color: context.appColors.fieldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
              borderSide: BorderSide(color: focusColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
              borderSide: BorderSide(color: context.appColors.alert2),
            ),
          ),
        ),
      ],
    );
  }
}

class LoanApplicationDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final void Function(String?) onChanged;
  final Color focusColor;

  const LoanApplicationDropdownField({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.focusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body2.copyWith(
            fontWeight: FontWeight.w600,
            color: context.appColors.heading,
          ),
        ),
        const SizedBox(height: AppSizes.paddingS),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          style: AppTextStyles.body1.copyWith(color: context.appColors.text),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: context.appColors.textSecondary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: context.appColors.selectedField.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingM,
              vertical: AppSizes.paddingM,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
              borderSide: BorderSide(
                color: context.appColors.fieldBorder.withOpacity(0.5),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
              borderSide: BorderSide(color: context.appColors.fieldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
              borderSide: BorderSide(color: focusColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
              borderSide: BorderSide(color: context.appColors.alert2),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
        ),
      ],
    );
  }
}
