import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/utilities/size_utils.dart';
import 'package:echoemaar_commerce/core/utilities/typography_utils.dart';
import 'package:echoemaar_commerce/core/utilities/validators.dart';
import 'package:echoemaar_commerce/core/widgets/custom_button.dart';
import 'package:echoemaar_commerce/features/auth/presentation/pages/register_page.dart';
import 'package:echoemaar_commerce/features/home/presentation/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import '../bloc/auth_bloc.dart';
import '../providers/auth_provider.dart';
import '../widgets/international_phone_input.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
// import '../widgets/app_button.dart'; // The scaling button we built
import 'package:easy_localization/easy_localization.dart';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
// import '../widgets/app_button.dart'; // The scaling button with primary gradient

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(); // Updated to match design
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors; //
var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: colors.background, //
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: context.spacing.pagePadding(context), //
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Title
              Text(
                'Login',
                style: context.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary, //
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // 2. Email Field
              _buildLabel('Email'),
              _buildOutlinedField(
                controller: _emailController,
                hint: 'example@gmail.com',
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              // 3. Password Field
              _buildLabel('Password'),
              _buildOutlinedField(
                controller: _passwordController,
                hint: '••••••••••••',
                isPassword: true,
              ),

              const SizedBox(height: 32),

              // 4. Scaling Login Button
              AppButton(
                label: 'Login',
                isLoading: authProvider.isLoading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                   authProvider.login(context, _emailController.text.trim(), _passwordController.text.trim());
                  }
                },
              ),

              const SizedBox(height: 24),

              // 5. Forget Password
              Center(
                child: TextButton(
                  onPressed: () {




                  }, // Navigate to Forget Password
                  child: Text(
                    'Forget Password?',
                    style: TextStyle(
                      color: colors.primary, //
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              _buildSocialDivider(),
              const SizedBox(height: 24),

              // 6. Social Buttons
              // _buildSocialButton(Icons.g_mobiledata, 'Continue with Google', Colors.white, Colors.black),
              // const SizedBox(height: 16),
              // _buildSocialButton(Icons.apple, 'Continue with Apple', Colors.black, Colors.white),
              // const SizedBox(height: 16),
              _buildSocialButton(Icons.person_outline, 'Continue as Guest', Colors.white, Colors.black ,  onTap:(){


                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=> const Dashboard()), (_)=> false);

              }),

              const SizedBox(height: 48),

              // 7. Footer Redirect
              _buildRegisterRedirect(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        text, 
        style: context.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildOutlinedField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: isPassword ? const Icon(Icons.visibility_off_outlined, size: 20) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), //
          borderSide: BorderSide(color: context.colors.border), //
        ),
      ),
    );
  }

  Widget _buildSocialDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: context.colors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Or sign up with', style: TextStyle(color: context.colors.textSecondary)),
        ),
        Expanded(child: Divider(color: context.colors.border)),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String label, Color bgColor, Color textColor ,{ 
    Function? onTap
  }) {
    return GestureDetector(
      onTap: (){
        log('route');
        onTap!();
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: textColor,
            side: BorderSide(color: context.colors.border),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account? ", style: context.textTheme.bodyMedium),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const RegisterPage()));
          },
          child: Text(
            'Sign up',
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}