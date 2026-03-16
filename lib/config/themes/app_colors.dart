/*

import 'package:echoemaar_commerce/config/themes/brand_config.dart';
import 'package:flutter/material.dart';

/// Dynamic color system that adapts to light/dark mode
class AppColors {
  final BrandColors brandColors;
  final bool isDark;
  
  AppColors(this.brandColors, this.isDark);
  
  // Brand Colors
  Color get primary =>  brandColors.primary;
  Color get primaryDark => brandColors.primaryDark;
  Color get primaryLight => brandColors.primaryLight;
  Color get secondary => brandColors.secondary;
  Color get accent => brandColors.accent;
  // static const Color primary = Color(0xFF2196F3); 
  // static const Color secondary = Color(0xFF1976D2);
  // Background Colors (Adaptive)
  Color get background => isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
  Color get surface => isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
  Color get surfaceVariant => isDark ? const Color(0xFF2C2C2C) : const Color(0xFFFAFAFA);
  Color get surfaceContainer => isDark ? const Color(0xFF252525) : const Color(0xFFFFFFFF);
  
  // Text Colors (Adaptive)
  Color get textPrimary => isDark ? const Color(0xFFFFFFFF) : const Color(0xFF212121);
  Color get textSecondary => isDark ? const Color(0xFFB0B0B0) : const Color(0xFF757575);
  Color get textDisabled => isDark ? const Color(0xFF666666) : const Color(0xFFBDBDBD);
  Color get textHint => isDark ? const Color(0xFF808080) : const Color(0xFF9E9E9E);
  
  // Border & Divider Colors (Adaptive)
  Color get border => isDark ? const Color(0xFF3D3D3D) : const Color(0xFFE0E0E0);
  Color get divider => isDark ? const Color(0xFF2C2C2C) : const Color(0xFFBDBDBD);
  
  // Semantic Colors (Same in both modes, but can be customized)
  Color get error => brandColors.error;
  Color get warning => brandColors.warning;
  Color get success => brandColors.success;
  Color get info => brandColors.info;
  
  // Overlay Colors (Adaptive)
  Color get overlay => isDark 
      ? Colors.white.withOpacity(0.1) 
      : Colors.black.withOpacity(0.05);
  
  Color get overlayStrong => isDark 
      ? Colors.white.withOpacity(0.2) 
      : Colors.black.withOpacity(0.1);
  
  // Shadow Colors (Adaptive)
  Color get shadow => isDark 
      ? Colors.black.withOpacity(0.4) 
      : Colors.black.withOpacity(0.1);
  
  // Card Colors (Adaptive)
  Color get cardBackground => surface;
  Color get cardBorder => border;
  
  // Product Card specific
  Color get productCardBg => surface;
  Color get productCardShadow => shadow;
  Color get discountBadge => error;
  Color get saleBadge => success;
  
  // Input Colors (Adaptive)
  Color get inputBackground => isDark ? surfaceVariant : surface;
  Color get inputBorder => border;
  Color get inputFocusedBorder => primary;
  
  // Button Colors
  Color get buttonPrimary => primary;
  Color get buttonSecondary => secondary;
  Color get buttonDisabled => isDark ? const Color(0xFF3D3D3D) : const Color(0xFFE0E0E0);
  
  // Gradients
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  LinearGradient get accentGradient => LinearGradient(
    colors: [accent, accent.withOpacity(0.7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  LinearGradient get shimmerGradient => LinearGradient(
    colors: isDark
        ? [
            const Color(0xFF2C2C2C),
            const Color(0xFF3D3D3D),
            const Color(0xFF2C2C2C),
          ]
        : [
            const Color(0xFFE0E0E0),
            const Color(0xFFF5F5F5),
            const Color(0xFFE0E0E0),
          ],
    stops: const [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}


*/
import 'package:flutter/material.dart';
import 'brand_config.dart';

/// Dynamic color system that maps CSS variables to Flutter's adaptive theme
class AppColors {
  final BrandColors brandColors;
  final bool isDark;
  
  AppColors(this.brandColors, this.isDark);
  
  // --- CSS Variable Mappings ---
  
