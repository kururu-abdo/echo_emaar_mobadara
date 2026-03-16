
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/get_product_details.dart';
import 'package:echoemaar_commerce/features/products/domain/entities/product.dart';


part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc
    extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductDetails getProductDetails;
  // final GetRelatedProducts getRelatedProducts;
  // final GetProductVariants getProductVariants;

  ProductDetailBloc({
    required this.getProductDetails,
    // required this.getRelatedProducts,
    // required this.getProductVariants,
  }) : super(ProductDetailInitial()) {
    on<LoadProductDetailEvent>(_onLoad);
    // on<LoadRelatedProductsEvent>(_onLoadRelated);
    // on<LoadProductVariantsEvent>(_onLoadVariants);
    // on<SelectVariantEvent>(_onSelectVariant);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
  }

  // ── Handlers ────────────────────────────────────────────────────

  Future<void> _onLoad(
    LoadProductDetailEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(ProductDetailLoading());

    final result =
        await getProductDetails(GetProductDetailsParams(event.productId));

    result.fold(
      (failure) => emit(ProductDetailError(failure.message)),
      (product) {
        emit(ProductDetailLoaded(product: product));
        // kick off secondary loads
        add(LoadRelatedProductsEvent(event.productId));
        add(LoadProductVariantsEvent(event.productId));
      },
    );
  }

  /*

  Future<void> _onLoadRelated(
    LoadRelatedProductsEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    final current = state;
    if (current is! ProductDetailLoaded) return;

    final result =
        await getRelatedProducts(GetRelatedProductsParams(event.productId));

    result.fold(
      (_) {},
      (related) => emit(current.copyWith(relatedProducts: related)),
    );
  }


  Future<void> _onLoadVariants(
    LoadProductVariantsEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    final current = state;
    if (current is! ProductDetailLoaded) return;

    final result =
        await getProductVariants(GetProductVariantsParams(event.productId));

    result.fold(
      (_) {},
      (variants) => emit(current.copyWith(
        variants: variants,
        selectedVariant: variants.isNotEmpty ? variants.first : null,
      )),
    );
  }

  void _onSelectVariant(
    SelectVariantEvent event,
    Emitter<ProductDetailState> emit,
  ) {
    final current = state;
    if (current is! ProductDetailLoaded) return;
    emit(current.copyWith(selectedVariant: event.variant));
  }
*/
  void _onUpdateQuantity(
    UpdateQuantityEvent event,
    Emitter<ProductDetailState> emit,
  ) {
    final current = state;
    if (current is! ProductDetailLoaded) return;
    if (event.quantity < 1) return;
    // final maxStock = current.selectedVariant?.stock ?? current.product.stock;
    // if (event.quantity > 0) return;
    emit(current.copyWith(quantity: event.quantity));
  }
}

// // ─────────────────────────────────────────────────────────────────
// // FILE: features/products/presentation/bloc/favorites/favorites_state.dart
// // ─────────────────────────────────────────────────────────────────

// part of 'favorites_cubit.dart';

// class FavoritesState extends Equatable {
//   final Set<int> ids;

//   const FavoritesState(this.ids);

//   bool isFavorite(int productId) => ids.contains(productId);

//   @override
//   List<Object> get props => [ids];
// }

// // ─────────────────────────────────────────────────────────────────
// // FILE: features/products/presentation/bloc/favorites/favorites_cubit.dart
// // ─────────────────────────────────────────────────────────────────

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// part 'favorites_state.dart';

// class FavoritesCubit extends Cubit<FavoritesState> {
//   static const _kKey = 'favorite_ids';
//   final SharedPreferences _prefs;

//   FavoritesCubit(this._prefs)
//       : super(FavoritesState(_load(_prefs)));

//   static Set<int> _load(SharedPreferences p) =>
//       (p.getStringList(_kKey) ?? []).map(int.parse).toSet();

//   bool isFavorite(int id) => state.isFavorite(id);

//   Future<void> toggle(int productId) async {
//     final updated = Set<int>.from(state.ids);
//     updated.contains(productId)
//         ? updated.remove(productId)
//         : updated.add(productId);

//     await _prefs
//         .setStringList(_kKey, updated.map((e) => e.toString()).toList());
//     emit(FavoritesState(updated));
//   }
// }


