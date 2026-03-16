part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

class SearchSubmitted extends SearchEvent {
  final String query;

  const SearchSubmitted(this.query);

  @override
  List<Object> get props => [query];
}

class LoadSearchHistory extends SearchEvent {}

class RemoveFromHistory extends SearchEvent {
  final String query;

  const RemoveFromHistory(this.query);

  @override
  List<Object> get props => [query];
}

class ClearSearchHistory extends SearchEvent {}

class ApplyFilters extends SearchEvent {
  final String? colorFilter;
  final double? minPrice;
  final double? maxPrice;
  final int? categoryId;

  const ApplyFilters({
    this.colorFilter,
    this.minPrice,
    this.maxPrice,
    this.categoryId,
  });

  @override
  List<Object?> get props => [colorFilter, minPrice, maxPrice, categoryId];
}

class ClearFilters extends SearchEvent {}
