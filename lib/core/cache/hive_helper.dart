// core/cache/hive_helper.dart
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  static const String cart = 'cart';
  static const String products = 'products_cache';
  static const String categories = 'categories_cache';
  
  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox(cart),
      Hive.openBox(products),
      Hive.openBox(categories),
    ]);
  }
  
  static Box getCartBox() => Hive.box(cart);
  static Box getProductsBox() => Hive.box(products);
  static Box getCategoriesBox() => Hive.box(categories);
}