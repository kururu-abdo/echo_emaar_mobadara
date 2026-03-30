// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  log('DATA : $json');
  return UserModel(
      uid: json['uid'],
      username: json['username'],
      partnerId: json['partner_id'] ,
      companyName: json['company_name'],
      email: json['email'] ,
      sessionId: json['session_id']??'' ,
    );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'partner_id': instance.partnerId,
      'username': instance.username,
      'email': instance.email,
      'company_name': instance.companyName,
      'session_id': instance.sessionId,
    };
