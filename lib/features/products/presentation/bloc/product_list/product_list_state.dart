part of 'product_list_bloc.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();
  
  @override
  List<Object?> get props => [];
}


class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListInitial {}

class ProductListLoaded extends ProductListInitial {
  final List<Product> products;
  
   ProductListLoaded(this.products);
  
  @override
  List<Object> get props => [products];
}
class ProductListError extends ProductListState {
  final String message;
  
  const  ProductListError(this.message);
  
  @override
  List<Object> get props => [message];
}