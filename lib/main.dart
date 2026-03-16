import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'injection_container.dart' as di;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'config/themes/theme_provider.dart';
import 'config/themes/brand_config.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
  // Initialize Firebase
  // await Firebase.initializeApp();
  
  // Initialize Hive
try {
    await Hive.initFlutter();
    await Hive.openBox('cart');
  await Hive.openBox('products_cache');
  await Hive.openBox('categories_cache');
} catch (e) {
  log(  'Error initializing Hive: $e');
}
  // Initialize dependency injection
  try {
    await di.init();
  } catch (e) {
    log(e.toString());
  }
  
  // Set preferred orientations (can be changed based on requirements)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize theme provider
  final themeProvider = ThemeProvider();
  
  // SET YOUR BRAND CONFIGURATION HERE
  // For default brand:
  themeProvider.setBrandConfig(BrandConfig.defaultBrand);
  
  // For Client A:
  // themeProvider.setBrandConfig(BrandConfig.clientA);
  
  // For Client B:
  // themeProvider.setBrandConfig(BrandConfig.clientB);
  
  // Or create a custom brand:
  // themeProvider.setBrandConfig(BrandConfig(
  //   brandName: 'My Custom Brand',
  //   brandLogo: 'assets/logos/my_logo.png',
  //   colors: BrandColors(...),
  //   typography: BrandTypography(...),
  //   shapes: BrandShapes(...),
  //   spacing: BrandSpacing(...),
  // ));
  
  runApp(
     EasyLocalization(
      supportedLocales: const [
        Locale('en'),  // English
        Locale('ar'),  // Arabic
      ],
      path: 'assets/translations', // Path to translation files
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: ChangeNotifierProvider.value(
        value: themeProvider,
        child: const MyApp(),
      ),
    ),
  );
}