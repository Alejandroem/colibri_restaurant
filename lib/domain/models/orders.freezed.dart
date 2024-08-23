// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orders.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Order _$OrderFromJson(Map<String, dynamic> json) {
  return _Order.fromJson(json);
}

/// @nodoc
mixin _$Order {
  String get id => throw _privateConstructorUsedError;
  OrderStatus get status => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String get restaurantName => throw _privateConstructorUsedError;
  String get restaurantId => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  List<Dish> get dishes => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  LocationPoint get restaurantLocation => throw _privateConstructorUsedError;
  LocationPoint? get driverLocation => throw _privateConstructorUsedError;
  LocationPoint get customerLocation => throw _privateConstructorUsedError;
  Map<OrderStatus, DateTime> get statusHistory =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) =
      _$OrderCopyWithImpl<$Res, Order>;
  @useResult
  $Res call(
      {String id,
      OrderStatus status,
      bool isActive,
      String restaurantName,
      String restaurantId,
      String customerId,
      List<Dish> dishes,
      double totalPrice,
      LocationPoint restaurantLocation,
      LocationPoint? driverLocation,
      LocationPoint customerLocation,
      Map<OrderStatus, DateTime> statusHistory});

  $LocationPointCopyWith<$Res> get restaurantLocation;
  $LocationPointCopyWith<$Res>? get driverLocation;
  $LocationPointCopyWith<$Res> get customerLocation;
}

