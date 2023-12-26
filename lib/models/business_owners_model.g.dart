// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_owners_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessOwnersModel _$BusinessOwnersModelFromJson(Map<String, dynamic> json) =>
    BusinessOwnersModel(
      id: json['id'] as int,
      userId: json['userId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      nameMarket: json['nameMarket'] as String,
      phone: json['phone'] as String,
      numberInvoice: json['numberInvoice'] as String,
      status: json['status'] as int,
      createAt: json['createAt'] as String,
    );

Map<String, dynamic> _$BusinessOwnersModelToJson(
        BusinessOwnersModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'nameMarket': instance.nameMarket,
      'phone': instance.phone,
      'numberInvoice': instance.numberInvoice,
      'status': instance.status,
      'createAt': instance.createAt,
    };