  // Brand Colors (from --clr-primary and --clr-accent)
  // rgba(29, 111, 164, 0.18)
  Color get primary => brandColors.primary; // #1d6fa4
  Color get primaryLight => brandColors.primaryLight; // #3b9dd4
  Color get primaryDim => brandColors.primaryDim; // #7dbfe0
  Color get primaryGlow => brandColors.primaryGlow; // rgba(29, 111, 164, 0.18)
  Color get accent => brandColors.accent; // #e05c2a
  Color get secondary => brandColors.secondary;
  Color get secondaryLight => brandColors.secondaryLight;
  Color get primaryDark => brandColors.primaryDark;
  Color get secondaryDark => brandColors.secondaryDark;
  
  
  

  // Background & Surfaces (Adaptive)
  // Maps to --clr-bg and --clr-card
  Color get background => isDark 
      ? const Color(0xFF0F172A) 
      : const Color(0xFFF4F7FB);
      
  Color get surface => isDark 
      ? const Color(0xFF1E293B) 
      : const Color(0xFFFFFFFF);
      
  Color get surfaceVariant => isDark 
      ? const Color(0xFF334155) 
      : const Color(0xFFE8F1F8); // Maps to --clr-img-bg
  
  // Text Colors (Adaptive)
  // Maps to --clr-text-primary, --clr-text-secondary, and --clr-text-muted
  Color get textPrimary => isDark 
      ? const Color(0xFFF8FAFC) 
      : const Color(0xFF0F1E2E);
      
  Color get textSecondary => isDark 
      ? const Color(0xFF94A3B8) 
      : const Color(0xFF4A6278);
      
  Color get textMuted => isDark 
      ? const Color(0xFF64748B) 
      : const Color(0xFF9AB0C4);
    // Text Colors (Adaptive)

  Color get textDisabled => isDark ? const Color(0xFF666666) : const Color(0xFFBDBDBD);
  Color get textHint => isDark ? const Color(0xFF808080) : const Color(0xFF9E9E9E);
  // UI Elements
  // Maps to --clr-border
  Color get border => isDark 
      ? const Color(0xFF334155) 
      : const Color(0xFFD4E4F0);
      
  Color get divider => border.withOpacity(0.5);
  
  // --- E-commerce Specific Mappings ---
  
  // Pricing & Badges
  // Maps to --clr-price and --clr-badge-bg
  Color get price => primary;
  Color get priceOld => textMuted;
  Color get badgeBg => primary;
  Color get badgeText => const Color(0xFFFFFFFF);
  Color get badgeNew => const Color(0xFF1A7D4F); // --clr-badge-new
  
  // Semantic Colors
  Color get error => brandColors.error;
  Color get warning => brandColors.warning;
  Color get success => brandColors.success;
  Color get info => primaryLight;
  
  // Interactive Elements
  Color get inputBackground => isDark ? surfaceVariant : surface;
  Color get inputBorder => border;
  Color get inputFocusedBorder => primary;
  
  Color get buttonPrimary => primary;
  Color get buttonSecondary => accent;
  Color get buttonDisabled => isDark 
      ? const Color(0xFF334155) 
      : const Color(0xFFE2E8F0);
  
  // --- Utility Getters ---
  
  Color get productCardBg => surface;
  Color get imageBackground => surfaceVariant; // --clr-img-bg
  
  // Shadow Styles (Adaptive)
  Color get shadow => isDark 
      ? Colors.black.withOpacity(0.5) 
      : const Color(0xFF1D6FA4).withOpacity(0.08);

  // Gradients for luxury visual components
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  LinearGradient get shimmerGradient => LinearGradient(
    colors: isDark
        ? [const Color(0xFF1E293B), const Color(0xFF334155), const Color(0xFF1E293B)]
        : [const Color(0xFFE2E8F0), const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
    stops: const [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );






 
  // Overlay Colors (Adaptive)
  Color get overlay => isDark 
      ? Colors.white.withOpacity(0.1) 
      : Colors.black.withOpacity(0.05);
  
  Color get overlayStrong => isDark 
      ? Colors.white.withOpacity(0.2) 
      : Colors.black.withOpacity(0.1);
  
  // Shadow Colors (Adaptive)
 
  // Card Colors (Adaptive)
  Color get cardBackground => surface;
  Color get cardBorder => border;
  
  // Product Card specific
  Color get productCardShadow => shadow;
  Color get discountBadge => error;
  Color get saleBadge => success;
  
  
  
  LinearGradient get accentGradient => LinearGradient(
    colors: [accent, accent.withOpacity(0.7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

}