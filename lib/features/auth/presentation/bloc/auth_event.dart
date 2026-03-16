part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}

class RegisterEvent extends AuthEvent {
  final BuildContext context;
  final String name;
  final String email;
  final String password;
  
  const RegisterEvent({
     required this.context,
    required this.name,
    required this.email,
    required this.password,
  });
  
  @override
  List<Object> get props => [name, email,password];
}
class LoginWithEmailEvent extends AuthEvent {
  final BuildContext context;
  final String email;
  final String password;
  
  const LoginWithEmailEvent(
    this.context,
    this.email, this.password);
  
  @override
  List<Object> get props => [email, password];
}
class SendOtpEvent extends AuthEvent {
  final String phoneNumber;
  
  const SendOtpEvent(this.phoneNumber);
  
  @override
  List<Object> get props => [phoneNumber];
}

class VerifyOtpEvent extends AuthEvent {
  final String phoneNumber;
  final String otp;
  
  const VerifyOtpEvent({
    required this.phoneNumber,
    required this.otp,
  });
  
  @override
  List<Object> get props => [phoneNumber, otp];
}

class LogoutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}

class ResendOtpEvent extends AuthEvent {
  final String phoneNumber;
  
  const ResendOtpEvent(this.phoneNumber);
  
  @override
  List<Object> get props => [phoneNumber];
}