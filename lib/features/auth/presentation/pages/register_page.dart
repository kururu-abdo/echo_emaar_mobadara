import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/utilities/size_utils.dart';
import 'package:echoemaar_commerce/core/utilities/typography_utils.dart';
import 'package:echoemaar_commerce/core/utilities/validators.dart';
import 'package:echoemaar_commerce/core/widgets/custom_button.dart';
import 'package:echoemaar_commerce/features/auth/presentation/providers/auth_provider.dart';
import 'package:echoemaar_commerce/features/auth/presentation/widgets/auth_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/international_phone_input.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../bloc/auth_bloc.dart';

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
  final _confirmPasswordController = TextEditingController();

  final String _initialCountry = 'SA'; // Default to Saudi Arabia for ORISA/ECHO
  PhoneNumber _number = PhoneNumber(isoCode: 'SA');

  @override
  Widget build(BuildContext context) {
    final colors = context.colors; //
var authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: colors.background, //
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: context.spacing.pagePadding(context), //
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create Account',
                  style: context.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Fill your information below or register with your social account.',
                  style: context.textTheme.bodyMedium, //
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
        
                // 1. Name Field (Outlined)
                _buildLabel('Name'),
                _buildOutlinedField(
                  controller: _nameController,
                  hint: 'Krish Shah',
                  validator: (v) => v!.isEmpty ? 'Name is required' : null,
                ),
        
                const SizedBox(height: 20),
        
                // 2. Phone Number Field (Required with Country Picker)
                _buildLabel('Phone Number'),
                _buildPhoneInput(context),
        
                const SizedBox(height: 20),
        
                // 3. Email Field (Optional)
                _buildLabel('Email (Optional)'),
                _buildOutlinedField(
                  controller: _emailController,
                  hint: 'example@gmail.com',
                  keyboardType: TextInputType.emailAddress,
                ),
        
                const SizedBox(height: 20),
        
                // 4. Password Fields
                _buildLabel('Password'),
                _buildOutlinedField(
                  controller: _passwordController,
                  hint: '••••••••••••',
                  isPassword: true,
                ),
        
                const SizedBox(height: 20),
        
                _buildLabel('Confirm Password'),
                _buildOutlinedField(
                  controller: _confirmPasswordController,
                  hint: '••••••••••••',
                  isPassword: true,
                  validator: (v) => v != _passwordController.text ? 'Passwords do not match' : null,
                ),
        
                const SizedBox(height: 32),
        
                // 5. Scaling Sign Up Button
                AppButton(
                  label: 'Sign up',
                  onTap: _handleSignUp,
                ),
        
                const SizedBox(height: 24),
                // _buildSocialDivider(),
                // const SizedBox(height: 24),
        
                // // 6. Social Buttons
                // _buildSocialButton(Icons.g_mobiledata, 'Continue with Google', Colors.white, Colors.black),
                // const SizedBox(height: 16),
                // _buildSocialButton(Icons.apple, 'Continue with Apple', Colors.black, Colors.white),
        
                // const SizedBox(height: 32),
                _buildLoginRedirect(),
              ],
            ),
          ),
        ),
      ),
    );

  }

  // --- Helper Widgets ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(text, style: context.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildOutlinedField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: isPassword ? const Icon(Icons.visibility_off_outlined, size: 20) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), //
      ),
    );
  }

  Widget _buildPhoneInput(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber number) => _number = number,
        initialValue: _number,
        textFieldController: _phoneController,
        selectorConfig: const SelectorConfig(selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        formatInput: true,
        inputDecoration: const InputDecoration(border: InputBorder.none, hintText: '50 000 0000'),
      ),
    );
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(RegisterEvent(
        context: context,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        // Pass phone from _number.phoneNumber
      ));
    }
  }

  // ... (Social button & Divider helper methods)

  Widget _buildSocialDivider() {
  final colors = context.colors; //
  
  return Row(
    children: [
      Expanded(child: Divider(color: colors.border, thickness: 1)), //
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Or sign up with',
          style: context.textTheme.bodySmall!.copyWith(color: colors.textSecondary), //
        ),
      ),
      Expanded(child: Divider(color: colors.border, thickness: 1)),
    ],
  );
}

Widget _buildSocialButton(
  IconData icon, 
  String label, 
  Color bgColor, 
  Color textColor,
) {
  final shapes = context.shapes; //

  return SizedBox(
    height: 56,
    child: OutlinedButton(
      onPressed: () {
        // Handle Social Auth via Bloc/Provider
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        side: BorderSide(color: context.colors.border), //
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(shapes.borderRadiusMedium), //
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}

Widget _buildLoginRedirect() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Already have an account? ',
        style: context.textTheme.bodyMedium, //
      ),
      GestureDetector(
        onTap: () => context.goNamed('/login'), // Using GoRouter as requested
        child: Text(
          'Login',
          style: context.textTheme.bodyMedium!.copyWith(
            color: context.colors.primary, // #1d6fa4
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}
}