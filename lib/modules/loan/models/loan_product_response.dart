import 'package:janseva/modules/loan/models/models.dart';

class LoanProductResponse {
  final bool success;
  final List<LoanProduct> loanproducts;
  final String? cateegoryId;
  final Pagination? pagination;
  LoanProductResponse({
    required this.success,
    required this.loanproducts,
    this.pagination,
    this.cateegoryId,
  });

  factory LoanProductResponse.fromJson(Map<String, dynamic> json) {
    return LoanProductResponse(
      success: json['success'] ?? false,
      cateegoryId: json['result']['category'] != null
          ? json['result']['category']['_id']
          : "",
      loanproducts:
          (json['result']['loanProducts'] as List<dynamic>?)
              ?.map(
                (item) => LoanProduct.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      pagination: json['result']['pagination'] != null
          ? Pagination.fromJson(json['result']['pagination'])
          : null,
    );
  }
}
