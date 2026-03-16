
import 'package:equatable/equatable.dart';

class FavoritesState extends Equatable {
  final Set<int> ids;

  const FavoritesState(this.ids);

  bool isFavorite(int productId) => ids.contains(productId);

  @override
  List<Object> get props => [ids];
}
