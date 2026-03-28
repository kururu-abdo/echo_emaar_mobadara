import 'dart:io';

import 'package:echoemaar_commerce/core/network/http_client.dart';
import 'package:echoemaar_commerce/core/network/network_info.dart';
import 'package:echoemaar_commerce/core/network/odoo_http_client.dart';
import 'package:echoemaar_commerce/core/utilities/navigator_service.dart';
import 'package:echoemaar_commerce/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:echoemaar_commerce/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:echoemaar_commerce/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:echoemaar_commerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:echoemaar_commerce/features/auth/domain/usecases/get_current_user.dart';
import 'package:echoemaar_commerce/features/auth/domain/usecases/login_with_email.dart';
import 'package:echoemaar_commerce/features/auth/domain/usecases/login_with_phone.dart';
import 'package:echoemaar_commerce/features/auth/domain/usecases/logout.dart';
import 'package:echoemaar_commerce/features/auth/domain/usecases/register_user.dart';
import 'package:echoemaar_commerce/features/auth/domain/usecases/send_otp.dart';
import 'package:echoemaar_commerce/features/auth/domain/usecases/verify_otp.dart';
import 'package:echoemaar_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:echoemaar_commerce/features/auth/presentation/providers/auth_provider.dart';
import 'package:echoemaar_commerce/features/cart/data/datasource/cart_local_date_soruce.dart';
import 'package:echoemaar_commerce/features/cart/data/datasource/cart_remote_data_source.dart';
import 'package:echoemaar_commerce/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:echoemaar_commerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:echoemaar_commerce/features/cart/domain/usecases/add_to_cart.dart';
import 'package:echoemaar_commerce/features/cart/domain/usecases/clear_cart.dart';
import 'package:echoemaar_commerce/features/cart/domain/usecases/get_cart.dart';
import 'package:echoemaar_commerce/features/cart/domain/usecases/remove_cart_item.dart';
import 'package:echoemaar_commerce/features/cart/domain/usecases/sync_cart.dart';
import 'package:echoemaar_commerce/features/cart/domain/usecases/sync_cart_on_login.dart';
import 'package:echoemaar_commerce/features/cart/domain/usecases/update_cart_item_quantity.dart';
import 'package:echoemaar_commerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:echoemaar_commerce/features/checkout/data/datasources/checkout_local_datasource.dart';
import 'package:echoemaar_commerce/features/checkout/data/datasources/checkout_remote_datasource.dart';
import 'package:echoemaar_commerce/features/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:echoemaar_commerce/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:echoemaar_commerce/features/checkout/domain/usecases/add_address.dart';
import 'package:echoemaar_commerce/features/checkout/domain/usecases/create_order.dart';
import 'package:echoemaar_commerce/features/checkout/domain/usecases/get_addresses.dart';
import 'package:echoemaar_commerce/features/checkout/domain/usecases/get_countries.dart';
import 'package:echoemaar_commerce/features/checkout/domain/usecases/get_country_states.dart';
import 'package:echoemaar_commerce/features/checkout/domain/usecases/place_order.dart';
import 'package:echoemaar_commerce/features/checkout/domain/usecases/process_payment.dart';
import 'package:echoemaar_commerce/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:echoemaar_commerce/features/checkout/presentation/providers/checkout_provider.dart';
import 'package:echoemaar_commerce/features/home/presentation/bloc/home_bloc.dart';
import 'package:echoemaar_commerce/features/invoice/data/datasources/invoice_remote_datasource.dart';
import 'package:echoemaar_commerce/features/invoice/data/repositories/invoice_repository_impl.dart';
import 'package:echoemaar_commerce/features/invoice/domain/repositories/invoice_repository.dart';
import 'package:echoemaar_commerce/features/invoice/domain/usecases/get_invoices.dart';
import 'package:echoemaar_commerce/features/invoice/presentation/providers/invoice_provider.dart';
import 'package:echoemaar_commerce/features/notifications/presentation/providers/notification_provider.dart';
import 'package:echoemaar_commerce/features/orders/data/datasources/order_local_datasource.dart';
import 'package:echoemaar_commerce/features/orders/data/datasources/order_remote_datasource.dart' hide AuthRemoteDataSource, AuthRemoteDataSourceImpl;
import 'package:echoemaar_commerce/features/orders/data/repositories/order_repository_impl.dart';
import 'package:echoemaar_commerce/features/orders/domain/entities/order_history.dart';
import 'package:echoemaar_commerce/features/orders/domain/repositories/order_repository.dart';
import 'package:echoemaar_commerce/features/orders/domain/usecases/get_order_details.dart';
import 'package:echoemaar_commerce/features/orders/domain/usecases/get_order_history.dart';
import 'package:echoemaar_commerce/features/orders/presentation/providers/order_provider.dart';
import 'package:echoemaar_commerce/features/products/data/datasources/product_local_datasource.dart';
import 'package:echoemaar_commerce/features/products/data/datasources/product_remote_datasource.dart';
import 'package:echoemaar_commerce/features/products/data/repositories/product_repository_impl.dart';
import 'package:echoemaar_commerce/features/products/domain/repositories/product_repository.dart';
import 'package:echoemaar_commerce/features/products/domain/usecases/get_categories.dart';
import 'package:echoemaar_commerce/features/products/domain/usecases/get_featured_products.dart';
import 'package:echoemaar_commerce/features/products/domain/usecases/get_most_sold_products.dart';
import 'package:echoemaar_commerce/features/products/domain/usecases/get_product_details.dart';
import 'package:echoemaar_commerce/features/products/domain/usecases/get_products.dart';
import 'package:echoemaar_commerce/features/products/domain/usecases/search_products.dart';
import 'package:echoemaar_commerce/features/products/presentation/bloc/categories/category_bloc.dart';
import 'package:echoemaar_commerce/features/products/presentation/bloc/favorits/favorites_cubit.dart';
import 'package:echoemaar_commerce/features/products/presentation/bloc/product_detail/product_detail_bloc.dart';
import 'package:echoemaar_commerce/features/products/presentation/bloc/product_list/product_list_bloc.dart';
import 'package:echoemaar_commerce/features/search/presentation/providers/search_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http  hide HttpClient;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  // sl.registerLazySingleton<HttpClient>(() => HttpClient());
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => InternetConnection());

    sl.registerLazySingleton(() => NavigationService());

  // Odoo Client
  sl.registerLazySingleton(() => OdooClient(
    'https://your-odoo-instance.com',
  ));
  
  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );
  
  // Initialize Hive
  await Hive.initFlutter();
 
  // Register all feature dependencies
    _initSearch();
