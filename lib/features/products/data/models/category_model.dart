


import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category.dart';

part 'category_model.g.dart';
@JsonSerializable()
class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
      required super.imageUrl,

  });
  
  factory CategoryModel.fromJson(Map<String, dynamic> json) => 
      _$CategoryModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
  
  factory CategoryModel.fromOdoo(Map<String, dynamic> odooData) {
    return CategoryModel(
      id: odooData['id'] as int,
      name: odooData['name'] as String,
      imageUrl: odooData['image_url'] as String?,
    
    );
  }
}

