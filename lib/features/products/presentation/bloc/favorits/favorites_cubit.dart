import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'favorite_state.dart';


class FavoritesCubit extends Cubit<FavoritesState> {
  static const _kKey = 'favorite_ids';
  final SharedPreferences _prefs;

  FavoritesCubit(this._prefs)
      : super(FavoritesState(_load(_prefs)));

  static Set<int> _load(SharedPreferences p) =>
      (p.getStringList(_kKey) ?? []).map(int.parse).toSet();

  bool isFavorite(int id) => state.isFavorite(id);

  Future<void> toggle(int productId) async {
    final updated = Set<int>.from(state.ids);
    updated.contains(productId)
        ? updated.remove(productId)
        : updated.add(productId);

    await _prefs
        .setStringList(_kKey, updated.map((e) => e.toString()).toList());
    emit(FavoritesState(updated));
  }
}