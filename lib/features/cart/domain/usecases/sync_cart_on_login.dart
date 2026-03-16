// features/cart/domain/usecases/sync_cart_on_login.dart
import 'package:echoemaar_commerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:echoemaar_commerce/core/usecases/usecase.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/features/cart/domain/entities/cart.dart';
import 'package:dartz/dartz.dart';

class SyncCartOnLogin implements UseCase<Cart, NoParams> {
  final CartRepository repository;
  SyncCartOnLogin(this.repository);

  @override
  Future<Either<Failure, Cart>> call(NoParams params) async {
    // 1. Get the local guest cart
    final localResult = await repository.getCart();
    
    return localResult.fold(
      (failure) => Left(failure),
      (guestCart) async {
        if (guestCart.items!.isEmpty) {
          return await repository.syncCart(); // Just fetch remote if local is empty
        }
        // 2. Logic to push local guest items to Odoo server
        // This is usually handled within the repository's sync logic
        return await repository.syncCart(); 
      },
    );
  }
}