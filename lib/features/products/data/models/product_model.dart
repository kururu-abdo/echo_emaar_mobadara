import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product.dart';
part 'product_model.g.dart';

@JsonSerializable()
class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.defaultCode,
    required super.barcode,
    super.standardPrice,
    super.listPrice,
    required super.imageUrl,
    required super.category,
    required super.uomName,
    required super.qtyAvailable,
    required super.virturalAvaiable,
    super.active,
  
  });
  
  factory ProductModel.fromJson(Map<String, dynamic> json) => 
      _$ProductModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
  
  factory ProductModel.fromOdoo(Map<String, dynamic> odooData) {
    // Extract images from Odoo product
    // List<String> images = [];
    // if (odooData['product_image_ids'] != null) {
    //   images = (odooData['product_image_ids'] as List)
    //       .map((img) => 'https://your-odoo.com/web/image/${img['id']}')
    //       .toList()
    //       .cast<String>();
    // }
    
    // // Main image
    // String? mainImage = odooData['image_1920'] != null
    //     ? 'https://your-odoo.com/web/image?model=product.product&id=${odooData['id']}&field=image_1920'
    //     : null;
    
    // if (mainImage != null && !images.contains(mainImage)) {
    //   images.insert(0, mainImage);
    // }
  print('PRODUCT DATA ====> $odooData \n \n');
    return ProductModel(
      id: odooData['id'] as int,
      name: odooData['name'] as String,
      defaultCode: odooData['default_code'] as String? ?? '',
      listPrice: (odooData['list_price'] as num?)?.toDouble() ?? 0.0,
      standardPrice: odooData['standard_price'] != null 
          ? (odooData['standard_price'] as num).toDouble() 
          : null,
      imageUrl: odooData['image']??'',
    
      category: odooData['category_name'] is String 
          ? odooData['category_name'] as String 
          : odooData['category_name'] as String? ?? '',
      uomName: odooData['uom_name'],
      qtyAvailable: (odooData['qty_available'] as num?)?.toInt() ?? 0,
      virturalAvaiable: (odooData['virtual_available'] as num?)?.toInt() ?? 0, 
      barcode: odooData['barcode'] ,
     
    );
  }
  
  Map<String, dynamic> toOdoo() {
    return {
      'name': name,
      'default_code': defaultCode,
      'list_price': listPrice,
      'category': category,
      'uom_name': uomName,
      'qty_available': qtyAvailable,
      'virtual_available': virturalAvaiable,
      'barcode': barcode,
      'image': imageUrl,
      'standard_price': standardPrice,
      'active': active,
    };
  }
}