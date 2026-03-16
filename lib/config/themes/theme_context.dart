import 'package:echoemaar_commerce/core/utilities/spacing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/themes/brand_config.dart';
import '../../config/themes/theme_provider.dart';
import 'app_colors.dart';

/// Theme context that provides easy access to all theme values
class ThemeContext {
  final BuildContext context;
  
  ThemeContext(this.context);
  
  /// Theme data
  ThemeData get theme => Theme.of(context);
  
  /// Theme provider
  ThemeProvider get themeProvider => context.read<ThemeProvider>();
  
  /// Brand configuration
  BrandConfig get brandConfig => themeProvider.brandConfig;
  
  /// Colors
  AppColors get colors => AppColors(
    brandConfig.colors,
    theme.brightness == Brightness.dark,
  );
  
  /// Spacing
  AppSpacing get spacing => AppSpacing(brandConfig.spacing);
  
  /// Shapes (Border Radius)
  BrandShapes get shapes => brandConfig.shapes;
  
  /// Typography
  BrandTypography get typography => brandConfig.typography;
  
  /// Text theme
  TextTheme get textTheme => theme.textTheme;
  
  /// Color scheme
  ColorScheme get colorScheme => theme.colorScheme;
  
  /// Check if dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;
  
  /// Check if light mode
  bool get isLightMode => theme.brightness == Brightness.light;
}

/// Global extension on BuildContext for easy theme access
extension ThemeExtension on BuildContext {
  /// Get theme context
  ThemeContext get themeContext => ThemeContext(this);
  
  /// Quick access to colors
  AppColors get colors {
    final provider = read<ThemeProvider>();
    return AppColors(
      provider.brandConfig.colors,
      Theme.of(this).brightness == Brightness.dark,
    );
  }
  
  /// Quick access to spacing
  AppSpacing get spacing {
    final provider = read<ThemeProvider>();
    return AppSpacing(provider.brandConfig.spacing);
  }
  
  /// Quick access to shapes
  BrandShapes get shapes {
    final provider = read<ThemeProvider>();
    return provider.brandConfig.shapes;
  }
  
  /// Quick access to typography
  BrandTypography get typography {
    final provider = read<ThemeProvider>();
    return provider.brandConfig.typography;
  }
  
  /// Quick access to text theme
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  /// Quick access to color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  /// Check if dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  
  /// Check if light mode
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;
}