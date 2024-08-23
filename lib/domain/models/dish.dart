import 'package:freezed_annotation/freezed_annotation.dart';

import 'ingredient.dart';

part 'dish.freezed.dart';
part 'dish.g.dart';

@freezed
class Dish with _$Dish {
  const factory Dish({
    required String id,
    required String restaurantId,
    required String name,
    required String description,
    required double price,
    required List<String> images,
    required List<Ingredient> baseIngredients,
    required List<Ingredient> extraIngredients,
    required List<Ingredient> removableIngredients,
    int? quantity,
  }) = _Dish;

  factory Dish.fromJson(Map<String, dynamic> json) => _$DishFromJson(json);
}
