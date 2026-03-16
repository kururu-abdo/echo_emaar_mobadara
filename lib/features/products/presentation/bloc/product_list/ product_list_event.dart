part of 'product_list_bloc.dart';

abstract class  ProductListEvent extends Equatable {
  const ProductListEvent();
  
  @override
  List<Object?> get props => [];
}


class LoadProductsEvent extends ProductListEvent {
  final BuildContext context;
 
  
  const LoadProductsEvent({
     required this.context,
   
  });
  
  @override
  List<Object> get props => [context, ];
}
class LoadMostSoldProductsEvent extends ProductListEvent {
  final BuildContext context;
 
  
  const LoadMostSoldProductsEvent({
     required this.context,
   
  });
  
  @override
  List<Object> get props => [context, ];
}