_initNotifications();
  _initInvoices();
  _initAuth();
  _initProducts();
  _initHome();
  _initCart();
  _initCheckout();
  _initOrders();
   setupOdooClient();
}

// void _initAuth() {
//   // Data sources
//   sl.registerLazySingleton<AuthRemoteDataSource>(
//     () => AuthRemoteDataSourceImpl(odooClient: sl()),
//   );
  
//   sl.registerLazySingleton<AuthLocalDataSource>(
//     () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
//   );
  
//   // Repository
//   sl.registerLazySingleton<AuthRepository>(
//     () => AuthRepositoryImpl(
//       remoteDataSource: sl(),
//       localDataSource: sl(),
//       networkInfo: sl(),
//     ),
//   );
  
//   // Use cases
//   sl.registerLazySingleton(() => LoginWithPhone(sl()));
//   sl.registerLazySingleton(() => LoginWithOtp(sl()));
//   sl.registerLazySingleton(() => RegisterUser(sl()));
//   sl.registerLazySingleton(() => Logout(sl()));
//   sl.registerLazySingleton(() => GetCurrentUser(sl()));
  
//   // Bloc
//   sl.registerFactory(
//     () => AuthBloc(
//       loginWithPhone: sl(),
//       loginWithOtp: sl(),
//       registerUser: sl(),
//       logout: sl(),
//       getCurrentUser: sl(), sendOtp: sl(), verifyOtp: sl(),
//     ),
//   );
// }
void     _initSearch(){

  // Provider
  sl.registerFactory(
    () => SearchProvider(
  
    ),
  );
}
void     _initNotifications(){

  // Provider
  sl.registerFactory(
    () => NotificationProvider(
  
    ),
  );
}

