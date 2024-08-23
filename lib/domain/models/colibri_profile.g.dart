// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'colibri_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ColibriProfileImpl _$$ColibriProfileImplFromJson(Map<String, dynamic> json) =>
    _$ColibriProfileImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      profilePicture: json['profilePicture'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      favoriteRestaurants: (json['favoriteRestaurants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ColibriProfileImplToJson(
        _$ColibriProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'profilePicture': instance.profilePicture,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'favoriteRestaurants': instance.favoriteRestaurants,
    };
