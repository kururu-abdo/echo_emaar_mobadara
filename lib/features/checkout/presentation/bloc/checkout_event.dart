part of 'checkout_bloc.dart';


abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

// ── Load checkout data ─────────────────────────────────────────────

class LoadCheckoutEvent extends CheckoutEvent {}

// ── Address selection ──────────────────────────────────────────────

class SelectShippingAddressEvent extends CheckoutEvent {
  final ShippingAddress address;

  const SelectShippingAddressEvent(this.address);

  @override
  List<Object> get props => [address];
}

class AddNewAddressEvent extends CheckoutEvent {
  final ShippingAddress address;

  const AddNewAddressEvent(this.address);

  @override
  List<Object> get props => [address];
}

// ── Payment method selection ───────────────────────────────────────

class SelectPaymentMethodEvent extends CheckoutEvent {
  final PaymentMethod paymentMethod;

  const SelectPaymentMethodEvent(this.paymentMethod);

  @override
  List<Object> get props => [paymentMethod];
}

// ── Order notes ────────────────────────────────────────────────────

class UpdateOrderNotesEvent extends CheckoutEvent {
  final String notes;

  const UpdateOrderNotesEvent(this.notes);

  @override
  List<Object> get props => [notes];
}

// ── Place order ────────────────────────────────────────────────────

class PlaceOrderEvent extends CheckoutEvent {}