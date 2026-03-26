import 'dart:developer';

import 'package:echoemaar_commerce/config/routes/route_names.dart';
import 'package:echoemaar_commerce/core/widgets/app_toast.dart';
import 'package:echoemaar_commerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:echoemaar_commerce/features/auth/domain/usecases/get_current_user.dart';
import 'package:echoemaar_commerce/features/auth/domain/usecases/login_with_email.dart';
import 'package:echoemaar_commerce/features/auth/domain/usecases/logout.dart';
import 'package:echoemaar_commerce/features/auth/domain/usecases/register_user.dart';
import 'package:echoemaar_commerce/features/auth/domain/usecases/send_otp.dart';
import 'package:echoemaar_commerce/features/auth/domain/usecases/verify_otp.dart';
import 'package:echoemaar_commerce/features/home/presentation/pages/dashboard.dart';
import 'package:echoemaar_commerce/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
 final RegisterUser registerUser;
  final SendOtp sendOtp;
  final VerifyOtp verifyOtp;
  final Logout logout;
  final GetCurrentUser getCurrentUser;
  final LoginWithEmail loginWithEmail;
  AuthProvider({
    required this.registerUser,
    required this.sendOtp,
    required this.verifyOtp,
    required this.logout,
    required this.getCurrentUser, required this.loginWithEmail,
  });

bool _isLoading=false;
bool get isLoading => _isLoading;

  Future<void> login(BuildContext context, String email , String password)async{
    try {
      _isLoading= true;
      notifyListeners();
      
final result = await loginWithEmail(LoginWithEmailParams(email: email, password: password));
    
    result.fold(
      (failure) {
        log('LOGIN FAILED $failure');
  _isLoading= false;
      notifyListeners();
ToastUtils.show(context, failure.message , type: ToastType.error);     


 },
      (_) {
       log('SUCCESS Login');
        // context.pushReplacementNamed(RouteNames.home);
         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_){
return const Dashboard();
         }), (_)=>false);
           _isLoading= false;
      notifyListeners();
      },
    );



    } catch (e) {
      log(e.toString());
        _isLoading= false;
      notifyListeners();
      
    }finally{
        _isLoading= false;
      notifyListeners();
    }
  }


  Future<bool> isLoggedIn(BuildContext context)async{
    try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('CACHED_USER') != null;



    } catch (e) {
      log(e.toString());
      return false;

    }

 }
}