import 'package:flutter/material.dart';

class LoanApplicationSectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const LoanApplicationSectionHeader({
    Key? key,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
