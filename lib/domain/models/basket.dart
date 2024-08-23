import 'package:freezed_annotation/freezed_annotation.dart';

import 'dish.dart';

part 'basket.freezed.dart';
part 'basket.g.dart';

@freezed
abstract class Basket with _$Basket {
  const factory Basket({
    List<Dish>? dishes,
  }) = _Basket;

  factory Basket.fromJson(Map<String, dynamic> json) => _$BasketFromJson(json);
}
