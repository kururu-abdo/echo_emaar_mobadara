import 'dart:developer';

import 'package:echoemaar_commerce/config/constants/api_constants.dart';
import 'package:echoemaar_commerce/core/network/odoo_http_client.dart';
import 'package:echoemaar_commerce/features/products/data/models/product_model.dart';

import '../../../../core/network/odoo_api_client.dart';
import '../models/category_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    int? categoryId,
    int offset = 0,
    int limit = 20,
    String? sortBy,
  });
   Future<List<ProductModel>> getMostSoldProducts();
  Future<ProductModel> getProductDetails(int productId);
  Future<List<ProductModel>> searchProducts(String query);
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getFeaturedProducts();
  Future<List<ProductModel>> getRelatedProducts(int productId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final OdooHttpClient odooClient;
  
  ProductRemoteDataSourceImpl({required this.odooClient});
  
  @override
  Future<List<ProductModel>> getProducts({
    int? categoryId,
    int offset = 0,
    int limit = 20,
    String? sortBy,
  }) async {
    // final domain = <dynamic>[
    //   ['sale_ok', '=', true],
    //   ['active', '=', true],
    // ];
    
    // if (categoryId != null) {
    //   domain.add(['categ_id', '=', categoryId]);
    // }
    
    final result = await odooClient.restGet(
      ApiConstants.productsEndpoint
      // 'product.product',
      // domain: domain,
      // fields: [
      //   'id',
      //   'name',
      //   'description_sale',
      //   'list_price',
      //   'sale_price',
      //   'categ_id',
      //   'qty_available',
      //   'image_1920',
      //   'product_image_ids',
      //   'rating_avg',
      //   'rating_count',
      // ],
      // offset: offset,
      // limit: limit,
      // order: sortBy ?? 'id desc',
    );
    
    return result['data'].map<ProductModel>((data) => ProductModel.fromOdoo(data)).toList();
  }
  
  @override
  Future<ProductModel> getProductDetails(int productId) async {
    // 
    //
    //
    //
    final result = await odooClient.restGet(
      '${ApiConstants.productsEndpoint}/$productId'
    );
    //
    //
    // await odooClient.searchRead(
    //   'product.product',
    //   domain: [
    //     ['id', '=', productId],
    //     ['sale_ok', '=', true],
    //   ],
    //   fields: [
    //     'id',
    //     'name',
    //     'description_sale',
    //     'list_price',
    //     'sale_price',
    //     'categ_id',
    //     'qty_available',
    //     'image_1920',
    //     'product_image_ids',
    //     'rating_avg',
    //     'rating_count',
    //     'attribute_line_ids',
    //   ],
    //   limit: 1,
    // );
    
    // if (result.isEmpty) {
    //   throw Exception('Product not found');
    // }
    
    return ProductModel.fromOdoo(result['data'][0]);
  }
  
  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final result = await odooClient.searchRead(
      'product.product',
      domain: [
        ['name', 'ilike', query],
        ['sale_ok', '=', true],
        ['active', '=', true],
      ],
      fields: [
        'id',
        'name',
        'description_sale',
        'list_price',
        'sale_price',
        'categ_id',
        'qty_available',
        'image_1920',
        'rating_avg',
        'rating_count',
      ],
      limit: 50,
    );
    
    return result.map<ProductModel>((data) => ProductModel.fromOdoo(data)).toList();
  }
  /*
  @override
  Future<List<CategoryModel>> getCategories() async {
    final result = await odooClient.searchRead(
      'product.category',
      domain: [],
      fields: [
        'id',
        'name',
        'description',
        'image_128',
        'parent_id',
        'product_count',
      ],
      order: 'name asc',
    );
    
    return result.map<CategoryModel>((data) => CategoryModel.fromOdoo(data)).toList();
  }
  */
  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    final result = await odooClient.restGet(ApiConstants.mostSoldProductsEndpoint);
    
    return result['data'].map<ProductModel>((data) => ProductModel.fromOdoo(data)).toList();  
  }
  
  @override
  Future<List<ProductModel>> getRelatedProducts(int productId) async {
    // First get the product's category
    final productResult = await odooClient.searchRead(
      'product.product',
      domain: [['id', '=', productId]],
      fields: ['categ_id'],
      limit: 1,
    );
    
    if (productResult.isEmpty) {
      throw Exception('Product not found');
    }
    
    final categoryId = productResult[0]['categ_id'][0] as int;
    
    // Get products from same category
    final result = await odooClient.searchRead(
      'product.product',
      domain: [
        ['categ_id', '=', categoryId],
        ['id', '!=', productId],
        ['sale_ok', '=', true],
        ['active', '=', true],
      ],
      fields: [
        'id',
        'name',
        'description_sale',
        'list_price',
        'sale_price',
        'categ_id',
        'qty_available',
        'image_1920',
        'rating_avg',
        'rating_count',
      ],
      limit: 6,
    );
    
    return result.map<ProductModel>((data) => ProductModel.fromOdoo(data)).toList();
  }
  
  @override
  Future<List<ProductModel>> getMostSoldProducts()async {
  
    final result = await odooClient.restGet(
      ApiConstants.mostSoldProductsEndpoint
      // 'product.product',
      // domain: domain,
      // fields: [
      //   'id',
      //   'name',
      //   'description_sale',
      //   'list_price',
      //   'sale_price',
      //   'categ_id',
      //   'qty_available',
      //   'image_1920',
      //   'product_image_ids',
      //   'rating_avg',
      //   'rating_count',
      // ],
      // offset: offset,
      // limit: limit,
      // order: sortBy ?? 'id desc',
    );
    
    return result['data'].map<ProductModel>((data) => ProductModel.fromOdoo(data)).toList();
  }
  
  @override
  Future<List<CategoryModel>> getCategories() async {
    log('GETTING CATEGORIS');
    final result = await odooClient.restGet(ApiConstants.categoriesEndpoint);
    return result['data'].map<CategoryModel>((data) => CategoryModel.fromOdoo(data)).toList();
  }
}