void _initProducts() {


  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(odooClient: sl()),
  );
  
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(prefs: sl()),
  );
  
  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  
  // Use cases
  sl.registerLazySingleton(() => GetProducts(sl()));
   sl.registerLazySingleton(() => GetMostSoldProducts(sl()));
   sl.registerLazySingleton(() => GetCategories(sl()));
   sl.registerLazySingleton(() => GetFeaturedProducts(sl()));

 sl.registerLazySingleton(() => SearchProducts(sl()));
  sl.registerLazySingleton(() => GetProductDetails(sl()));

  /*
  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GetCurrentUser( sl()));
    sl.registerLazySingleton(() => LoginWithEmail( sl()));
*/
  // Bloc
  sl.registerFactory(
    () => ProductListBloc(
      getProducts: sl(), 
      getMostSoldProducts: sl(), 

      // searchProducts: sl(),
      // sendOtp: sl(),
      // verifyOtp: sl(),
      // logout: sl(),
      // getCurrentUser: sl(),
      // loginWithEmail: sl()
    ),
  );
  
   sl.registerFactory(
    () => ProductDetailBloc(getProductDetails: sl()
   
      // searchProducts: sl(),
      // sendOtp: sl(),
      // verifyOtp: sl(),
      // logout: sl(),
      // getCurrentUser: sl(),
      // loginWithEmail: sl()
    ),
  );
sl.registerFactory(
    () => CategoryBloc(getCategories: sl()
   
      // searchProducts: sl(),
      // sendOtp: sl(),
      // verifyOtp: sl(),
      // logout: sl(),
      // getCurrentUser: sl(),
      // loginWithEmail: sl()
    ),
  );
sl.registerFactory(() => FavoritesCubit(sl()));
}

void _initCart() {
  // Similar pattern as auth...
 // Data sources
sl.registerLazySingleton<CartRemoteDataSource>(
  () => CartRemoteDataSourceImpl(odooClient: sl()),
);
sl.registerLazySingleton<CartLocalDataSource>(
  () => CartLocalDataSourceImpl(sharedPreferences: sl())
);



  // Repository
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      remote: sl(),
      local: sl(),
      networkInfo: sl(), authRepo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => ClearCart(sl()));
  sl.registerLazySingleton(() => SyncCart(sl()));
  sl.registerLazySingleton(() => SyncCartOnLogin(sl())); 
  sl.registerLazySingleton(() => GetCart(sl()));
  sl.registerLazySingleton(() => AddToCart(sl()));
  sl.registerLazySingleton(() => UpdateCartItemQuantity(sl()));
  sl.registerLazySingleton(() => RemoveCartItem(sl()));    


  // Bloc
  sl.registerFactory(
    () => CartBloc(
      getCart: sl(),
      addToCart: sl(),
      updateCartItemQuantity: sl(),
      removeCartItem: sl(),
      clearCart: sl(),
      syncCart: sl(),
      syncCartOnLogin: sl(),
    ),
  );










}

