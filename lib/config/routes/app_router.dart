import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/utilities/typography_utils.dart';
import 'package:echoemaar_commerce/features/auth/presentation/pages/otp_verification.dart';
import 'package:echoemaar_commerce/features/auth/presentation/pages/profile_page.dart';
import 'package:echoemaar_commerce/features/auth/presentation/providers/auth_provider.dart';
import 'package:echoemaar_commerce/features/cart/data/models/cart_model.dart';
import 'package:echoemaar_commerce/features/cart/presentation/pages/cart_page.dart';
import 'package:echoemaar_commerce/features/checkout/presentation/pages/add_address_page.dart';
import 'package:echoemaar_commerce/features/checkout/presentation/pages/checkout_page.dart';
import 'package:echoemaar_commerce/features/home/presentation/pages/dashboard.dart';
import 'package:echoemaar_commerce/features/home/presentation/pages/home_page.dart';
import 'package:echoemaar_commerce/features/products/presentation/bloc/product_list/product_list_bloc.dart';
import 'package:echoemaar_commerce/features/products/presentation/pages/product_detail_page.dart';
import 'package:echoemaar_commerce/features/products/presentation/pages/product_list_page.dart';
import 'package:echoemaar_commerce/features/settings/presentation/pages/setting_page.dart';
// import 'package:echoemaar_commerce/features/cart/presentation/bloc/cart_bloc.dart';
// import 'package:echoemaar_commerce/features/cart/presentation/bloc/cart_state.dart';
// import 'package:echoemaar_commerce/features/checkout/presentation/pages/add_address_page.dart';
// import 'package:echoemaar_commerce/features/checkout/presentation/pages/order_confirmation_page.dart';
// import 'package:echoemaar_commerce/features/checkout/presentation/widgets/address_selection_page.dart';
// import 'package:echoemaar_commerce/features/products/presentation/pages/categories_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
// import '../../features/products/presentation/pages/product_list_page.dart';
// import '../../features/products/presentation/pages/product_detail_page.dart';
// import '../../features/cart/presentation/pages/cart_page.dart';
// import '../../features/checkout/presentation/pages/checkout_page.dart';
// import '../../features/orders/presentation/pages/order_history_page.dart';
// import '../../features/orders/presentation/pages/order_detail_page.dart';
import 'route_names.dart';
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();
  
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splash, // Use paths for locations
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final isAuthenticated = authState is Authenticated;
      // Allow splash screen
        if (state.matchedLocation == RouteNames.splash) {
          return null;
        }
      // Use matchedLocation to check against the PATH string
      final isLoggingIn = state.matchedLocation == RouteNames.splash ||
          state.matchedLocation == RouteNames.register;
      
      if (!isAuthenticated && !isLoggingIn) return RouteNames.login;
      if (isAuthenticated && isLoggingIn) return RouteNames.home;
      
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splash, // This allows context.goNamed(RouteNames.splash)
        builder: (context, state) => const SplashPage(),
      ),
  GoRoute(
        path: RouteNames.settings,
        name: RouteNames.settings, // This allows context.goNamed(RouteNames.splash)
        builder: (context, state) => const SettingsPage(),
      ),
 GoRoute(
        path: RouteNames.checkout,
        name: RouteNames.checkout, // This allows context.goNamed(RouteNames.splash)
        builder: (context, state) => const CheckoutPage(),
      ),
       GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
        GoRoute(
        path: RouteNames.home,
        name: RouteNames.home, // This allows context.goNamed(RouteNames.splash)
        builder: (context, state) =>   const Dashboard(),
      ),
       GoRoute(
        path: RouteNames.dashboard,
        name: RouteNames.dashboard, // This allows context.goNamed(RouteNames.dashboard)
        builder: (context, state) =>   const Dashboard(),
      ),
    GoRoute(
        path: RouteNames.cart,
        name: RouteNames.cart, // This allows context.goNamed(RouteNames.cart)
        builder: (context, state) =>   const CartPage(),
      ),

         GoRoute(
        path: RouteNames.products,
        name: RouteNames.products, // This allows context.goNamed(RouteNames.splash)
        builder: (context, state) =>  const ProductListPage(),
      ),
      GoRoute(
        path: RouteNames.register,
        name: RouteNames.register,
        builder: (context, state) => const RegisterPage(),
      ),
 GoRoute(
        path: RouteNames.otpVerification,
        name: RouteNames.otpVerification,
        builder: (context, state) {
          // final product = state.extra as Map<String, dynamic>; 

          return const OtpVerificationPage(phoneNumber: '3534534534',);
        },
      ),
 GoRoute(
        path: "${RouteNames.productDetail}/:id",
        name: RouteNames.productDetail,
        builder: (context, state) {
          final product = state.pathParameters as Map<String, dynamic>; 
          return ProductDetailPage(productId: int.parse(product['id']!));

        },
      ),




      // Example of the ShellRoute for Assem's main navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          // GoRoute(
          //   path: RouteNames.home,
          //   name: RouteNames.home,
          //   pageBuilder: (context, state) => const NoTransitionPage(
          //     child: ProductListPage(),
          //   ),
          // ),
          GoRoute(
            path: RouteNames.profile,
            name: RouteNames.profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfilePage(),
            ),
          ),
        ],
      ),
    ],
  );
}

