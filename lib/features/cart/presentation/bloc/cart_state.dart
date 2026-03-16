


part of 'cart_bloc.dart';


abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

// ── Initial state ──────────────────────────────────────────────────

class CartInitial extends CartState {}

// ── Loading (first load only) ──────────────────────────────────────

class CartLoading extends CartState {}

// ── Loaded (main state with cart data) ────────────────────────────

class CartLoaded extends CartState {
  final Cart cart;
  final bool isSyncing; // Background sync in progress

  const CartLoaded({
    required this.cart,
    this.isSyncing = false,
  });

  @override
  List<Object> get props => [cart, isSyncing];

  CartLoaded copyWith({
    Cart? cart,
    bool? isSyncing,
  }) {
    return CartLoaded(
      cart: cart ?? this.cart,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
}

// ── Error (transient, doesn't replace loaded state) ───────────────

class CartError extends CartState {
  final String message;
  final Cart? currentCart; // Preserve cart data even on error

  const CartError(this.message, {this.currentCart});

  @override
  List<Object?> get props => [message, currentCart];
}

// ── Operation success (transient, with updated cart) ──────────────

class CartOperationSuccess extends CartState {
  final Cart cart;
  final String message;

  const CartOperationSuccess({
    required this.cart,
    required this.message,
  });

  @override
  List<Object> get props => [cart, message];
}