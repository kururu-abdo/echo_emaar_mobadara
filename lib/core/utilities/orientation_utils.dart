import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrientationUtils {
  /// Lock to portrait mode
  static Future<void> lockPortrait() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  
  /// Lock to landscape mode
  static Future<void> lockLandscape() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  
  /// Allow all orientations
  static Future<void> allowAll() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  
  /// Check if in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }
  
  /// Check if in portrait mode
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }
  
  /// Get value based on orientation
  static T getOrientationValue<T>({
    required BuildContext context,
    required T portrait,
    required T landscape,
  }) {
    return isPortrait(context) ? portrait : landscape;
  }
  
  /// Get responsive columns based on orientation
  static int getOrientationColumns(BuildContext context, {
    int portrait = 2,
    int landscape = 3,
  }) {
    return getOrientationValue(
      context: context,
      portrait: portrait,
      landscape: landscape,
    );
  }
}

/// Extension on BuildContext
extension OrientationExtension on BuildContext {
  bool get isLandscape => OrientationUtils.isLandscape(this);
  bool get isPortrait => OrientationUtils.isPortrait(this);
  
  Orientation get orientation => MediaQuery.of(this).orientation;
  
  T getOrientationValue<T>({
    required T portrait,
    required T landscape,
  }) {
    return OrientationUtils.getOrientationValue(
      context: this,
      portrait: portrait,
      landscape: landscape,
    );
  }
}