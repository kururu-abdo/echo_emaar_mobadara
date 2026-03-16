import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/core/usecases/usecase.dart';
import 'package:echoemaar_commerce/features/cart/domain/repositories/cart_repository.dart';

class ClearCart implements UseCase<void, NoParams> {
  final CartRepository repository;
  ClearCart(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async => await repository.clearCart();
}