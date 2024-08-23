import 'package:freezed_annotation/freezed_annotation.dart';

import 'dish.dart';
import 'location_point.dart';

part 'orders.freezed.dart';
part 'orders.g.dart';

enum OrderStatus {
  placed,
  preparing,
  pendingdriver,
  ontheway,
  delivered,
  cancelled,
}

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required OrderStatus status,
    required bool isActive,
    required String restaurantName,
    required String restaurantId,
    required String customerId,
    required List<Dish> dishes,
    required double totalPrice,
    required LocationPoint restaurantLocation,
    required LocationPoint? driverLocation,
    required LocationPoint customerLocation,
    required Map<OrderStatus, DateTime> statusHistory,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
