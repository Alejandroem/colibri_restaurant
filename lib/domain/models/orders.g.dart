// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
      id: json['id'] as String,
      status: $enumDecode(_$OrderStatusEnumMap, json['status']),
      isActive: json['isActive'] as bool,
      restaurantName: json['restaurantName'] as String,
      restaurantId: json['restaurantId'] as String,
      customerId: json['customerId'] as String,
      driverId: json['driverId'] as String?,
      dishes: (json['dishes'] as List<dynamic>)
          .map((e) => Dish.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      restaurantLocation: LocationPoint.fromJson(
          json['restaurantLocation'] as Map<String, dynamic>),
      driverLocation: json['driverLocation'] == null
          ? null
          : LocationPoint.fromJson(
              json['driverLocation'] as Map<String, dynamic>),
      customerLocation: LocationPoint.fromJson(
          json['customerLocation'] as Map<String, dynamic>),
      statusHistory: (json['statusHistory'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$OrderStatusEnumMap, k), DateTime.parse(e as String)),
      ),
    );

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'isActive': instance.isActive,
      'restaurantName': instance.restaurantName,
      'restaurantId': instance.restaurantId,
      'customerId': instance.customerId,
      'driverId': instance.driverId,
      'dishes': instance.dishes,
      'totalPrice': instance.totalPrice,
      'restaurantLocation': instance.restaurantLocation,
      'driverLocation': instance.driverLocation,
      'customerLocation': instance.customerLocation,
      'statusHistory': instance.statusHistory.map(
          (k, e) => MapEntry(_$OrderStatusEnumMap[k]!, e.toIso8601String())),
    };

const _$OrderStatusEnumMap = {
  OrderStatus.placed: 'placed',
  OrderStatus.preparing: 'preparing',
  OrderStatus.pendingdriver: 'pendingdriver',
  OrderStatus.driverpickingup: 'driverpickingup',
  OrderStatus.ontheway: 'ontheway',
  OrderStatus.delivered: 'delivered',
  OrderStatus.cancelled: 'cancelled',
};
