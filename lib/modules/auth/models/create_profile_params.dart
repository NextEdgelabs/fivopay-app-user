class CreateProfileParams {
  final String name;
  final String email;
  final String phone;
  final String? branchId; // Adding optional branchId

  CreateProfileParams({
    required this.name,
    required this.email,
    required this.phone,
    this.branchId, // Optional branchId
  });
  Map<String, dynamic> toJson() {
    return {
      'fullName': name,
      'email': email,
      'phone': phone,
      if (branchId != null) 'branchId': branchId, // Include branchId if not null
    };
  }
}
