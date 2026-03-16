import 'package:flutter/material.dart';

/// Brand Configuration - Customize this for each client
class BrandConfig {
  final String brandName;
  final String brandLogo;
  final BrandColors colors;
  final BrandTypography typography;
  final BrandShapes shapes;
  final BrandSpacing spacing;
  
  const BrandConfig({
    required this.brandName,
    required this.brandLogo,
    required this.colors,
    required this.typography,
    required this.shapes,
    required this.spacing,
  });
  
  /// Default brand configuration - Override this for each client
  static BrandConfig get defaultBrand => BrandConfig(
    brandName: ' مبادرة صدي الإعمار التجارية ',
    brandLogo: 'assets/logos/default_logo.png',
    colors: BrandColors.defaultColors,
    typography: BrandTypography.defaultTypography,
    shapes: BrandShapes.defaultShapes,
    spacing: BrandSpacing.defaultSpacing,
  );
  
  /// Example: Client A Configuration
  static BrandConfig get clientA => const BrandConfig(
    brandName: 'Fashion Store',
    brandLogo: 'assets/logos/client_a_logo.png',
    colors: BrandColors(
      primary: Color(0xFFE91E63),
      primaryDark: Color(0xFFC2185B),
      primaryLight: Color(0xFFF48FB1),
      secondary: Color(0xFF9C27B0),
      secondaryDark: Color(0xFF7B1FA2),
      secondaryLight: Color(0xFFCE93D8),//7dbfe0
      accent: Color(0xFFFF4081), primaryDim: Color( 0xFF7DBFE0) , primaryGlow:Color(0x2E1D6FA4)
      
    ),
    typography: BrandTypography.defaultTypography,
    shapes: BrandShapes.roundedShapes,
    spacing: BrandSpacing.compactSpacing,
  );
  
  /// Example: Client B Configuration
  static BrandConfig get clientB => const BrandConfig(
    brandName: 'Tech Gadgets',
    brandLogo: 'assets/logos/client_b_logo.png',
    colors: BrandColors(
      primary: Color(0xFF1D6FA4),
      primaryDark: Color(0xFF0097A7),
      primaryLight: Color(0xFF3B9DD4),
      secondary: Color(0xFFFF5722),
      secondaryDark: Color(0xFFE64A19),
      secondaryLight: Color(0xFFFF8A65),
      accent: Color(0xFF00E5FF),
       primaryDim: Color( 0xFF7DBFE0) , primaryGlow: Color(0x2E1D6FA4)
    ),
    typography: BrandTypography.modernTypography,
    shapes: BrandShapes.sharpShapes,
    spacing: BrandSpacing.spaciousSpacing,
  );
}

/// Brand Colors Configuration
class BrandColors {
  // Primary Colors
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color primaryVariant;
   final Color primaryDim; // #7dbfe0
  final  Color primaryGlow ; // rgba(29, 111, 164, 0.18
  // Secondary Colors
  final Color secondary;
  final Color secondaryDark;
  final Color secondaryLight;
  final Color secondaryVariant;
  
  // Accent Colors
  final Color accent;
  final Color accentLight;
  final Color accentDark;
  
  // Semantic Colors (Optional - can be same for all brands)
  final Color error;
  final Color warning;
  final Color success;
  final Color info;
  // final Color
  const BrandColors({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    Color? primaryVariant,
    required this.secondary,
    required this.secondaryDark,
    required this.secondaryLight,
    Color? secondaryVariant,
    required this.accent,
    Color? accentLight,
    Color? accentDark,
    this.error = const Color(0xFFF44336),
    this.warning = const Color(0xFFFF9800),
    this.success = const Color(0xFF4CAF50),
    this.info = const Color(0xFF2196F3), required this.primaryDim, required this.primaryGlow,
  })  : primaryVariant = primaryVariant ?? primaryLight,
        secondaryVariant = secondaryVariant ?? secondaryLight,
        accentLight = accentLight ?? accent,
        accentDark = accentDark ?? accent;
  
  static BrandColors get defaultColors => const BrandColors(
    primary: Color(0xFF1D6FA4),
    primaryDark: Color(0xFF1D6FA4),
    primaryLight: Color(0xFF3B9DD4),
    secondary: Color(0xFFE05C2A),
    secondaryDark: Color(0xFFF57C00),
    secondaryLight: Color(0xFFFFB74D),
    accent: Color(0xFF4CAF50), primaryDim: Color( 0xFF7DBFE0) , primaryGlow: Color(0x2E1D6FA4)
  );
}

/// Brand Typography Configuration
class BrandTypography {
  final String fontFamily;
  final String? fontFamilySecondary;
  final double headingScale;
  final double bodyScale;
  final FontWeight headingWeight;
  final FontWeight bodyWeight;
  
  const BrandTypography({
    required this.fontFamily,
    this.fontFamilySecondary,
    this.headingScale = 1.0,
    this.bodyScale = 1.0,
    this.headingWeight = FontWeight.bold,
    this.bodyWeight = FontWeight.normal,
  });
  
  static const BrandTypography defaultTypography = BrandTypography(
    fontFamily: 'Roboto',
  );
  
  static const BrandTypography modernTypography = BrandTypography(
    fontFamily: 'Inter',
    fontFamilySecondary: 'Poppins',
    headingScale: 1.1,
    headingWeight: FontWeight.w700,
  );
  
  static const BrandTypography classicTypography = BrandTypography(
    fontFamily: 'Merriweather',
    fontFamilySecondary: 'Open Sans',
    headingScale: 0.95,
    headingWeight: FontWeight.w600,
  );
}

/// Brand Shapes Configuration
class BrandShapes {
  final double borderRadiusSmall;
  final double borderRadiusMedium;
  final double borderRadiusLarge;
  final double borderRadiusXLarge;
  
  const BrandShapes({
    required this.borderRadiusSmall,
    required this.borderRadiusMedium,
    required this.borderRadiusLarge,
    required this.borderRadiusXLarge,
  });
  
  static const BrandShapes defaultShapes = BrandShapes(
    borderRadiusSmall: 8.0,
    borderRadiusMedium: 12.0,
    borderRadiusLarge: 16.0,
    borderRadiusXLarge: 24.0,
  );
  
  static const BrandShapes roundedShapes = BrandShapes(
    borderRadiusSmall: 12.0,
    borderRadiusMedium: 16.0,
    borderRadiusLarge: 24.0,
    borderRadiusXLarge: 32.0,
  );
  
  static const BrandShapes sharpShapes = BrandShapes(
    borderRadiusSmall: 4.0,
    borderRadiusMedium: 6.0,
    borderRadiusLarge: 8.0,
    borderRadiusXLarge: 12.0,
  );
}

/// Brand Spacing Configuration
class BrandSpacing {
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  
  const BrandSpacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });
  
  static const BrandSpacing defaultSpacing = BrandSpacing(
    xs: 4.0,
    sm: 8.0,
    md: 16.0,
    lg: 24.0,
    xl: 32.0,
    xxl: 48.0,
  );
  
  static const BrandSpacing compactSpacing = BrandSpacing(
    xs: 2.0,
    sm: 4.0,
    md: 8.0,
    lg: 16.0,
    xl: 24.0,
    xxl: 32.0,
  );
  
  static const BrandSpacing spaciousSpacing = BrandSpacing(
    xs: 6.0,
    sm: 12.0,
    md: 20.0,
    lg: 32.0,
    xl: 48.0,
    xxl: 64.0,
  );
}




