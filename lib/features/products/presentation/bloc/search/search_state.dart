part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchHistoryLoaded extends SearchState {
  final List<String> history;

  const SearchHistoryLoaded(this.history);

  @override
  List<Object> get props => [history];
}

class SearchLoading extends SearchState {
  final String query;

  const SearchLoading({required this.query});

  @override
  List<Object> get props => [query];
}

class SearchLoaded extends SearchState {
  final String query;
  final List<Product> products;
  final String? colorFilter;
  final double? minPrice;
  final double? maxPrice;
  final int? categoryId;

  const SearchLoaded({
    required this.query,
    required this.products,
    this.colorFilter,
    this.minPrice,
    this.maxPrice,
    this.categoryId,
  });

  bool get hasFilters =>
      colorFilter != null ||
      minPrice != null ||
      maxPrice != null ||
      categoryId != null;

  int get activeFiltersCount {
    int count = 0;
    if (colorFilter != null) count++;
    if (minPrice != null || maxPrice != null) count++;
    if (categoryId != null) count++;
    return count;
  }

  @override
  List<Object?> get props => [
        query,
        products,
        colorFilter,
        minPrice,
        maxPrice,
        categoryId,
      ];

  SearchLoaded copyWith({
    String? query,
    List<Product>? products,
    String? colorFilter,
    double? minPrice,
    double? maxPrice,
    int? categoryId,
  }) {
    return SearchLoaded(
      query: query ?? this.query,
      products: products ?? this.products,
      colorFilter: colorFilter,
      minPrice: minPrice,
      maxPrice: maxPrice,
      categoryId: categoryId,
    );
  }
}

class SearchError extends SearchState {
  final String message;
  final String query;

  const SearchError(this.message, {required this.query});

  @override
  List<Object> get props => [message, query];
}