import 'loan_category.dart';
import 'pagination.dart';

class LoanCategoriesResponse {
  final bool success;
  final LoanCategoriesResult result;

  LoanCategoriesResponse({required this.success, required this.result});

  factory LoanCategoriesResponse.fromJson(Map<String, dynamic> json) {
    return LoanCategoriesResponse(
      success: json['success'] ?? false,
      result: LoanCategoriesResult.fromJson(json['result'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'result': result.toJson()};
  }
}

class LoanCategoriesResult {
  final List<LoanCategory> loanCategories;
  final Pagination pagination;

  LoanCategoriesResult({
    required this.loanCategories,
    required this.pagination,
  });

  factory LoanCategoriesResult.fromJson(Map<String, dynamic> json) {
    return LoanCategoriesResult(
      loanCategories:
          (json['loanCategories'] as List<dynamic>?)
              ?.map(
                (item) => LoanCategory.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loanCategories': loanCategories
          .map((category) => category.toJson())
          .toList(),
      'pagination': pagination.toJson(),
    };
  }

  // Helper methods
  List<LoanCategory> getLoanCategoriesByType(String loanType) {
    return loanCategories
        .where((category) => category.loanType == loanType)
        .toList();
  }

  List<String> get availableLoanTypes {
    return loanCategories.map((category) => category.loanType).toSet().toList();
  }

  List<LoanCategory> get activeLoanCategories {
    return loanCategories
        .where((category) => category.status == 'active')
        .toList();
  }
}
