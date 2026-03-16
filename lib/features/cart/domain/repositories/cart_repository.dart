// features/cart/domain/repositories/cart_repository.dart

import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/features/cart/domain/entities/cart.dart';

abstract class CartRepository {
  // Core operations (works for both guest and auth)
  Future<Either<Failure, Cart>> getCart();
  Future<Either<Failure, Cart>> addToCart(int productId,   
    String productName,
    num price, int quantity, {int? variantId});
  Future<Either<Failure, Cart>> updateQuantity(String itemId, int quantity);
  Future<Either<Failure, Cart>> removeItem(String itemId);
  Future<Either<Failure, Cart>> clearCart();
  
  // Sync operations (auth only)
  Future<Either<Failure, Cart>> syncCart();  // Pull remote + merge
  Future<Either<Failure, void>> pushCartToRemote();  // Push local → remote
  
  // Auth lifecycle
  Future<Either<Failure, Cart>> onLogin();  // Merge guest → auth
  Future<Either<Failure, void>> onLogout();  // Convert auth → guest
}