import 'dart:async';
import 'dart:developer';
import 'package:echoemaar_commerce/features/cart/data/models/cart_model.dart';
import 'package:echoemaar_commerce/features/cart/domain/usecases/add_to_cart.dart';
import 'package:echoemaar_commerce/features/cart/domain/usecases/clear_cart.dart';
import 'package:echoemaar_commerce/features/cart/domain/usecases/get_cart.dart';
import 'package:echoemaar_commerce/features/cart/domain/usecases/remove_cart_item.dart';
import 'package:echoemaar_commerce/features/cart/domain/usecases/sync_cart.dart';
import 'package:echoemaar_commerce/features/cart/domain/usecases/sync_cart_on_login.dart';
import 'package:echoemaar_commerce/features/cart/domain/usecases/update_cart_item_quantity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/cart.dart';

import '../../../../core/usecases/usecase.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCart getCart;
  final AddToCart addToCart;
  final UpdateCartItemQuantity updateCartItemQuantity;
  final RemoveCartItem removeCartItem;
  final ClearCart clearCart;
  final SyncCart syncCart;
  final SyncCartOnLogin syncCartOnLogin;

  CartBloc({
    required this.getCart,
    required this.addToCart,
    required this.updateCartItemQuantity,
    required this.removeCartItem,
    required this.clearCart,
    required this.syncCart,
    required this.syncCartOnLogin,
  }) : super(CartInitial()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartItemQuantityEvent>(_onUpdateQuantity);
    on<RemoveCartItemEvent>(_onRemoveItem);
    on<ClearCartEvent>(_onClearCart);
    on<SyncCartOnLoginEvent>(_onSyncOnLogin);
    on<ConvertToGuestCartEvent>(_onConvertToGuest);
    on<SyncCartEvent>(_onSyncCart);
  }

  // ── Load Cart ──────────────────────────────────────────────────────

  Future<void> _onLoadCart(
    LoadCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());

    final result = await getCart(NoParams());

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cart) => emit(CartLoaded(cart: cart)),
    );
  }

  // ── Add to Cart ────────────────────────────────────────────────────

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;
    Cart currentCart = CartModel.empty();

    if (currentState is CartLoaded) {
      currentCart = currentState.cart;
      // Show syncing indicator
      emit(currentState.copyWith(isSyncing: true));
    }

    final result = await addToCart(AddToCartParams(
      productId: event.productId,
      
      // productName: event.productName,
      // productImage: event.productImage,
      // unitPrice: event.unitPrice,
      quantity: event.quantity, productName: event.productName, price: event.unitPrice,
      // variantId: event.variantId,
      // variantName: event.variantName,
    ));

    result.fold(
      (failure) => emit(CartError(failure.message, currentCart: currentCart)),
      (updatedCart) {
        // Emit success message (transient)
        emit(CartOperationSuccess(
          cart: updatedCart,
          message: 'Added to cart',
        ));
        // Immediately follow with loaded state
        emit(CartLoaded(cart: updatedCart));
      },
    );
  }

  // ── Update Quantity ────────────────────────────────────────────────

  Future<void> _onUpdateQuantity(
    UpdateCartItemQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
          log('🔵 BLoC received UpdateQuantity: itemId=${event.itemId}, quantity=${event.quantity}');

    final currentState = state;
    Cart currentCart = CartModel.empty();

    if (currentState is CartLoaded) {
      currentCart = currentState.cart;
      emit(currentState.copyWith(isSyncing: true));
    }

    final result = await updateCartItemQuantity(UpdateCartItemQuantityParams(
      itemId: event.itemId,
      quantity: event.quantity,
    ));

    result.fold(
      (failure) => emit(CartError(failure.message, currentCart: currentCart)),
      (updatedCart) {
        
        emit(CartLoaded(cart: updatedCart));
      },
    );
  }

  // ── Remove Item ────────────────────────────────────────────────────

  Future<void> _onRemoveItem(
    RemoveCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;
    Cart currentCart = CartModel.empty();

    if (currentState is CartLoaded) {
      currentCart = currentState.cart;
      emit(currentState.copyWith(isSyncing: true));
    }

    final result = await removeCartItem(RemoveCartItemParams(itemId:  event.itemId));

    result.fold(
      (failure) => emit(CartError(failure.message, currentCart: currentCart)),
      (updatedCart) {
        emit(CartOperationSuccess(
          cart: updatedCart,
          message: 'Item removed',
        ));
        emit(CartLoaded(cart: updatedCart));
      },
    );
  }

  // ── Clear Cart ─────────────────────────────────────────────────────

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;
    Cart currentCart = CartModel.empty();

    if (currentState is CartLoaded) {
      currentCart = currentState.cart;
    }

    final result = await clearCart(NoParams());

    result.fold(
      (failure) => emit(CartError(failure.message, currentCart: currentCart)),
      (emptyCart) => emit(CartLoaded(cart: CartModel.empty())),
    );
  }

  // ── Sync on Login (Merge Guest + Remote) ───────────────────────────

  Future<void> _onSyncOnLogin(
    SyncCartOnLoginEvent event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;

    if (currentState is CartLoaded) {
      emit(currentState.copyWith(isSyncing: true));
    } else {
      emit(CartLoading());
    }

    final result = await syncCartOnLogin(NoParams());

    result.fold(
      (failure) {
        final currentCart =
            currentState is CartLoaded ? currentState.cart : CartModel.empty();
        emit(CartError(failure.message, currentCart: currentCart));
      },
      (mergedCart) {
        emit(CartOperationSuccess(
          cart: mergedCart,
          message: 'Cart synced successfully',
        ));
        emit(CartLoaded(cart: mergedCart));
      },
    );
  }

  // ── Convert to Guest (on Logout) ───────────────────────────────────

  Future<void> _onConvertToGuest(
    ConvertToGuestCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;

    if (currentState is CartLoaded) {
      // Keep cart items but mark as guest

      final guestCart = currentState.cart.copyWith(

        id: null,
        isGuest: true,
      );
      emit(CartLoaded(cart: guestCart));
    }
  }

  // ── Manual Sync (Pull-to-Refresh) ──────────────────────────────────

  Future<void> _onSyncCart(
    SyncCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;

    if (currentState is CartLoaded) {
      emit(currentState.copyWith(isSyncing: true));
    }

    final result = await syncCart(NoParams());

    result.fold(
      (failure) {
        final currentCart =
            currentState is CartLoaded ? currentState.cart : CartModel.empty();
        emit(CartError(failure.message, currentCart: currentCart));
        // Restore previous state
        if (currentState is CartLoaded) {
          emit(currentState);
        }
      },
      (syncedCart) => emit(CartLoaded(cart: syncedCart)),
    );
  }
}


final GlobalKey<_MyWidgetState> myWidgetKey = GlobalKey();
class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  void increament(){

  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MyWidget2 extends StatefulWidget {
  const MyWidget2({super.key});

  @override
  State<MyWidget2> createState() => _MyWidget2State();
}

class _MyWidget2State extends State<MyWidget2> {
  increment(){
    myWidgetKey.currentState!.increament();
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}