// lib/features/auth/presentation/pages/splash_page.dart
import 'package:echoemaar_commerce/config/routes/route_names.dart';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/features/auth/presentation/pages/otp_verification.dart';
import 'package:echoemaar_commerce/features/auth/presentation/providers/auth_provider.dart';
import 'package:echoemaar_commerce/shared/widgets/splash_bottom_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _animationController.forward();
    _checkAuthAndNavigate();
  }
  
  Future<void> _checkAuthAndNavigate() async {
    // الانتظار لعرض اللوجو والأنميشن
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;
    
    // التحقق من حالة الدخول عبر الـ Provider
    final isLoggedIn = await context.read<AuthProvider>().isLoggedIn(context);
    
    if (isLoggedIn) {
      // إذا كان مسجل دخول، نتوجه للوحة التحكم (أو الـ OnBoarding لو أول مرة)
      Navigator.pushReplacementNamed(context, RouteNames.dashboard);


    
    } else {
      // التوجه لصفحة تسجيل الدخول
      Navigator.pushReplacementNamed(context, RouteNames.login);
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // اللون الأزرق الخاص بالهوية من الصورة
    const brandBlue = Color(0xFF1D71A4);

    return Scaffold(
      backgroundColor: brandBlue,
      body: Stack(
        children: [
          // المحتوى الرئيسي في المنتصف
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 1. Logo (صورة اللوجو الأبيض من الـ Assets)
                  Image.asset(
                    'assets/images/aqua_logo_white.png', 
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 32),
                  
                  // 2. Brand Name
                  const Text(
                    'AQUA\nARTISAN',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 3. Tagline مع الخطوط الجانبية
                  const _SplashTagline(text: 'PROFESSIONAL SANITARY\nSOLUTIONS'),
                  
                  const SizedBox(height: 60),
                  
                  // 4. الرابط البصري المتدرج (الخط الصغير في المنتصف)
                  Container(
                    width: 2,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white.withOpacity(0.5), Colors.transparent],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  const Text(
                    'REFINING THE FLOW OF LUXURY',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 5. الأيقونات السفلية (Reusable Widget)
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: SplashBottomIcons(),
          ),
        ],
      ),
    );
  }
}

// مكون فرعي للـ Tagline
class _SplashTagline extends StatelessWidget {
  final String text;
  const _SplashTagline({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 30, height: 1, color: Colors.orangeAccent),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 1),
          ),
        ),
        Container(width: 30, height: 1, color: Colors.orangeAccent),
      ],
    );
  }
}