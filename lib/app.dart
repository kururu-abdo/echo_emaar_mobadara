import 'package:easy_localization/easy_localization.dart';
import 'package:echoemaar_commerce/config/routes/route_names.dart';
import 'package:echoemaar_commerce/core/utilities/navigator_service.dart';
import 'package:echoemaar_commerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:echoemaar_commerce/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:echoemaar_commerce/features/checkout/presentation/providers/checkout_provider.dart';
import 'package:echoemaar_commerce/features/invoice/presentation/providers/invoice_provider.dart';
import 'package:echoemaar_commerce/features/orders/presentation/providers/order_provider.dart';
import 'package:echoemaar_commerce/features/products/presentation/bloc/categories/category_bloc.dart';
import 'package:echoemaar_commerce/features/products/presentation/bloc/favorits/favorites_cubit.dart';
import 'package:echoemaar_commerce/features/products/presentation/bloc/product_detail/product_detail_bloc.dart';
import 'package:echoemaar_commerce/features/products/presentation/bloc/product_list/product_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'config/routes/app_router.dart';
import 'config/themes/theme_provider.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
// import 'features/products/presentation/bloc/product_list/product_list_bloc.dart';
// import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'injection_container.dart' as di;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Watch theme provider for changes
    final themeProvider = context.watch<ThemeProvider>();
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>()
            ..add(CheckAuthStatusEvent()),
        ),
 BlocProvider<CategoryBloc>(
          create: (context) => di.sl<CategoryBloc>()
            // ..add(CheckAuthStatusEvent()),
        ),
 BlocProvider<ProductListBloc>(
          create: (context) => di.sl<ProductListBloc>()
            // ..add(CheckAuthStatusEvent()),
        ),
BlocProvider<FavoritesCubit>(
          create: (context) => di.sl<FavoritesCubit>(),
        ),
BlocProvider<CartBloc>(
          create: (context) => di.sl<CartBloc>()
           ..add(LoadCartEvent()),
        ),
BlocProvider<CartBloc>(
          create: (context) => di.sl<CartBloc>()
           ..add(LoadCartEvent()),
        ),
BlocProvider<CheckoutBloc>(
          create: (context) => di.sl<CheckoutBloc>(),
        ),

        // BlocProvider<CartBloc>(
        //   create: (context) => di.sl<CartBloc>()
        //     ..add(LoadCartEvent()),
        // ),
        // BlocProvider<ProductListBloc>(
        //   create: (context) => di.sl<ProductListBloc>(),
        // ),
      ],
      child: MultiProvider(
        providers: [
           ChangeNotifierProvider<AuthProvider>(
          create: (context) => di.sl<AuthProvider>()
          
        ),
 ChangeNotifierProvider<CheckoutProvider>(
          create: (context) => di.sl<CheckoutProvider>()
          
        ),


 ChangeNotifierProvider<OrderProvider>(
          create: (context) => di.sl<OrderProvider>()
          
        ),

 ChangeNotifierProvider<InvoiceProvider>(
          create: (context) => di.sl<InvoiceProvider>()
          
        ),
        ],
        child: MaterialApp( title: 'app_name'.tr(), // ← Uses translation
          // title: themeProvider.brandConfig.brandName,
          debugShowCheckedModeBanner: false,
          
          // Dynamic theme based on brand configuration
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.themeMode,
            localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
          // routerConfig: AppRouter.router,
          initialRoute: RouteNames.splash,
      onGenerateRoute: AppRouteGenerator.generateRoute,
      // Optional: global navigator key for navigating without context
      navigatorKey: di.sl<NavigationService>().navigatorKey,
          // Optional: Add a builder for global widgets
          builder: (context, child) {
            return MediaQuery(
              // Prevent text scaling beyond reasonable limits
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.3)),
              ),
              child: child!,
            );
          },
        ),
      ),
    );
  }
}