import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int uid;
  final int partnerId;
  final String username;
  final String email;
  final String? companyName;
  final String sessionId;

  
  const User({
    required this.uid,
        required this.partnerId,

    required this.username,
    required this.email,
    required this.sessionId,
   required this.companyName,
  });
  
  @override
  List<Object?> get props => [uid, username, email, companyName, sessionId];
}