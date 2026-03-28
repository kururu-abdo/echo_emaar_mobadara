import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import '../providers/auth_provider.dart';
import 'package:echoemaar_commerce/features/auth/presentation/pages/register_page.dart';
import 'package:echoemaar_commerce/features/home/presentation/pages/dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    var authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // خلفية فاتحة مائلة للزرقة حسب الصورة
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              // 1. Logo & Brand Name
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                      ),
                      child: const Icon(Icons.water_drop, color: Color(0xFF004D7A), size: 40),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'AQUA ARTISAN',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D7A),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Enter your credentials to access your architectural space.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 2. Email Field
              _buildLabel('EMAIL OR PHONE'),
              _buildCustomField(
                controller: _emailController,
                hint: 'Enter your email or phone',
                suffixIcon: Icons.email_outlined,
              ),

              const SizedBox(height: 20),

              // 3. Password Field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel('PASSWORD'),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Forgot Password?', 
                      style: TextStyle(color: Color(0xFF004D7A), fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
              _buildCustomField(
                controller: _passwordController,
                hint: '••••••••',
                isPassword: true,
                obscureText: !_isPasswordVisible,
                suffixIcon: _isPasswordVisible ? Icons.visibility : Icons.visibility_off_outlined,
                onSuffixTap: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),

              const SizedBox(height: 32),

              // 4. Sign In Button (Gradient)
              _buildGradientButton(
                label: 'Sign In',
                isLoading: authProvider.isLoading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    authProvider.login(context, _emailController.text.trim(), _passwordController.text.trim());
                  }
                },
              ),

              // const SizedBox(height: 32),
              // _buildSocialDivider(),
              // const SizedBox(height: 24),

              // // 5. Social Buttons (Google & Apple)
              // Row(
              //   children: [
              //     Expanded(child: _buildSocialSmallButton('Google', 'assets/icons/google.png')), // تأكد من إضافة الأيقونات
              //     const SizedBox(width: 16),
              //     Expanded(child: _buildSocialSmallButton('Apple', Icons.apple)),
              //   ],
              // ),

              const SizedBox(height: 32),

              // 6. Footer
              _buildRegisterRedirect(),
              
              const SizedBox(height: 40),
              const Text(
                '© 2024 AQUA ARTISAN SYSTEMS. PURE FLOW EXCELLENCE.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets المخصصة بناءً على التصميم الجديد ---

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
    );
  }

  Widget _buildCustomField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    bool obscureText = false,
    required IconData suffixIcon,
    VoidCallback? onSuffixTap,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        suffixIcon: GestureDetector(
          onTap: onSuffixTap,
          child: Icon(suffixIcon, color: Colors.grey, size: 20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildGradientButton({required String label, required bool isLoading, required VoidCallback onTap}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient:  LinearGradient(
          colors: [Theme.of(context).primaryColor, Theme.of(context).colorScheme.onSurface], // تدرج برتقالي حسب التصميم
        ),
        boxShadow: [
          BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: isLoading 
          ? const CircularProgressIndicator(color: Colors.white)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
      ),
    );
  }

  Widget _buildSocialSmallButton(String label, dynamic icon) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon is IconData ? Icon(icon, color: Colors.black) : Image.asset(icon as String, height: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSocialDivider() {
    return const Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('OR CONTINUE WITH', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildRegisterRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? ", style: TextStyle(color: Colors.black87)),
        GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const RegisterPage())),
          child:  Text('Sign Up', 
            style: TextStyle(color:Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}