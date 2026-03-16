// features/cart/data/repositories/cart_repository_impl.dart

import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/core/network/network_info.dart';
import 'package:echoemaar_commerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:echoemaar_commerce/features/cart/data/datasource/cart_local_date_soruce.dart';
import 'package:echoemaar_commerce/features/cart/data/datasource/cart_remote_data_source.dart';
import 'package:echoemaar_commerce/features/cart/data/models/cart_item_model.dart';
import 'package:echoemaar_commerce/features/cart/data/models/cart_model.dart';
import 'package:echoemaar_commerce/features/cart/domain/entities/cart.dart';
import 'package:echoemaar_commerce/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource local;
  final CartRemoteDataSource remote;
  final NetworkInfo networkInfo;
  final AuthRepository authRepo;  // To check login state
  
  CartRepositoryImpl({
    required this.local,
    required this.remote,
    required this.networkInfo,
    required this.authRepo,
  });
  
  // ── Get Cart ─────────────────────────────────────────────────────
  
  @override
  Future<Either<Failure, Cart>> getCart() async {
    
    try {
      log('My Token :  ${local.isGuestCart()}');
      
      final isGuest = await local.isGuestCart();
    log('GEST STATUS $isGuest');
          if (isGuest) {
              log('GEST STATUS');
        // Guest: local only
        final cart = await local.getCart();
        return Right(cart ?? CartModel.empty());
      }
      
    
      // Authenticated: try remote first, fallback to local
      if (await networkInfo.isConnected) {
        try {
          log('GETTING CARTD');
          final remoteCart = await remote.getCart();
          await local.saveCart(remoteCart);
          return Right(remoteCart);
        } catch (e) {
          log('REMOTE ERROR: $e');
          // Remote failed, use local cache
          final localCart = await local.getCart();
          return Right(localCart ?? CartModel.empty());
        }
      } else {
         log('OFFLINE CARTD');
        // Offline, use local
        final localCart = await local.getCart();
        return Right(localCart ?? CartModel.empty());
      }
    } catch (e) {
      log('CART ERROR: $e');  
      return Left(CacheFailure(e.toString()));
    }
  }
  
  // ── Add to Cart ──────────────────────────────────────────────────
  
  @override
  Future<Either<Failure, Cart>> addToCart(
    int productId,
    String productName,
    num price,
    int quantity, {
    int? variantId,
  }) async {
    try {
      // 1. Update local immediately
      final localCart = await local.getCart() ?? CartModel.empty();
      final updatedCart = localCart.addItem(
        // productId: productId,
        // quantity: quantity,
        // variantId: variantId, productName: productName, unitPrice: price.toDouble(),

        CartItemModel(lineId: productId, productId: productId, productName: productName, quantity: quantity.toInt(), priceUnit: price.toDouble())
      );
      await local.saveCart(updatedCart);
      
      // 2. If authenticated, sync to remote (fire-and-forget)
      final isGuest = await local.isGuestCart();
      log('IS GUEST : $isGuest');
      if (!isGuest && await networkInfo.isConnected) {
        _syncToRemoteBackground(updatedCart   );
      }
      
      return Right(updatedCart);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
  
  // ── Update Quantity ──────────────────────────────────────────────
  
  @override
  Future<Either<Failure, Cart>> updateQuantity(String itemId, int quantity) async {
    try {
  log('🔵 REPOSITORY received UpdateQuantity: itemId=$itemId, quantity=$quantity');
      final localCart = await local.getCart();



      if (localCart == null) return Right(CartModel.empty());
      
    
final updatedCart = localCart.updateItemQuantity(itemId, quantity);
await local.saveCart(updatedCart);

      
      final isGuest = await local.isGuestCart();
//       var item = localCart.items!.firstWhere((item)=> item.productId.toString()== itemId);
//  item = (item as CartItemModel).copyWith(quantity: quantity); 

      if (!isGuest && await networkInfo.isConnected) {
        _syncToRemoteBackground(updatedCart ,);
      }
            // final updatedCart = localCart.updateItemQuantity(itemId, quantity);
log("AFTER UPDATE>>>>>>>>>>>>>>>>>>>>>>>.${updatedCart.toJson()}");
      return Right(updatedCart);
    } catch (e) {
      log(e.toString());
      return Left(CacheFailure(e.toString()));
    }
  }
  
  // ── On Login (Merge) ─────────────────────────────────────────────
  
  @override
  Future<Either<Failure, Cart>> onLogin() async {
    try {
      // 1. Fetch local guest cart
      final localCart = await local.getCart() ?? CartModel.empty();
      
      // 2. Fetch remote cart (if exists)
      CartModel remoteCart = CartModel.empty();
      if (await networkInfo.isConnected) {
        try {
          remoteCart = await remote.getCart();
        } catch (_) {
          // No remote cart, that's fine
        }
      }
      
      // 3. Merge: local + remote, deduplicate by productId
      final mergedCart = _mergeCart(localCart, remoteCart);
      
      // 4. Save merged cart locally
      await local.saveCart(mergedCart);
      await local.setGuestFlag(false);
      
      // 5. Push merged cart to remote
      if (await networkInfo.isConnected) {
        await remote.createOrUpdateCart(mergedCart.items as List<CartItemModel>);
      }
      
      return Right(mergedCart);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  // ── On Logout ────────────────────────────────────────────────────
  
  @override
  Future<Either<Failure, void>> onLogout() async {
    try {
      // Option A: Clear cart entirely
      // await local.clearCart();
      
      // Option B: Convert to guest cart (preserve items)
      await local.setGuestFlag(true);
      
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
  
  // ── Helpers ──────────────────────────────────────────────────────
  
  CartModel _mergeCart(CartModel local, CartModel remote) {
    final Map<int, CartItemModel> itemMap = {};
    
    // Add local items
    for (final item in local.items as List<CartItemModel>) {
      itemMap[item.productId] = item;
    }
    
    // Merge remote items
    for (final item in remote.items as List<CartItemModel>) {
      if (itemMap.containsKey(item.productId)) {
        // Conflict: take max quantity
        final existing = itemMap[item.productId]!;
        itemMap[item.productId] = existing.copyWith(
          quantity: existing.quantity > item.quantity
              ? existing.quantity
              : item.quantity,
        );
      } else {
        itemMap[item.productId] = item;
      }
    }
    
    return CartModel(
      items: itemMap.values.toList(),
      isGuest: false,
      orderId:0 ,
      lastSynced: DateTime.now(), subtotal: 0, total: 0, name:  '',
    );
  }
  
/// Sync entire cart to remote in background (fire-and-forget)
/// ALWAYS sends all cart items, not just one item
Future<void> _syncToRemoteBackground(CartModel cart) async {
  try {
    log('Background sync: Sending $cart items to remote');
    
    // Send entire cart (all items)
    await remote.createOrUpdateCart(cart.items as List<CartItemModel>);
    
    log('Background sync successful');
  } catch (e) {
    log('Background sync failed: $e');
    // Don't throw - this is fire-and-forget
  }
}
  
 @override
Future<Either<Failure, Cart>> clearCart() async {
  try {
    await local.clearCart();
          final isGuest = await local.isGuestCart();

    if (!isGuest && await networkInfo.isConnected) {
      await remote.createOrUpdateCart([]); // Send empty cart
    }
    
    return Right(CartModel.empty());
  } catch (e) {
    return Left(CacheFailure(e.toString()));
  }
}
  
  @override
  Future<Either<Failure, void>> pushCartToRemote() {
    // TODO: implement pushCartToRemote
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, Cart>> removeItem(String itemId)async {
  try {
    final localCart = await local.getCart();
    if (localCart == null) return Right(CartModel.empty());
    
    
  // Remove item locally
  final updatedCart = localCart.removeItem(itemId);
  await local.saveCart(updatedCart);
  log('Item removed locally. Cart now has ${updatedCart.items!} items');
  
  // Sync entire cart to remote if authenticated
  final isGuest = await local.isGuestCart();
  if (!isGuest && await networkInfo.isConnected) {
    log('Syncing entire cart after removal (${updatedCart.items!.length} items)');
    _syncToRemoteBackground(updatedCart);
  }
  
  return Right(updatedCart);
  } catch (e) {
    return Left(CacheFailure(e.toString()));
  }
  }
  
  @override
  Future<Either<Failure, Cart>> syncCart() {
    // TODO: implement syncCart
    throw UnimplementedError();
  }
}