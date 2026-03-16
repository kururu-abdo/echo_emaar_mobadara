import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String defaultCode;
  final String barcode;
  final dynamic listPrice;
  final dynamic standardPrice;
  final int qtyAvailable;
  final int virturalAvaiable;
  final String  uomName;
  final String  category;
  final String imageUrl;
  final bool? active;

  const Product({
    required this.id,
    required this.name,
    required this.defaultCode,
    required this.barcode,
    this.listPrice,
    this.standardPrice,
    required this.qtyAvailable,
    required this.virturalAvaiable,
    required this.uomName,
    required this.category,
    required this.imageUrl,
    this.active,
    
  });
  
  double get effectivePrice => listPrice ?? standardPrice;
  
  bool get isOnSale => listPrice != null && listPrice! < standardPrice;
  
  double get discountPercentage {
    if (!isOnSale) return 0;
    return ((listPrice - standardPrice!) / listPrice) * 100;
  }
  
  @override
  List<Object?> get props => [
    id,
    name,
    defaultCode,
    barcode,
    listPrice,
    imageUrl,
    standardPrice,
    category,
    uomName,
    active,
    qtyAvailable,
    virturalAvaiable,
  
  ];
}