// lib/features/auth/presentation/pages/register_page.dart

import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/utilities/typography_utils.dart';
import 'package:echoemaar_commerce/core/widgets/custom_button.dart';
import 'package:echoemaar_commerce/features/auth/presentation/providers/auth_provider.dart';
import 'package:echoemaar_commerce/features/auth/presentation/widgets/auth_header_card.dart';
import 'package:echoemaar_commerce/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:echoemaar_commerce/features/auth/presentation/widgets/auth_label.dart';
import 'package:echoemaar_commerce/features/auth/presentation/widgets/auth_redirect_link.dart';
import 'package:echoemaar_commerce/features/auth/presentation/widgets/phone_input_field.dart';
import 'package:echoemaar_commerce/features/auth/presentation/widgets/social_auth_button.dart';
import 'package:echoemaar_commerce/features/auth/presentation/widgets/terms_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart'; // لتفعيل الـ Redirect للـ Login

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _acceptTerms = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    // تم توحيد اللون الخلفي حسب التصميم المرفق
    const bgColor = Color(0xFFF7F8FC);
var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0D417D)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'مبادرة صدى الإعمار',
          style: TextStyle(color: Color(0xFF0D417D), fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header Card (المكون الجديد)
                const AuthHeaderCard(
                  title: 'إنشاء حساب جديد',
                  subtitle: 'انضم إلينا واكتشف أفخم الأدوات الصحية لمنزلك',
                  // يمكن إضافة مسار الصورة هنا إذا كانت متوفرة في الـ assets
                  // imagePath: 'assets/images/header_bg.png',
                ),
                const SizedBox(height: 32),

                // 2. Name Field
                const AuthLabel(text: 'الاسم الكامل'),
                AuthInputField(
                  controller: _nameController,
                  hintText: 'أدخل اسمك الكامل',
                  suffixIcon: Icons.person_outline,
                  validator: (v) => v!.isEmpty ? 'الاسم مطلوب' : null,
                ),
                const SizedBox(height: 16),

                // 3. Phone Field
                const AuthLabel(text: 'رقم الهاتف'),
                /*
                AuthInputField(
                  controller: _phoneController,
                  hintText: '+966 5X XXX XXXX',
                  suffixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v!.isEmpty ? 'رقم الهاتف مطلوب' : null,
                ),
*/
                PhoneInputField(
  controller: _phoneController,
  onFullNumberSaved: (fullNumber) {
    // هذا هو الرقم الذي سترسله للـ API (مثلاً: +966501234567)
    print("Final Phone for API: $fullNumber");
    
    // أضف الرقم للـ Bloc أو الـ Provider هنا
    // context.read<AuthBloc>().add(RegisterEvent(phone: fullNumber, ...));
  },
),
                const SizedBox(height: 16),

                // 4. Email Field
                const AuthLabel(text: 'البريد الإلكتروني'),
                AuthInputField(
                  controller: _emailController,
                  hintText: 'example@domain.com',
                  suffixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  // Email is optional in the logic, no validator
                ),
                const SizedBox(height: 16),

                // 5. Password Field
                const AuthLabel(text: 'كلمة المرور'),
                AuthInputField(
                  controller: _passwordController,
                  hintText: '••••••••',
                  suffixIcon: _isPasswordVisible ? Icons.visibility : Icons.visibility_off_outlined,
                  isPassword: true,
                  obscureText: !_isPasswordVisible,
                  onSuffixTap: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  prefixIcon: Icons.lock_outline,
                ),
                const SizedBox(height: 18),

                // 6. Terms and Conditions
                TermsCheckbox(
                  value: _acceptTerms,
                  onChanged: (newValue) => setState(() => _acceptTerms = newValue!),
                ),
                const SizedBox(height: 32),

                // 7. Sign Up Button
                AppButton(
                  isLoading: authProvider.isLoading ,
                  label: 'إنشاء حساب',
                  icon: Icons.arrow_back, // السهم لليسار في العربية
                  onTap: _acceptTerms ? _handleSignUp : null, // معطل إذا لم يتم قبول الشروط
                ),
                const SizedBox(height: 32),

                // 8. Redirect and Social Buttons
                AuthRedirectLink(
                  promptText: 'لديك حساب بالفعل؟ ',
                  linkText: 'تسجيل الدخول',
                  onTap: () => context.pushNamed('/login'),
                ),
                const SizedBox(height: 24),
                
                // تم دمج الـ Divider والـ Buttons في ويدجيت واحدة
                // const SocialAuthButtons(),

                // const SizedBox(height: 48),
                // Footer
                const Center(
                  child: Text(
                    'حقوق الطبع محفوظة • 2024',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthProvider>().register( context: context,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),);
        /*
      context.read<AuthBloc>().add(RegisterEvent(
        context: context,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        // Pass phone properly formated if needed
      ));
      */
    }
  }
}