void _initCheckout() {
  // Similar pattern as auth...

   // Data sources
sl.registerLazySingleton<CheckoutRemoteDataSource>(
  () => CheckoutRemoteDataSourceImpl(apiClient: sl()),
);
sl.registerLazySingleton<CheckoutLocalDatasource>(
  () => CheckoutLocalDatasource(sharedPreferences: sl()),
);
//use cases
 sl.registerLazySingleton(() => AddShippingAddress(sl()));
  sl.registerLazySingleton(() => CreateOrderSummary(sl()));
  sl.registerLazySingleton(() => GetShippingAddresses(sl())); 
  sl.registerLazySingleton(() => PlaceOrder(sl()));
  sl.registerLazySingleton(() => ProcessPayment(sl()));
  sl.registerLazySingleton(() => GetCountries(sl()));
  sl.registerLazySingleton(() => GetCountryStates(sl()));

//repo
 sl.registerLazySingleton<CheckoutRepository>(
    () => CheckoutRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(), 
    ),
  );
//bloc
sl.registerFactory(
    () => CheckoutBloc(
    getCart: sl(), getShippingAddresses: sl(), addShippingAddress: sl(), placeOrder: sl(), processPayment: sl()
    ),
  );
sl.registerFactory(
    () => CheckoutProvider(
     getShippingAddresses: sl(), addShippingAddress: sl(),
     getCountries: sl(), getCountryStates: sl()
    ),
  );

}

void _initHome() {
  // BLoC
  sl.registerFactory(
    () => HomeBloc(
      getCategories: sl(),
      getFeaturedProducts: sl(),
      getProducts: sl(),
    ),
  );
}
void _initOrders() {
  // Similar pattern as auth...
  //data source
   sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSource(apiClient: sl()),
  );
  
  sl.registerLazySingleton<OrderLocalDataSource>(
    () => OrderLocalDataSource(sharedPreferences: sl()),
  );
  //use cases
  // sl.registerLazySingleton(() => GetOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetOrderDetailsUseCase(sl()));

  //repo
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //use cases
  sl.registerLazySingleton(() => GetOrdersUseCase(sl()));

//providers/Blocs
sl.registerFactory(
    () => OrderProvider(
      getOrdersUseCase: sl(),
      getOrderDetailsUseCase: sl(),
    
     
    ),
  );

  
}
// Initialize in injection_container.dart
void setupOdooClient() {
  // HTTP Client
  sl.registerLazySingleton<AppHttpClient>(
    () => AppHttpClient(getSession:()=> sl<AuthLocalDataSource>().getAuthToken(),),
  );
  
  // Odoo HTTP Client
  sl.registerLazySingleton<OdooHttpClient>(
    () => OdooHttpClient(
      baseUrl: 'https://echoemaar.com',
      database: 'your_database',
      httpClient: sl(),
      prefs: sl(),

      getSession: ()=> sl<AuthLocalDataSource>().getAuthToken()
    ),
  );
}

void _initAuth() {
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(odooClient: sl()),
  );
  
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
  
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  
  // Use cases
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GetCurrentUser( sl()));
    sl.registerLazySingleton(() => LoginWithEmail( sl()));

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      registerUser: sl(),
      sendOtp: sl(),
      verifyOtp: sl(),
      logout: sl(),
      getCurrentUser: sl(),
      loginWithEmail: sl()
    ),
  );
sl.registerFactory(
    () => AuthProvider(
      registerUser: sl(),
      sendOtp: sl(),
      verifyOtp: sl(),
      logout: sl(),
      getCurrentUser: sl(),
      loginWithEmail: sl()
    ),
  );

}


void _initInvoices(){
  //data srource
    sl.registerLazySingleton<InvoiceRemoteDataSource>(
    () => InvoiceRemoteDataSourceImpl(apiClient : sl()),
  );
// Repository
  sl.registerLazySingleton<InvoiceRepository>(
    () => InvoiceRepositoryImpl(
      remoteDataSource: sl(),
      // localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

// usecases
  sl.registerLazySingleton(() => GetInvoices(sl()));
  


  //providers
  sl.registerFactory(
    () => InvoiceProvider(
      getInvoices: sl(),
   
    ),
  );
}

