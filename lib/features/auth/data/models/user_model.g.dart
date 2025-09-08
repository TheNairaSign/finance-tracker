// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  uid: json['uid'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String,
  photoURL: json['photoURL'] as String?,
  balance: (json['balance'] as num?)?.toDouble(),
  budget: (json['budget'] as num?)?.toDouble(),
  lastSignIn: json['lastSignIn'] == null
      ? null
      : DateTime.parse(json['lastSignIn'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoURL': instance.photoURL,
      'balance': instance.balance,
      'budget': instance.budget,
      'lastSignIn': instance.lastSignIn?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
