import 'package:equatable/equatable.dart';

class User extends Equatable {
  final dynamic uid;
  final dynamic partnerId;
  final dynamic username;
  final dynamic email;
  final dynamic companyName;
  final dynamic sessionId;

  
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