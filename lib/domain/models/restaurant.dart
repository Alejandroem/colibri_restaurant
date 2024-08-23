import 'package:freezed_annotation/freezed_annotation.dart';

import 'location_point.dart';

part 'restaurant.freezed.dart';
part 'restaurant.g.dart'; // Generated file for JSON serialization

@freezed
class Restaurant with _$Restaurant {
  const factory Restaurant({
    required String? id,
    required String coverImage,
    required String name,
    required List<String> typeOfFood,
    required double averagePrice,
    required LocationPoint location,
  }) = _Restaurant;

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);
}
