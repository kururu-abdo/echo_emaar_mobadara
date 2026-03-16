import 'package:echoemaar_commerce/config/themes/brand_config.dart';

/// Environment configuration for different deployment targets
class EnvConfig {
  final String brandName;
  final String apiBaseUrl;
  final String odooDatabase;
  final BrandConfig brandConfig;
  final bool enableAnalytics;
  final bool enableCrashReporting;
  
  const EnvConfig({
    required this.brandName,
    required this.apiBaseUrl,
    required this.odooDatabase,
    required this.brandConfig,
    this.enableAnalytics = true,
    this.enableCrashReporting = true,
  });
  
  /// Development environment
  static EnvConfig get development => EnvConfig(
    brandName: 'Dev Store',
    apiBaseUrl: 'https://dev-odoo.yourcompany.com',
    odooDatabase: 'dev_database',
    brandConfig: BrandConfig.defaultBrand,
    enableAnalytics: false,
    enableCrashReporting: false,
  );
  
  /// Staging environment
  static EnvConfig get staging => EnvConfig(
    brandName: 'Staging Store',
    apiBaseUrl: 'https://staging-odoo.yourcompany.com',
    odooDatabase: 'staging_database',
    brandConfig: BrandConfig.defaultBrand,
    enableAnalytics: true,
    enableCrashReporting: true,
  );
  
  /// Production - Client A
  static EnvConfig get productionClientA => EnvConfig(
    brandName: 'Fashion Store',
    apiBaseUrl: 'https://clienta-odoo.yourcompany.com',
    odooDatabase: 'clienta_database',
    brandConfig: BrandConfig.clientA,
    enableAnalytics: true,
    enableCrashReporting: true,
  );
  
  /// Production - Client B
  static EnvConfig get productionClientB => EnvConfig(
    brandName: 'Tech Gadgets',
    apiBaseUrl: 'https://clientb-odoo.yourcompany.com',
    odooDatabase: 'clientb_database',
    brandConfig: BrandConfig.clientB,
    enableAnalytics: true,
    enableCrashReporting: true,
  );
  
  /// Current environment (change this based on build flavor)
  static EnvConfig get current {
    // You can use flutter flavors or environment variables here
    const environment = String.fromEnvironment('ENV', defaultValue: 'development');
    
    switch (environment) {
      case 'development':
        return development;
      case 'staging':
        return staging;
      case 'production_clientA':
        return productionClientA;
      case 'production_clientB':
        return productionClientB;
      default:
        return development;
    }
  }
}