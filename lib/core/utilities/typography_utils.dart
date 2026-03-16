import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:flutter/material.dart';

class TypographyUtils {
  /// Scale text based on screen size
  static double getScaledFontSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < 360) return baseSize * 0.9;
    if (width < 400) return baseSize * 0.95;
    if (width < 600) return baseSize;
    if (width < 1024) return baseSize * 1.05;
    return baseSize * 1.1;
  }
  
  /// Get text style with custom properties
  static TextStyle getTextStyle(
    BuildContext context, {
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: getScaledFontSize(context, fontSize),
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );
  }
}

/// Text style presets
class TextStyles {
  /// Heading styles
  static TextStyle h1(BuildContext context, {Color? color}) {
    return context.textTheme.displayLarge!.copyWith(color: color);
  }
  
  static TextStyle h2(BuildContext context, {Color? color}) {
    return context.textTheme.displayMedium!.copyWith(color: color);
  }
  
  static TextStyle h3(BuildContext context, {Color? color}) {
    return context.textTheme.displaySmall!.copyWith(color: color);
  }
  
  static TextStyle h4(BuildContext context, {Color? color}) {
    return context.textTheme.headlineMedium!.copyWith(color: color);
  }
  
  /// Body styles
  static TextStyle bodyLarge(BuildContext context, {Color? color}) {
    return context.textTheme.bodyLarge!.copyWith(color: color);
  }
  
  static TextStyle bodyMedium(BuildContext context, {Color? color}) {
    return context.textTheme.bodyMedium!.copyWith(color: color);
  }
  
  static TextStyle bodySmall(BuildContext context, {Color? color}) {
    return context.textTheme.bodySmall!.copyWith(color: color);
  }
  
  /// Special styles
  static TextStyle price(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: TypographyUtils.getScaledFontSize(context, 20),
      fontWeight: FontWeight.bold,
      color: color ?? context.colors.primary,
    );
  }
  
  static TextStyle priceStrikethrough(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: TypographyUtils.getScaledFontSize(context, 14),
      fontWeight: FontWeight.normal,
      color: color ?? context.colors.textSecondary,
      decoration: TextDecoration.lineThrough,
    );
  }
  
  static TextStyle button(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: TypographyUtils.getScaledFontSize(context, 14),
      fontWeight: FontWeight.w600,
      letterSpacing: 1.25,
      color: color,
    );
  }
  
  static TextStyle caption(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: TypographyUtils.getScaledFontSize(context, 12),
      fontWeight: FontWeight.normal,
      color: color ?? context.colors.textSecondary,
    );
  }
}