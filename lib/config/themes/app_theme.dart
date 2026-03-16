import 'package:echoemaar_commerce/config/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'brand_config.dart';

class AppTheme {
  /// Get light theme with brand configuration
  static ThemeData getLightTheme(BrandConfig brandConfig) {
    final colors = AppColors(brandConfig.colors, false);
    final typography = brandConfig.typography;
    final shapes = brandConfig.shapes;
    
    return _buildTheme(
      brandConfig: brandConfig,
      colors: colors,
      brightness: Brightness.light,
    );
  }
  
  /// Get dark theme with brand configuration
  static ThemeData getDarkTheme(BrandConfig brandConfig) {
    final colors = AppColors(brandConfig.colors, true);
    
    return _buildTheme(
      brandConfig: brandConfig,
      colors: colors,
      brightness: Brightness.dark,
    );
  }
  
  static ThemeData _buildTheme({
    required BrandConfig brandConfig,
    required AppColors colors,
    required Brightness brightness,
  }) {
    final isDark = brightness == Brightness.dark;
    final typography = brandConfig.typography;
    final shapes = brandConfig.shapes;
    
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        onPrimary: Colors.white,
        primaryContainer: colors.primaryLight,
        onPrimaryContainer: colors.primary,
        secondary: colors.secondary,
        onSecondary: Colors.white,
        secondaryContainer: colors.brandColors.secondaryLight,
        onSecondaryContainer: colors.brandColors.secondaryDark,
        tertiary: colors.accent,
        onTertiary: Colors.white,
        error: colors.error,
        onError: Colors.white,
        errorContainer: colors.error.withOpacity(0.1),
        onErrorContainer: colors.error,
        surface: colors.surface,
        onSurface: colors.textPrimary,
        surfaceVariant: colors.surfaceVariant,
        onSurfaceVariant: colors.textSecondary,
        outline: colors.border,
        shadow: colors.shadow,
      ),
      
      scaffoldBackgroundColor: colors.background,
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colors.textPrimary),
        titleTextStyle: TextStyle(
          fontFamily: typography.fontFamily,
          fontSize: 20 * typography.headingScale,
          fontWeight: typography.headingWeight,
          color: colors.textPrimary,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: colors.surface,
          systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: typography.fontFamily,
          fontSize: 32 * typography.headingScale,
          fontWeight: typography.headingWeight,
          color: colors.textPrimary,
          height: 1.2,
        ),
        displayMedium: TextStyle(
          fontFamily: typography.fontFamily,
          fontSize: 24 * typography.headingScale,
          fontWeight: typography.headingWeight,
          color: colors.textPrimary,
          height: 1.3,
        ),
        displaySmall: TextStyle(
          fontFamily: typography.fontFamily,
          fontSize: 20 * typography.headingScale,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          height: 1.4,
        ),
        headlineMedium: TextStyle(
          fontFamily: typography.fontFamily,
          fontSize: 18 * typography.headingScale,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          height: 1.4,
        ),
        bodyLarge: TextStyle(
          fontFamily: typography.fontFamily,
          fontSize: 16 * typography.bodyScale,
          fontWeight: typography.bodyWeight,
          color: colors.textPrimary,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: typography.fontFamily,
          fontSize: 14 * typography.bodyScale,
          fontWeight: typography.bodyWeight,
          color: colors.textPrimary,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontFamily: typography.fontFamily,
          fontSize: 12 * typography.bodyScale,
          fontWeight: typography.bodyWeight,
          color: colors.textSecondary,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          fontFamily: typography.fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.25,
        ),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(shapes.borderRadiusSmall),
          ),
          textStyle: TextStyle(
            fontFamily: typography.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.25,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(shapes.borderRadiusSmall),
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.inputBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(shapes.borderRadiusSmall),
          borderSide: BorderSide(color: colors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(shapes.borderRadiusSmall),
          borderSide: BorderSide(color: colors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(shapes.borderRadiusSmall),
          borderSide: BorderSide(color: colors.inputFocusedBorder, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(shapes.borderRadiusSmall),
          borderSide: BorderSide(color: colors.error),
        ),
        hintStyle: TextStyle(color: colors.textHint),
        labelStyle: TextStyle(color: colors.textSecondary),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: colors.cardBackground,
        elevation: 2,
        shadowColor: colors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(shapes.borderRadiusMedium),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surface,
        selectedItemColor: colors.primary,
        unselectedItemColor: colors.textSecondary,
        selectedLabelStyle: TextStyle(
          fontFamily: typography.fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: typography.fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // FAB Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
        space: 1,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceVariant,
        selectedColor: colors.primary,
        labelStyle: TextStyle(
          fontFamily: typography.fontFamily,
          fontSize: 12 * typography.bodyScale,
          color: colors.textPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(shapes.borderRadiusLarge),
        ),
      ),
    );
  }
}