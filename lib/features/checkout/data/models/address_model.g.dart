// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingAddressModel _$ShippingAddressModelFromJson(
        Map<String, dynamic> json) =>
    ShippingAddressModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      countryId: json['countryId'] as String?,
      stateId: json['stateId'] as String?,
      phone: json['phone'] as String,
      street: json['street'] as String,
      street2: json['street2'] as String?,
      city: json['city'] as String,
      state: json['state'] as String?,
      zip: json['zip'] as String?,
      country: json['country']??''
,      isDefault: json['isDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$ShippingAddressModelToJson(
        ShippingAddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'street': instance.street,
      'street2': instance.street2,
      'countryId': instance.countryId,
      'stateId': instance.stateId,
      'city': instance.city,
      'state': instance.state,
      'zip': instance.zip,
      'country': instance.country,
      'isDefault': instance.isDefault,
    };
