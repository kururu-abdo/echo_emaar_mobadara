import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/country.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/country_state.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/order.dart';
import '../../../../core/error/failures.dart';
import '../entities/order_confirmation.dart';
import '../entities/payment_method.dart';
import '../entities/shipping_address.dart';

abstract class CheckoutRepository {
  // Shipping addresses
  Future<Either<Failure, ShippingAddress>> getShippingAddresses();
    Future<Either<Failure, List<Country>>> getCountries();
    Future<Either<Failure, List<CountryState>>> getCountryStates(int country);

  Future<Either<Failure, ShippingAddress>> addShippingAddress(
      ShippingAddress address);
  Future<Either<Failure, ShippingAddress>> updateShippingAddress(
      ShippingAddress address);
  Future<Either<Failure, void>> deleteShippingAddress(int addressId);

  // Checkout process
  Future<Either<Failure, OrderSummary>> createOrderSummary({
    required int cartId,
    required int shippingAddressId,
    required PaymentMethod paymentMethod,
    String? notes,
  });

  // Place order
  Future<Either<Failure, OrderConfirmation>> placeOrder({
    // required OrderSummary orderSummary,
    required int orderId
  });

  // Process payment (for card payments)
  Future<Either<Failure, bool>> processPayment({
    required OrderSummary orderSummary,
  });

  // Calculate shipping fee
  Future<Either<Failure, double>> calculateShippingFee(
      int shippingAddressId);
}