import 'package:easy_localization/easy_localization.dart';
import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:echoemaar_commerce/core/utilities/size_utils.dart';
import 'package:echoemaar_commerce/core/utilities/typography_utils.dart';
import 'package:echoemaar_commerce/core/utilities/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../bloc/auth_bloc.dart';
import '../providers/auth_provider.dart';
import '../widgets/international_phone_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  
  String _phoneNumber = '';
  String _countryCode = '+1';
  
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
  
  void _onPhoneNumberChanged(PhoneNumber number) {
    setState(() {
      _phoneNumber = number.phoneNumber ?? '';
      _countryCode = number.dialCode ?? '+1';
    });
  }
  
  void _handleSendOtp() {
    if (_formKey.currentState!.validate()) {
      // context.read<AuthBloc>().add(LoginWithEmailEvent(
      //   context,
      //   _emailController.text.trim(),_passwordController.text.trim()));

   context.read<AuthProvider>().login(context,
        _emailController.text.trim(),_passwordController.text.trim());

    }
  }
  
  final TextEditingController  _emailController = TextEditingController();

  final TextEditingController  _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is OtpSent) {
              // Navigate to OTP verification
              Navigator.of(context).pushNamed(
                '/otp-verification',
                arguments: state.phoneNumber,
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
                  SizedBox(height: context.heightPercent(10)),
                  
                  // Logo
                  Icon(
                    Icons.shopping_bag,
                    size: 100,
                    color: context.colors.primary,
                  ),
                  
                  context.spacing.verticalXL,
                  
                  Text(
                   'auth.welcome_back'.tr()
                    // 'Welcome Back'
                    ,
                    style: TextStyles.h1(context),
                    textAlign: TextAlign.center,
                  ),
                  
                  context.spacing.verticalSM,
                  
                  Text(
                    'Sign in with your phone number',
                    style: TextStyles.bodyMedium(context).copyWith(
                      color: context.colors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  context.spacing.verticalXXL,
                
                  // Phone Number Input

                  /*
                  InternationalPhoneInput(
                    controller: _phoneController,
                    onInputChanged: _onPhoneNumberChanged,
                    initialCountryCode: 'SA',
                    validator: (value) => Validators.validateInternationalPhone(
                      value,
                      _countryCode,
                    ),
                  ),
                  */

TextFormField(
  controller: _emailController,
decoration:  InputDecoration(
  hintText: 'auth.email'.tr(), 
  
),
// validator:(value)=> Validators.validateEmail(value),
), 


    context.spacing.verticalMD,
TextFormField(
  controller: _passwordController,
  obscureText: true,
  validator:(value)=> Validators.validateRequired(value,'Password'),
decoration:  InputDecoration(
  hintText:  'auth.password'.tr(), 
  
),
), 

                  context.spacing.verticalXL,
                  
                  // Send OTP Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = context.read<AuthProvider>().isLoading;
                      
                      return SizedBox(
                        height: context.buttonHeight(),
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleSendOtp,
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
                              :  Text( 'auth.login'.tr(), ),
                        ),
                      );
                    },
                  ),
                  
                  context.spacing.verticalXL,
                  
                  // Create Account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                       'auth.dont_have_account'.tr(),
                        style: TextStyles.bodyMedium(context),
                      ),
                      TextButton(
                        onPressed: () {
                        context.goNamed('/register');
                        },
                        child:  Text('auth.create_account'.tr()),
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