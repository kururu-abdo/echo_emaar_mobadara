import 'package:flutter/material.dart';

class SizeUtils {
  /// Get percentage of screen width
  static double widthPercent(BuildContext context, double percent) {
    return MediaQuery.of(context).size.width * (percent / 100);
  }
  
  /// Get percentage of screen height
  static double heightPercent(BuildContext context, double percent) {
    return MediaQuery.of(context).size.height * (percent / 100);
  }
  
  /// Get size based on smallest dimension (width or height)
  static double getSize(BuildContext context, double percent) {
    final size = MediaQuery.of(context).size;
    final smallest = size.width < size.height ? size.width : size.height;
    return smallest * (percent / 100);
  }
  
  /// Get adaptive size (scales based on screen size)
  static double getAdaptiveSize(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < 600) return mobile;
    if (width < 1024) return tablet ?? mobile * 1.2;
    return desktop ?? mobile * 1.5;
  }
  
  /// Get icon size based on device
  static double getIconSize(BuildContext context, {
    double mobile = 24,
    double? tablet,
    double? desktop,
  }) {
    return getAdaptiveSize(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
  
  /// Get button height based on device
  static double getButtonHeight(BuildContext context, {
    double mobile = 48,
    double? tablet,
    double? desktop,
  }) {
    return getAdaptiveSize(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}

/// Extension on BuildContext for size utilities
extension SizeExtension on BuildContext {
  /// Get percentage of screen width
  double widthPercent(double percent) => SizeUtils.widthPercent(this, percent);
  
  /// Get percentage of screen height
  double heightPercent(double percent) => SizeUtils.heightPercent(this, percent);
  
  /// Get adaptive size
  double adaptiveSize({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return SizeUtils.getAdaptiveSize(
      this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
  
  /// Get adaptive icon size
  double iconSize({
    double mobile = 24,
    double? tablet,
    double? desktop,
  }) {
    return SizeUtils.getIconSize(
      this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
  
  /// Get adaptive button height
  double buttonHeight({
    double mobile = 48,
    double? tablet,
    double? desktop,
  }) {
    return SizeUtils.getButtonHeight(
      this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}