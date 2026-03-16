import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required super.uid,
    required super.username, 
        required super.partnerId, 
    required super.companyName, 

    required super.email,
    required super.sessionId,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  factory UserModel.fromOdoo(Map<String, dynamic> odooData) {
    return UserModel(
      uid: odooData['uid'] as int,
      username: (odooData['name']??odooData['username']) as String,
      email: odooData['email'].toString(),
      partnerId: odooData['partner_id'] as int,
      companyName: odooData['comnpany_name']??'', 
      sessionId: odooData['session_id']??'');
    
  }
}