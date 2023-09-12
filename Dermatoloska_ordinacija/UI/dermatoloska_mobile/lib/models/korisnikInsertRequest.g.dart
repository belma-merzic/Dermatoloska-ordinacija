// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnikInsertRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KorisnikInsertRequest _$KorisnikInsertRequestFromJson(
        Map<String, dynamic> json) =>
    KorisnikInsertRequest(
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['userName'] as String?,
      json['email'] as String?,
      json['phone'] as String?,
      json['password'] as String?,
      json['passwordConfirm'] as String?,
      json['userTypeId'] as int?,
    );

Map<String, dynamic> _$KorisnikInsertRequestToJson(
        KorisnikInsertRequest instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'userName': instance.userName,
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'passwordConfirm': instance.passwordConfirm,
      'userTypeId': instance.userTypeId,
    };
