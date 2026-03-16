import 'package:flutter/material.dart';

class ColorUtils {
  /// Darken a color by percentage (0.0 to 1.0)
  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    
    return hslDark.toColor();
  }
  
  /// Lighten a color by percentage (0.0 to 1.0)
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    
    return hslLight.toColor();
  }
  
  /// Get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
  
  /// Check if color is dark
  static bool isDark(Color color) {
    return color.computeLuminance() < 0.5;
  }
  
  /// Check if color is light
  static bool isLight(Color color) {
    return color.computeLuminance() >= 0.5;
  }
  
  /// Get contrasting color (black or white)
  static Color getContrastingColor(Color color) {
    return isDark(color) ? Colors.white : Colors.black;
  }
  
  /// Convert hex string to color
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
  
  /// Convert color to hex string
  static String toHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }
  
  /// Blend two colors
  static Color blend(Color color1, Color color2, [double ratio = 0.5]) {
    return Color.lerp(color1, color2, ratio)!;
  }
  
  /// Create gradient from single color
  static LinearGradient createGradient(Color color, {
    double darkenAmount = 0.2,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      colors: [color, darken(color, darkenAmount)],
      begin: begin,
      end: end,
    );
  }
}

/// Extension on Color class
extension ColorExtension on Color {
  /// Darken color
  Color darken([double amount = 0.1]) => ColorUtils.darken(this, amount);
  
  /// Lighten color
  Color lighten([double amount = 0.1]) => ColorUtils.lighten(this, amount);
  
  /// Check if dark
  bool get isDark => ColorUtils.isDark(this);
  
  /// Check if light
  bool get isLight => ColorUtils.isLight(this);
  
  /// Get contrasting color
  Color get contrastingColor => ColorUtils.getContrastingColor(this);
  
  /// Convert to hex
  String get toHex => ColorUtils.toHex(this);
  
  /// Create gradient
  LinearGradient toGradient({
    double darkenAmount = 0.2,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return ColorUtils.createGradient(
      this,
      darkenAmount: darkenAmount,
      begin: begin,
      end: end,
    );
  }
}