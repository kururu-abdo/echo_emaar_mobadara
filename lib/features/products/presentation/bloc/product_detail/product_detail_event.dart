
part of 'product_detail_bloc.dart';


abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductDetailEvent extends ProductDetailEvent {
  final int productId;

  const LoadProductDetailEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class LoadRelatedProductsEvent extends ProductDetailEvent {
  final int productId;

  const LoadRelatedProductsEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class LoadProductVariantsEvent extends ProductDetailEvent {
  final int productId;

  const LoadProductVariantsEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

// class SelectVariantEvent extends ProductDetailEvent {
//   final ProductVariant variant;

//   const SelectVariantEvent(this.variant);

//   @override
//   List<Object> get props => [variant];
// }

class UpdateQuantityEvent extends ProductDetailEvent {
  final int quantity;

  const UpdateQuantityEvent(this.quantity);

  @override
  List<Object> get props => [quantity];
}


