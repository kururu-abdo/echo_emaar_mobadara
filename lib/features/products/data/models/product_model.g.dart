// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      defaultCode: json['default_code'] as String,
      barcode: json['barcode'] as String,
      standardPrice: json['standard_price'],
      listPrice: json['list_price'],
      imageUrl: json['image'] as String,
      category: json['category_name'] as String,
      uomName: json['uom_name'] as String,
      qtyAvailable: (json['qty_available'] as num).toInt(),
      virturalAvaiable: (json['virtural_avaiable'] as num).toInt(),
      active: json['active'] as bool?,
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'default_code': instance.defaultCode,
      'barcode': instance.barcode,
      'list+price': instance.listPrice,
      'standard_price': instance.standardPrice,
      'qty_available': instance.qtyAvailable,
      'virtural_avaiable': instance.virturalAvaiable,
      'uom_name': instance.uomName,
      'category_name': instance.category,
      'image': instance.imageUrl,
      'active': instance.active,
    };
