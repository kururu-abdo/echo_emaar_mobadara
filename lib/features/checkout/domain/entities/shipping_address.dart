import 'package:equatable/equatable.dart';

class ShippingAddress extends Equatable {
  final int? id; // Odoo res.partner ID (null for new address)
  final String name;
  final String phone;
  final String street;
  final String? street2;
  final String? countryId;
  final String? stateId;
  final String city;
  final String? state;
  final String? zip;
  final String country;
  final bool isDefault;

  const ShippingAddress({
    this.id,
    required this.name,
    required this.phone,
    required this.street,
    this.street2,
    required this.city,
    this.state,
    this.zip,
    required this.country,
    this.isDefault = false,
    this.countryId , this.stateId
  });

  /// Provides a formatted string for the UI (e.g., "7080 King Fahd Rd, Riyadh, SA")
  String get fullAddress {
    final List<String> parts = [
      street,
      if (street2 != null && street2!.isNotEmpty) street2!,
      city,
      if (state != null && state!.isNotEmpty) state!,
      if (zip != null && zip!.isNotEmpty) zip!,
      country,
    ];
    return parts.join(', ');
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        street,
        street2,
        city,
        state,
        zip,
        country,
        isDefault,
      ];

  /// Utility for updating the entity without mutating original data
  ShippingAddress copyWith({
    int? id,
    String? name,
    String? phone,
    String? street,
    String? street2,
    String? city,
    String? state,
    String? zip,
    String? country,
    String? countryId, 
    String? stateId,
    bool? isDefault,
  }) {
    return ShippingAddress(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      street: street ?? this.street,
      street2: street2 ?? this.street2,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
      countryId: countryId?? this.countryId, 
      stateId: stateId?? this.stateId
    );
  }
}