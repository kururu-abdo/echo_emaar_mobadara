
part of 'product_detail_bloc.dart';



abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final Product product;
  final List<Product> relatedProducts;
  // final List<ProductVariant> variants;
  // final ProductVariant? selectedVariant;
  final int quantity;

  const ProductDetailLoaded({
    required this.product,
    this.relatedProducts = const [],
    // this.variants = const [],
    // this.selectedVariant,
    this.quantity = 1,
  });

  double get effectivePrice {
    final base = product.effectivePrice;
    // final extra = selectedVariant?.priceExtra ?? 0;
    return base + 0;
  }

  @override
  List<Object?> get props =>
      [product, relatedProducts, 
      
      // variants, selectedVariant,
      
       quantity];

  ProductDetailLoaded copyWith({
    Product? product,
    List<Product>? relatedProducts,
    // List<ProductVariant>? variants,
    // ProductVariant? selectedVariant,
    int? quantity,
  }) {
    return ProductDetailLoaded(
      product: product ?? this.product,
      relatedProducts: relatedProducts ?? this.relatedProducts,
      // variants: variants ?? this.variants,
      // selectedVariant: selectedVariant ?? this.selectedVariant,
      quantity: quantity ?? this.quantity,
    );
  }
}

class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError(this.message);

  @override
  List<Object> get props => [message];
}



