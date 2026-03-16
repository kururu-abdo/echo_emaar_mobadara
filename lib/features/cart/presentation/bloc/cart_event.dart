part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

// ── Load cart (on app start, after login, etc) ────────────────────

class LoadCartEvent extends CartEvent {}

// ── Add product to cart ────────────────────────────────────────────

class AddToCartEvent extends CartEvent {
  final int productId;
  final String productName;
  final String? productImage;
  final double unitPrice;
  final int quantity;
  final int? variantId;
  final String? variantName;

  const AddToCartEvent({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.unitPrice,
    this.quantity = 1,
    this.variantId,
    this.variantName,
  });

  @override
  List<Object?> get props => [
        productId,
        productName,
        productImage,
        unitPrice,
        quantity,
        variantId,
        variantName,
      ];
}

// ── Update item quantity ───────────────────────────────────────────

class UpdateCartItemQuantityEvent extends CartEvent {
  final String itemId;
  final int quantity;

  const UpdateCartItemQuantityEvent({
    required this.itemId,
    required this.quantity,
  });

  @override
  List<Object> get props => [itemId, quantity];
}

// ── Remove item from cart ──────────────────────────────────────────

class RemoveCartItemEvent extends CartEvent {
  final String itemId;

  const RemoveCartItemEvent(this.itemId);

  @override
  List<Object> get props => [itemId];
}

// ── Clear entire cart ──────────────────────────────────────────────

class ClearCartEvent extends CartEvent {}

// ── Auth lifecycle events ──────────────────────────────────────────

class SyncCartOnLoginEvent extends CartEvent {}

class ConvertToGuestCartEvent extends CartEvent {}

// ── Manual sync (pull-to-refresh) ──────────────────────────────────

class SyncCartEvent extends CartEvent {}
