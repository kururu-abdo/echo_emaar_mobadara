import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/utilities/size_utils.dart';
import 'package:echoemaar_commerce/core/utilities/typography_utils.dart';
import 'package:echoemaar_commerce/core/utilities/validators.dart';
import 'package:echoemaar_commerce/features/auth/presentation/widgets/auth_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/international_phone_input.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController= TextEditingController();

  String _phoneNumber = '';
  String _countryCode = '+1';
  
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  
  void _onPhoneNumberChanged(PhoneNumber number) {
    setState(() {
      _phoneNumber = number.phoneNumber ?? '';
      _countryCode = number.dialCode ?? '+1';
    });
  }
  
  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      // Extract just the number without country code
      final phoneWithoutCode = _phoneNumber.replaceFirst(_countryCode, '');
      
      context.read<AuthBloc>().add(
        RegisterEvent
        (
          context: context,
          name: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is RegistrationSuccess) {
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Registration successful! Please verify your phone.'),
                  backgroundColor: context.colors.success,
                ),
              );
              
              // Navigate to OTP page
              Navigator.of(context).pushReplacementNamed(
                '/otp-verification',
                arguments: _phoneNumber,
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: context.colors.error,
                ),
              );
            }
          },
          child: SingleChildScrollView(
            padding: context.spacing.pagePadding(context),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  context.spacing.verticalXL,
                  
                  // Logo or App Name
                  Icon(
                    Icons.shopping_bag,
                    size: 80,
                    color: context.colors.primary,
                  ),
                  
                  context.spacing.verticalLG,
                  
                  Text(
                    'Create Account',
                    style: TextStyles.h2(context),
                    textAlign: TextAlign.center,
                  ),
                  
                  context.spacing.verticalSM,
                  
                  Text(
                    'Sign up to get started',
                    style: TextStyles.bodyMedium(context).copyWith(
                      color: context.colors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  context.spacing.verticalXL,
                  
                  // Full Name Field
                  AuthTextField(
                    controller: _fullNameController,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    icon: Icons.person,
                    textCapitalization: TextCapitalization.words,
                    validator:(str)=> Validators.validateRequired(str, 'name'),
                  ),
                  
                  context.spacing.verticalMD,
                  
                  // Email Field
                  AuthTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),
                  
                  context.spacing.verticalMD,
                   AuthTextField(
                    obscureText: true,
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    icon: Icons.security,
                    keyboardType: TextInputType.emailAddress,
                    validator:(str)=> Validators.validateRequired(str, 'password')
                  ),
                  // Phone Number Field
                  // InternationalPhoneInput(
                  //   controller: _phoneController,
                  //   onInputChanged: _onPhoneNumberChanged,
                  //   validator: (value) => Validators.validateInternationalPhone(
                  //     value,
                  //     _countryCode,
                  //   ),
                  // ),
                  
                  context.spacing.verticalXL,
                  
                  // Register Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      
                      return SizedBox(
                        height: context.buttonHeight(),
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleRegister,
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text('Create Account'),
                        ),
                      );
                    },
                  ),
                  
                  context.spacing.verticalLG,
                  
                  // Already have account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyles.bodyMedium(context),
                      ),
                      TextButton(
                        onPressed: () {
                         context.goNamed('/login');
                        },
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}