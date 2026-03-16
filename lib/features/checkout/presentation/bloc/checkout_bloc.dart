import 'package:echoemaar_commerce/features/checkout/domain/entities/order.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/shipping_address.dart';
import 'package:echoemaar_commerce/features/checkout/domain/usecases/add_address.dart';
import 'package:echoemaar_commerce/features/checkout/domain/usecases/get_addresses.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../cart/domain/entities/cart.dart';
import '../../../cart/domain/usecases/get_cart.dart';
import '../../domain/entities/order_confirmation.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/shipping_address.dart';
import '../../domain/usecases/place_order.dart';
import '../../domain/usecases/process_payment.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final GetCart getCart;
  final GetShippingAddresses getShippingAddresses;
  final AddShippingAddress addShippingAddress;
  final PlaceOrder placeOrder;
  final ProcessPayment processPayment;

  CheckoutBloc({
    required this.getCart,
    required this.getShippingAddresses,
    required this.addShippingAddress,
    required this.placeOrder,
    required this.processPayment,
  }) : super(CheckoutInitial()) {
    on<LoadCheckoutEvent>(_onLoad);
    on<SelectShippingAddressEvent>(_onSelectAddress);
    on<AddNewAddressEvent>(_onAddAddress);
    on<SelectPaymentMethodEvent>(_onSelectPayment);
    on<UpdateOrderNotesEvent>(_onUpdateNotes);
    on<PlaceOrderEvent>(_onPlaceOrder);
  }

  // ── Load Checkout ──────────────────────────────────────────────────

  Future<void> _onLoad(
    LoadCheckoutEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(CheckoutLoading());

    // Load cart and addresses in parallel
    final results = await Future.wait([
      getCart(NoParams()),
      getShippingAddresses(NoParams()),
    ]);

    final cartResult = results[0];
    final addressesResult = results[1];

    // Check for failures
    String? error;
    Cart? cart;
   ShippingAddress? addresses;

    cartResult.fold(
      (failure) => error = failure.message,
      (data) => cart = data as Cart,
    );

    addressesResult.fold(
      (failure) => error ??= failure.message,
      (data) => addresses = data as ShippingAddress,
    );

    if (error != null) {
      emit(CheckoutError(error!));
      return;
    }

    if (cart == null || cart!.isEmpty) {
      emit(const CheckoutError('Cart is empty'));
      return;
    }
/*
    // Auto-select default address if available
    final defaultAddress = addresses.firstWhere(
      (addr) => addr.isDefault,
      orElse: () => addresses.isNotEmpty ? addresses.first : null as ShippingAddress,
    );
*/
    emit(CheckoutReady(
      cart: cart!,
      addresses: addresses,
      // selectedAddress: defaultAddress,
    ));
  }

  // ── Select Address ─────────────────────────────────────────────────

  void _onSelectAddress(
    SelectShippingAddressEvent event,
    Emitter<CheckoutState> emit,
  ) {
    final current = state;
    if (current is! CheckoutReady) return;

    emit(current.copyWith(selectedAddress: event.address));
  }

  // ── Add New Address ────────────────────────────────────────────────

  Future<void> _onAddAddress(
    AddNewAddressEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    final current = state;
    if (current is! CheckoutReady) return;

    final result = await addShippingAddress(
      AddShippingAddressParams(event.address),
    );

    result.fold(
      (failure) => emit(CheckoutError(failure.message)),
      (newAddress) {
        final updatedAddresses =  newAddress;
        emit(current.copyWith(
          addresses: updatedAddresses,
          selectedAddress: newAddress,
        ));
      },
    );
  }

  // ── Select Payment Method ──────────────────────────────────────────

  void _onSelectPayment(
    SelectPaymentMethodEvent event,
    Emitter<CheckoutState> emit,
  ) {
    final current = state;
    if (current is! CheckoutReady) return;

    emit(current.copyWith(selectedPaymentMethod: event.paymentMethod));
  }

  // ── Update Order Notes ─────────────────────────────────────────────

  void _onUpdateNotes(
    UpdateOrderNotesEvent event,
    Emitter<CheckoutState> emit,
  ) {
    final current = state;
    if (current is! CheckoutReady) return;

    emit(current.copyWith(orderNotes: event.notes));
  }

  // ── Place Order ────────────────────────────────────────────────────

  Future<void> _onPlaceOrder(
    PlaceOrderEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    final current = state;
    if (current is! CheckoutReady) return;

    if (!current.canPlaceOrder) {
      emit(const CheckoutError('Please select address and payment method'));
      return;
    }

    // Create order summary
    final orderSummary = OrderSummary(
      cart: current.cart,
      shippingAddress: current.selectedAddress!,
      // paymentMethod: current.selectedPaymentMethod!,
      notes: current.orderNotes,
      estimatedDelivery: DateTime.now().add(const Duration(days: 5)),
    );

    // Process payment for card payments

    /*
    if (current.selectedPaymentMethod!.isCard) {
      emit(CheckoutProcessingPayment(orderSummary));

      final paymentResult = await processPayment(
        ProcessPaymentParams(orderSummary),
      );

      final paymentSuccess = paymentResult.fold(
        (failure) {
          emit(CheckoutError('Payment failed: ${failure.message}'));
          return false;
        },
        (success) => success,
      );

      if (!paymentSuccess) return;
    }

    */

    // Place order
    emit(CheckoutPlacingOrder(orderSummary));

    final orderResult = await placeOrder(orderSummary.cart.id!);

    orderResult.fold(
      (failure) => emit(CheckoutError('Order failed: ${failure.message}')),
      (confirmation) => emit( CheckoutSuccess(confirmation)),
    );
  }
}