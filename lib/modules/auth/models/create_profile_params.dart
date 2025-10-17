class CreateProfileParams {
  final String name;
  final String email;
  final String phone;

  CreateProfileParams({
    required this.name,
    required this.email,
    required this.phone,
  });
  Map<String, dynamic> toJson() {
    return {'fullName': name, 'email': email, 'phone': phone};
  }
}
