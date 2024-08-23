// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RestaurantImpl _$$RestaurantImplFromJson(Map<String, dynamic> json) =>
    _$RestaurantImpl(
      id: json['id'] as String?,
      coverImage: json['coverImage'] as String,
      name: json['name'] as String,
      typeOfFood: (json['typeOfFood'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      averagePrice: (json['averagePrice'] as num).toDouble(),
      location:
          LocationPoint.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$RestaurantImplToJson(_$RestaurantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'coverImage': instance.coverImage,
      'name': instance.name,
      'typeOfFood': instance.typeOfFood,
      'averagePrice': instance.averagePrice,
      'location': instance.location,
    };
