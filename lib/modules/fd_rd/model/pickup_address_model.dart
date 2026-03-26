// Pickup Address Model
class PickupAddress {
  final String addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String pincode;
  final String? landmark;
  final List<double>? location; // [longitude, latitude] for GPS coordinates

  PickupAddress({
    required this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    required this.pincode,
    this.landmark,
    this.location,
  });

  // From JSON
  factory PickupAddress.fromJson(Map<String, dynamic> json) {
    return PickupAddress(
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'],
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      landmark: json['landmark'],
      location: json['location'] != null
          ? List<double>.from(json['location'].map((x) => x.toDouble()))
          : null,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'addressLine1': addressLine1,
      'city': city,
      'state': state,
      'pincode': pincode,
    };

    if (addressLine2 != null) {
      data['addressLine2'] = addressLine2;
    }

    if (landmark != null) {
      data['landmark'] = landmark;
    }

    if (location != null) {
      data['location'] = location;
    }

    return data;
  }

  // Copy with method for immutability
  PickupAddress copyWith({
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? pincode,
    String? landmark,
    List<double>? location,
  }) {
    return PickupAddress(
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      landmark: landmark ?? this.landmark,
      location: location ?? this.location,
    );
  }

  // Get full address as string
  String get fullAddress {
    final List<String> parts = [addressLine1];

    if (addressLine2 != null && addressLine2!.isNotEmpty) {
      parts.add(addressLine2!);
    }

    if (landmark != null && landmark!.isNotEmpty) {
      parts.add('Near $landmark');
    }

    if (city != null && city!.isNotEmpty) {
      parts.add(city!);
    }
    if (state != null && state!.isNotEmpty) {
      parts.add(state!);
    }
    parts.add(pincode);

    return parts.join(', ');
  }

  // Get coordinates if available
  double? get longitude =>
      location != null && location!.isNotEmpty ? location![0] : null;
  double? get latitude =>
      location != null && location!.length > 1 ? location![1] : null;

  @override
  String toString() {
    return 'PickupAddress(addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, state: $state, pincode: $pincode, landmark: $landmark, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PickupAddress &&
        other.addressLine1 == addressLine1 &&
        other.addressLine2 == addressLine2 &&
        other.city == city &&
        other.state == state &&
        other.pincode == pincode &&
        other.landmark == landmark &&
        _listEquals(other.location, location);
  }

  @override
  int get hashCode {
    return addressLine1.hashCode ^
        addressLine2.hashCode ^
        city.hashCode ^
        state.hashCode ^
        pincode.hashCode ^
        landmark.hashCode ^
        location.hashCode;
  }

  // Helper method for list equality
  bool _listEquals(List<double>? a, List<double>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
