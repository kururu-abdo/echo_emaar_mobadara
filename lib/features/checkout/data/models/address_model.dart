import 'dart:developer';

import 'package:echoemaar_commerce/features/checkout/domain/entities/shipping_address.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';

@JsonSerializable()
class ShippingAddressModel extends ShippingAddress {
  const ShippingAddressModel({
    super.id,
    required super.name,
    required super.countryId, 
    required super.stateId,
    required super.phone,
    required super.street,
    super.street2,
    required super.city,
    super.state,
    super.zip,
    required super.country,
    super.isDefault,
  });

  // Standard JSON mapping (e.g., for local storage/Hive)
  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) => 
      _$ShippingAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressModelToJson(this);

  // --- Odoo Specific Mapping ---
  
  /// Maps Odoo's 'res.partner' structure to our Model
  factory ShippingAddressModel.fromOdoo(Map<String, dynamic> json) {
    log('DATA HERE $json');
    return ShippingAddressModel(
      id: json['id'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      street: json['street'] ?? '',
      street2: json['street2'],
      city: json['city'] ?? '',
      countryId: json['country_id'],
      stateId: json['state_id'],
      // Odoo states and countries are often returned as [id, "Name"]
      state: json['state'] ,
      zip: json['zip'],
      country: json['country']  ?? 'Saudi Arabia',
      isDefault: json['is_default_address'] ?? false,
    );
  }
/// Converts a clean Domain Entity into a Data Model
  factory ShippingAddressModel.fromEntity(ShippingAddress entity) {
    return ShippingAddressModel(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
      street: entity.street,
      street2: entity.street2,
      city: entity.city,
      state: entity.state,
      zip: entity.zip,
      country: entity.country,
      isDefault: entity.isDefault,
      countryId: entity.countryId, 
      stateId: entity.stateId
    );
  }
  /// Converts our model to the format Odoo expects for 'create' or 'write' calls
  Map<String, dynamic> toOdoo() {
    return {
      'name': name,
      'phone': phone,
      'street': street,
      'street2': street2 ?? '',
      'city': city,
      'zip': zip ?? '',
      // Note: Odoo usually expects the ID (integer) for these fields
      // You might need to pass the ID if you have it, or leave it for Odoo to resolve
      'country_id': 192, // Example: Saudi Arabia ID
      'type': 'delivery', // Standard Odoo address type
      
    };
  }


ShippingAddress toEntity() {
  log(id.toString());
    return ShippingAddress(
      id: id,
      name: name,
      phone: phone,
      street: street,
      street2: street2,
      city: city,
      state: state,
      stateId: stateId,
      countryId: countryId,
      zip: zip,
      country: country,
      isDefault: isDefault,
    );
  }

}