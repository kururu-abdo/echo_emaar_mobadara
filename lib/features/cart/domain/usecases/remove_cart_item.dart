// features/cart/domain/usecases/remove_cart_item.dart
import 'package:echoemaar_commerce/core/usecases/usecase.dart';
import 'package:echoemaar_commerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/features/cart/domain/entities/cart.dart';

class RemoveCartItem implements UseCase<Cart, RemoveCartItemParams> {
  final CartRepository repository;
  RemoveCartItem(this.repository);

  Future<Either<Failure, Cart>> call(RemoveCartItemParams params) async => await repository.removeItem(params.itemId);
}

class RemoveCartItemParams {
  final String itemId;

  RemoveCartItemParams({required this.itemId});
}