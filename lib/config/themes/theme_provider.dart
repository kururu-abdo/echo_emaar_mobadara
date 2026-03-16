import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'brand_config.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  BrandConfig _brandConfig = BrandConfig.defaultBrand;
  
  ThemeProvider() {
    _loadThemeMode();
  }
  
  ThemeMode get themeMode => _themeMode;
  BrandConfig get brandConfig => _brandConfig;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  ThemeData get lightTheme => AppTheme.getLightTheme(_brandConfig);
  ThemeData get darkTheme => AppTheme.getDarkTheme(_brandConfig);
  
  /// Change theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.toString());
  }
  
  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }
  
  /// Change brand configuration
  void setBrandConfig(BrandConfig config) {
    _brandConfig = config;
    notifyListeners();
  }
  
  /// Load saved theme mode
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('theme_mode');
    
    if (themeModeString != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == themeModeString,
        orElse: () => ThemeMode.light,
      );
      notifyListeners();
    }
  }
}