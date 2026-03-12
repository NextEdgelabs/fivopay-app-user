class Organization {
  final String id;
  final String organisationName;
  final String website;
  final String bankingMode;

  Organization({
    required this.id,
    required this.organisationName,
    required this.website,
    required this.bankingMode,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'] ?? json['_id'] ?? '',
      organisationName: json['organisationName'] ?? '',
      website: json['website'] ?? '',
      bankingMode: json['bankingMode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'organisationName': organisationName,
      'website': website,
      'bankingMode': bankingMode,
    };
  }

  Organization copyWith({
    String? id,
    String? organisationName,
    String? website,
    String? bankingMode,
  }) {
    return Organization(
      id: id ?? this.id,
      organisationName: organisationName ?? this.organisationName,
      website: website ?? this.website,
      bankingMode: bankingMode ?? this.bankingMode,
    );
  }
}
