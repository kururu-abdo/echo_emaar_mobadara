import 'dart:developer';

import 'package:echoemaar_commerce/config/routes/route_names.dart';
import 'package:echoemaar_commerce/features/auth/domain/usecases/login_with_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/send_otp.dart';
import '../../domain/usecases/verify_otp.dart';
import '../../domain/usecases/logout.dart' hide VerifyOtpParams;
import '../../domain/usecases/get_current_user.dart';
import '../../../../core/usecases/usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUser registerUser;
  final SendOtp sendOtp;
  final VerifyOtp verifyOtp;
  final Logout logout;
  final GetCurrentUser getCurrentUser;
  final LoginWithEmail loginWithEmail;
  AuthBloc({
    required this.registerUser,
    required this.sendOtp,
    required this.verifyOtp,
    required this.logout,
    required this.getCurrentUser, required this.loginWithEmail,
  }) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<ResendOtpEvent>(_onResendOtp);
        on<LoginWithEmailEvent>(_onLoginWithEmail);

  }
  
  Future<void> _onRegister(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await registerUser(
      RegisterUserParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) {
        emit(RegistrationSuccess(user));
       event.context.goNamed('/home');
      },
    );
  }
  
  Future<void> _onSendOtp(
    SendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await sendOtp(SendOtpParams(event.phoneNumber));
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (message) => emit(OtpSent(
        phoneNumber: event.phoneNumber,
        message: message,
      )),
    );
  }
  
  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await verifyOtp(
      VerifyOtpParams(
        phoneNumber: event.phoneNumber,
        otp: event.otp,
      ),
    );
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }
  
  Future<void> _onResendOtp(
    ResendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    // Keep current state visible while resending
    final currentState = state;
    
    final result = await sendOtp(SendOtpParams(event.phoneNumber));
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (message) {
        // Show success message briefly then return to OTP screen
        emit(OtpSent(
          phoneNumber: event.phoneNumber,
          message: 'OTP resent successfully',
        ));
      },
    );
  }
  
  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await logout(NoParams());
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }
  Future<void> _onLoginWithEmail( 
    LoginWithEmailEvent event, 
    Emitter<AuthState> emit
  )async{

  emit(AuthLoading());

log('Login with email and password: ${event.email}');
final result = await loginWithEmail(LoginWithEmailParams(email: event.email, password: event.password));
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) {
       
         event.context.pushNamed(RouteNames.home);
          emit(Unauthenticated());
      },
    );

  }
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await getCurrentUser(NoParams());
    
    result.fold(
      (failure) => emit(Unauthenticated()),
      (user) {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }
}