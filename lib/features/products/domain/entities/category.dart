import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  // final String? description;
  final String? imageUrl;
  // final int? parentId;
  // final int productCount;
  
  const Category({
    required this.id,
    required this.name,
    // this.description,
    this.imageUrl,
    // this.parentId,
    // required this.productCount,
  });
  
  @override
  List<Object?> get props => [
    id,
    name,
    // description,
    imageUrl,
    // parentId,
    // productCount,
  ];
}