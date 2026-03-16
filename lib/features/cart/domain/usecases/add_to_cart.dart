// features/cart/domain/usecases/add_to_cart.dart
import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/core/usecases/usecase.dart';
import 'package:echoemaar_commerce/features/cart/domain/entities/cart.dart';
import 'package:echoemaar_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:echoemaar_commerce/features/cart/domain/repositories/cart_repository.dart';

class AddToCart implements UseCase<Cart, AddToCartParams> {
  final CartRepository repository;
  AddToCart(this.repository);

  @override
  Future<Either<Failure, Cart>> call(AddToCartParams params) async => await repository.addToCart(params.productId,
    params.productName, params.price, params.quantity);
}

class AddToCartParams {
  final int productId;
  final String productName;
  final num price;
  final int quantity;

  AddToCartParams({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });
}