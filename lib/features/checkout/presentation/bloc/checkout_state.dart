part of 'checkout_bloc.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

// ── Initial ────────────────────────────────────────────────────────

class CheckoutInitial extends CheckoutState {}

// ── Loading addresses/cart ─────────────────────────────────────────

class CheckoutLoading extends CheckoutState {}

// ── Ready for checkout ─────────────────────────────────────────────

class CheckoutReady extends CheckoutState {
  final Cart cart;
  final ShippingAddress? addresses;
  final ShippingAddress? selectedAddress;
  final PaymentMethod? selectedPaymentMethod;
  final String? orderNotes;
  final double shippingFee;

  const CheckoutReady({
    required this.cart,
    required this.addresses,
    this.selectedAddress,
    this.selectedPaymentMethod,
    this.orderNotes,
    this.shippingFee = 0,
  });

  bool get canPlaceOrder =>
      selectedAddress != null ;
     // && selectedPaymentMethod != null;

  double get subtotal => cart.subtotal??0.0;
  double get tax => cart.tax??0.0;
  double get discount => cart.discount??0.0;
  double get total => subtotal + tax - discount + shippingFee;

  @override
  List<Object?> get props => [
        cart,
        addresses,
        selectedAddress,
        selectedPaymentMethod,
        orderNotes,
        shippingFee,
      ];

  CheckoutReady copyWith({
    Cart? cart,
  ShippingAddress? addresses,
    ShippingAddress? selectedAddress,
    PaymentMethod? selectedPaymentMethod,
    String? orderNotes,
    double? shippingFee,
  }) {
    return CheckoutReady(
      cart: cart ?? this.cart,
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      orderNotes: orderNotes ?? this.orderNotes,
      shippingFee: shippingFee ?? this.shippingFee,
    );
  }
}

// ── Processing payment ─────────────────────────────────────────────

class CheckoutProcessingPayment extends CheckoutState {
  final OrderSummary orderSummary;

  const CheckoutProcessingPayment(this.orderSummary);

  @override
  List<Object> get props => [orderSummary];
}

// ── Placing order ──────────────────────────────────────────────────

class CheckoutPlacingOrder extends CheckoutState {
  final OrderSummary orderSummary;

  const CheckoutPlacingOrder(this.orderSummary);

  @override
  List<Object> get props => [orderSummary];
}

// ── Order placed successfully ──────────────────────────────────────

class CheckoutSuccess extends CheckoutState {
  final OrderConfirmation confirmation;

  const CheckoutSuccess(this.confirmation);

  @override
  List<Object> get props => [confirmation];
}

// ── Error ──────────────────────────────────────────────────────────

class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object> get props => [message];
}