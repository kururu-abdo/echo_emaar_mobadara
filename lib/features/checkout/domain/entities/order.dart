import 'package:equatable/equatable.dart';
import '../../../cart/domain/entities/cart.dart';
import 'shipping_address.dart';
import 'payment_method.dart';

class OrderSummary extends Equatable {
  final Cart cart;
  final ShippingAddress shippingAddress;
  // final PaymentMethod paymentMethod;
  final String? notes;
  final DateTime estimatedDelivery;

  const OrderSummary({
    required this.cart,
    required this.shippingAddress,
    // required this.paymentMethod,
    this.notes,
    required this.estimatedDelivery,
  });

  // Totals
  double get subtotal => cart.subtotal!;
  double get tax => cart.tax!;
  double get discount => cart.discount!;
  double get shippingFee => cart.shippingFee!;
  double get total => cart.total!;

  int get totalItems => cart.totalItems.toInt();

  @override
  List<Object?> get props => [
        cart,
        shippingAddress,
        // paymentMethod,
        notes,
        estimatedDelivery,
      ];
}
