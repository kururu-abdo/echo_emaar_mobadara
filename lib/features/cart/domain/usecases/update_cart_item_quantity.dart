import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/features/cart/domain/entities/cart.dart';
import 'package:echoemaar_commerce/features/cart/domain/repositories/cart_repository.dart';

class UpdateCartItemQuantity {
  final CartRepository repository;
  UpdateCartItemQuantity(this.repository);

  Future<Either<Failure, Cart>> call(UpdateCartItemQuantityParams params) async => 
      await repository.updateQuantity(params.itemId, params.quantity);
}

class UpdateCartItemQuantityParams {
  final String itemId;
  final int quantity;

  UpdateCartItemQuantityParams({
    required this.itemId,
    required this.quantity,
  });
}