/// @nodoc
class _$OrderCopyWithImpl<$Res, $Val extends Order>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? isActive = null,
    Object? restaurantName = null,
    Object? restaurantId = null,
    Object? customerId = null,
    Object? dishes = null,
    Object? totalPrice = null,
    Object? restaurantLocation = null,
    Object? driverLocation = freezed,
    Object? customerLocation = null,
    Object? statusHistory = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      restaurantName: null == restaurantName
          ? _value.restaurantName
          : restaurantName // ignore: cast_nullable_to_non_nullable
              as String,
      restaurantId: null == restaurantId
          ? _value.restaurantId
          : restaurantId // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      dishes: null == dishes
          ? _value.dishes
          : dishes // ignore: cast_nullable_to_non_nullable
              as List<Dish>,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      restaurantLocation: null == restaurantLocation
          ? _value.restaurantLocation
          : restaurantLocation // ignore: cast_nullable_to_non_nullable
              as LocationPoint,
      driverLocation: freezed == driverLocation
          ? _value.driverLocation
          : driverLocation // ignore: cast_nullable_to_non_nullable
              as LocationPoint?,
      customerLocation: null == customerLocation
          ? _value.customerLocation
          : customerLocation // ignore: cast_nullable_to_non_nullable
              as LocationPoint,
      statusHistory: null == statusHistory
          ? _value.statusHistory
          : statusHistory // ignore: cast_nullable_to_non_nullable
              as Map<OrderStatus, DateTime>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LocationPointCopyWith<$Res> get restaurantLocation {
    return $LocationPointCopyWith<$Res>(_value.restaurantLocation, (value) {
      return _then(_value.copyWith(restaurantLocation: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $LocationPointCopyWith<$Res>? get driverLocation {
    if (_value.driverLocation == null) {
      return null;
    }

    return $LocationPointCopyWith<$Res>(_value.driverLocation!, (value) {
      return _then(_value.copyWith(driverLocation: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $LocationPointCopyWith<$Res> get customerLocation {
    return $LocationPointCopyWith<$Res>(_value.customerLocation, (value) {
      return _then(_value.copyWith(customerLocation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderImplCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$$OrderImplCopyWith(
          _$OrderImpl value, $Res Function(_$OrderImpl) then) =
      __$$OrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      OrderStatus status,
      bool isActive,
      String restaurantName,
      String restaurantId,
      String customerId,
      List<Dish> dishes,
      double totalPrice,
      LocationPoint restaurantLocation,
      LocationPoint? driverLocation,
      LocationPoint customerLocation,
      Map<OrderStatus, DateTime> statusHistory});

  @override
  $LocationPointCopyWith<$Res> get restaurantLocation;
  @override
  $LocationPointCopyWith<$Res>? get driverLocation;
  @override
  $LocationPointCopyWith<$Res> get customerLocation;
}

/// @nodoc
class __$$OrderImplCopyWithImpl<$Res>
    extends _$OrderCopyWithImpl<$Res, _$OrderImpl>
    implements _$$OrderImplCopyWith<$Res> {
  __$$OrderImplCopyWithImpl(
      _$OrderImpl _value, $Res Function(_$OrderImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? isActive = null,
    Object? restaurantName = null,
    Object? restaurantId = null,
    Object? customerId = null,
    Object? dishes = null,
    Object? totalPrice = null,
    Object? restaurantLocation = null,
    Object? driverLocation = freezed,
    Object? customerLocation = null,
    Object? statusHistory = null,
  }) {
    return _then(_$OrderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      restaurantName: null == restaurantName
          ? _value.restaurantName
          : restaurantName // ignore: cast_nullable_to_non_nullable
              as String,
      restaurantId: null == restaurantId
          ? _value.restaurantId
          : restaurantId // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      dishes: null == dishes
          ? _value._dishes
          : dishes // ignore: cast_nullable_to_non_nullable
              as List<Dish>,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      restaurantLocation: null == restaurantLocation
          ? _value.restaurantLocation
          : restaurantLocation // ignore: cast_nullable_to_non_nullable
              as LocationPoint,
      driverLocation: freezed == driverLocation
          ? _value.driverLocation
          : driverLocation // ignore: cast_nullable_to_non_nullable
              as LocationPoint?,
      customerLocation: null == customerLocation
          ? _value.customerLocation
          : customerLocation // ignore: cast_nullable_to_non_nullable
              as LocationPoint,
      statusHistory: null == statusHistory
          ? _value._statusHistory
          : statusHistory // ignore: cast_nullable_to_non_nullable
              as Map<OrderStatus, DateTime>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderImpl implements _Order {
  const _$OrderImpl(
      {required this.id,
      required this.status,
      required this.isActive,
      required this.restaurantName,
      required this.restaurantId,
      required this.customerId,
      required final List<Dish> dishes,
      required this.totalPrice,
      required this.restaurantLocation,
      required this.driverLocation,
      required this.customerLocation,
      required final Map<OrderStatus, DateTime> statusHistory})
      : _dishes = dishes,
        _statusHistory = statusHistory;

  factory _$OrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderImplFromJson(json);

  @override
  final String id;
  @override
  final OrderStatus status;
  @override
  final bool isActive;
  @override
  final String restaurantName;
  @override
  final String restaurantId;
  @override
  final String customerId;
  final List<Dish> _dishes;
  @override
  List<Dish> get dishes {
    if (_dishes is EqualUnmodifiableListView) return _dishes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dishes);
  }

  @override
  final double totalPrice;
  @override
  final LocationPoint restaurantLocation;
  @override
  final LocationPoint? driverLocation;
  @override
  final LocationPoint customerLocation;
  final Map<OrderStatus, DateTime> _statusHistory;
  @override
  Map<OrderStatus, DateTime> get statusHistory {
    if (_statusHistory is EqualUnmodifiableMapView) return _statusHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_statusHistory);
  }

  @override
  String toString() {
    return 'Order(id: $id, status: $status, isActive: $isActive, restaurantName: $restaurantName, restaurantId: $restaurantId, customerId: $customerId, dishes: $dishes, totalPrice: $totalPrice, restaurantLocation: $restaurantLocation, driverLocation: $driverLocation, customerLocation: $customerLocation, statusHistory: $statusHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.restaurantName, restaurantName) ||
                other.restaurantName == restaurantName) &&
            (identical(other.restaurantId, restaurantId) ||
                other.restaurantId == restaurantId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            const DeepCollectionEquality().equals(other._dishes, _dishes) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.restaurantLocation, restaurantLocation) ||
                other.restaurantLocation == restaurantLocation) &&
            (identical(other.driverLocation, driverLocation) ||
                other.driverLocation == driverLocation) &&
            (identical(other.customerLocation, customerLocation) ||
                other.customerLocation == customerLocation) &&
            const DeepCollectionEquality()
                .equals(other._statusHistory, _statusHistory));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      status,
      isActive,
      restaurantName,
      restaurantId,
      customerId,
      const DeepCollectionEquality().hash(_dishes),
      totalPrice,
      restaurantLocation,
      driverLocation,
      customerLocation,
      const DeepCollectionEquality().hash(_statusHistory));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      __$$OrderImplCopyWithImpl<_$OrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderImplToJson(
      this,
    );
  }
}

abstract class _Order implements Order {
  const factory _Order(
      {required final String id,
      required final OrderStatus status,
      required final bool isActive,
      required final String restaurantName,
      required final String restaurantId,
      required final String customerId,
      required final List<Dish> dishes,
      required final double totalPrice,
      required final LocationPoint restaurantLocation,
      required final LocationPoint? driverLocation,
      required final LocationPoint customerLocation,
      required final Map<OrderStatus, DateTime> statusHistory}) = _$OrderImpl;

  factory _Order.fromJson(Map<String, dynamic> json) = _$OrderImpl.fromJson;

  @override
  String get id;
  @override
  OrderStatus get status;
  @override
  bool get isActive;
  @override
  String get restaurantName;
  @override
  String get restaurantId;
  @override
  String get customerId;
  @override
  List<Dish> get dishes;
  @override
  double get totalPrice;
  @override
  LocationPoint get restaurantLocation;
  @override
  LocationPoint? get driverLocation;
  @override
  LocationPoint get customerLocation;
  @override
  Map<OrderStatus, DateTime> get statusHistory;
  @override
  @JsonKey(ignore: true)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
