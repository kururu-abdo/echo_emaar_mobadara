import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/core/usecases/usecase.dart';
import 'package:echoemaar_commerce/features/cart/domain/entities/cart.dart';
import 'package:echoemaar_commerce/features/cart/domain/repositories/cart_repository.dart';

class GetCart implements UseCase<Cart, NoParams> {
  final CartRepository repository;
  GetCart(this.repository);

  @override
  Future<Either<Failure, Cart>> call(NoParams params) async => await repository.getCart();
}