// Main Scaffold with Bottom Navigation
class MainScaffold extends StatelessWidget {
  final Widget child;
  
  const MainScaffold({
    super.key,
    required this.child,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),

      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(RouteNames.cart);
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            final itemCount = state is CartLoaded ? state.cart!.items : 0;
            
            return Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (itemCount as int > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        itemCount > 99 ? '99+' : '$itemCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      */
    );
  }
  
  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(RouteNames.home)) return 0;
    if (location.startsWith(RouteNames.categories)) return 1;
    if (location.startsWith(RouteNames.orders)) return 2;
    if (location.startsWith(RouteNames.profile)) return 3;
    return 0;
  }
  
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(RouteNames.home);
        break;
      case 1:
        context.go(RouteNames.categories);
        break;
      case 2:
        context.go(RouteNames.orders);
        break;
      case 3:
        context.go(RouteNames.profile);
        break;
    }
  }
}

// Splash Page
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>  with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _animationController.forward();
    
    // Check auth status and navigate after 3 seconds
    _checkAuthAndNavigate();
  }
  
  Future<void> _checkAuthAndNavigate() async {
    // Wait for animation + minimum display time
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;
    
    // Check auth status
    //  context.read<AuthBloc>()
    final authState =await context.read<AuthProvider>().isLoggedIn(context);
    
    if (authState) {
      // User is logged in, go to dashboard
      // context.goNamed(RouteNames.dashboard);
      Navigator.pushNamed(context,RouteNames.login);
  //     Navigator.of(context).push(
  // MaterialPageRoute(
  //   builder: (_) =>  ProductListPage(),
  //   ),
  
  // );

    } else {
      // User is not logged in, go to login
      // context.goNamed(RouteNames.login);
       Navigator.pushNamed(context,RouteNames.login);
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.shopping_bag,
                        size: 60,
                        color: context.colors.primary,
                      ),
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // App Name
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    context.themeContext.brandConfig.brandName,
                    style: TextStyles.h2(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 48),
            
            // Loading Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}




class AppRouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Extract arguments if needed
    final args = settings.arguments;

    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
       case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
       case RouteNames.dashboard:
        return MaterialPageRoute(builder: (_) => const Dashboard());
       case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
         case RouteNames.checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutPage());
      case RouteNames.cart:
        return MaterialPageRoute(builder: (_) => const CartPage());
      case RouteNames.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
              case RouteNames.orderDetail:
               final order = settings.arguments as String;
               return MaterialPageRoute(
      builder: (_) => const ProductDetailPage(productId: 0),
    );
    // return MaterialPageRoute(
    //   builder: (_) => Track(productId: productId),
    // );
      case RouteNames.productDetail:
  // We expect the ID to be passed as an argument (int)
  if (settings.arguments is int) {
    final productId = settings.arguments as int;
    return MaterialPageRoute(
      builder: (_) => ProductDetailPage(productId: productId),
    );
  }
  // If you prefer passing it as a Map (like GoRouter did)
  if (settings.arguments is Map<String, dynamic>) {
    final args = settings.arguments as Map<String, dynamic>;
    return MaterialPageRoute(
      builder: (_) => ProductDetailPage(
        productId: int.parse(args['id'].toString()),
      ),
    );
  }


  return _errorRoute();

      case RouteNames.checkout:
        // Example: Passing a CartModel as an argument
        if (args is CartModel) {
          return MaterialPageRoute(
            builder: (_) => const CheckoutPage(),
          );
        }
        return _errorRoute();

      case RouteNames.addAddress:
        return MaterialPageRoute(builder: (_) => const AddAddressPage());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(child: Text('Page not found')),
      );
    });
  }
}