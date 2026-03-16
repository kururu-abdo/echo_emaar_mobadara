
part of 'category_bloc.dart';




abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryStateInitial extends CategoryState {}

class CategoryStateLoading extends CategoryState {}

class CategoryStateLoaded extends CategoryState {
  final List<Category> categories;
  // final List<ProductVariant> variants;
  // final ProductVariant? selectedVariant;

  const CategoryStateLoaded({
    this.categories = const [],
    // this.variants = const [],
    // this.selectedVariant,
  });



  @override
  List<Object?> get props =>
      [categories];

  CategoryStateLoaded copyWith({
    
    List<Category>? categories,
    // List<ProductVariant>? variants,
    // ProductVariant? selectedVariant,
    int? quantity,
  }) {
    return CategoryStateLoaded(
      categories: categories ?? this.categories,
   
    );
  }
}

class CategoryStateError extends CategoryState {
  final String message;

  const CategoryStateError(this.message);

  @override
  List<Object> get props => [message];
}

