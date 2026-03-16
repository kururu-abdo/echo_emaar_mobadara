class AppConstants {
  static const String appName = 'E-Commerce App';
  static const String appVersion = '1.0.0';
  
  // Pagination
  static const int productsPerPage = 20;
  static const int ordersPerPage = 10;
  
  // Cache durations
  static const Duration productCacheDuration = Duration(hours: 24);
  static const Duration categoryCacheDuration = Duration(days: 7);
  
  // Image settings
  static const double productImageQuality = 0.8;
  static const int productImageMaxWidth = 800;
  static const int productImageMaxHeight = 800;
  
  // Currency
  static const String currencySymbol = '\$';
  static const String currencyCode = 'USD';
}