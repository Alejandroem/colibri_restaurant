// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'basket.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Basket _$BasketFromJson(Map<String, dynamic> json) {
  return _Basket.fromJson(json);
}

/// @nodoc
mixin _$Basket {
  List<Dish>? get dishes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BasketCopyWith<Basket> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BasketCopyWith<$Res> {
  factory $BasketCopyWith(Basket value, $Res Function(Basket) then) =
      _$BasketCopyWithImpl<$Res, Basket>;
  @useResult
  $Res call({List<Dish>? dishes});
}

/// @nodoc
class _$BasketCopyWithImpl<$Res, $Val extends Basket>
    implements $BasketCopyWith<$Res> {
  _$BasketCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dishes = freezed,
  }) {
    return _then(_value.copyWith(
      dishes: freezed == dishes
          ? _value.dishes
          : dishes // ignore: cast_nullable_to_non_nullable
              as List<Dish>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BasketImplCopyWith<$Res> implements $BasketCopyWith<$Res> {
  factory _$$BasketImplCopyWith(
          _$BasketImpl value, $Res Function(_$BasketImpl) then) =
      __$$BasketImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Dish>? dishes});
}

/// @nodoc
class __$$BasketImplCopyWithImpl<$Res>
    extends _$BasketCopyWithImpl<$Res, _$BasketImpl>
    implements _$$BasketImplCopyWith<$Res> {
  __$$BasketImplCopyWithImpl(
      _$BasketImpl _value, $Res Function(_$BasketImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dishes = freezed,
  }) {
    return _then(_$BasketImpl(
      dishes: freezed == dishes
          ? _value._dishes
          : dishes // ignore: cast_nullable_to_non_nullable
              as List<Dish>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BasketImpl implements _Basket {
  const _$BasketImpl({final List<Dish>? dishes}) : _dishes = dishes;

  factory _$BasketImpl.fromJson(Map<String, dynamic> json) =>
      _$$BasketImplFromJson(json);

  final List<Dish>? _dishes;
  @override
  List<Dish>? get dishes {
    final value = _dishes;
    if (value == null) return null;
    if (_dishes is EqualUnmodifiableListView) return _dishes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Basket(dishes: $dishes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BasketImpl &&
            const DeepCollectionEquality().equals(other._dishes, _dishes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_dishes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BasketImplCopyWith<_$BasketImpl> get copyWith =>
      __$$BasketImplCopyWithImpl<_$BasketImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BasketImplToJson(
      this,
    );
  }
}

abstract class _Basket implements Basket {
  const factory _Basket({final List<Dish>? dishes}) = _$BasketImpl;

  factory _Basket.fromJson(Map<String, dynamic> json) = _$BasketImpl.fromJson;

  @override
  List<Dish>? get dishes;
  @override
  @JsonKey(ignore: true)
  _$$BasketImplCopyWith<_$BasketImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
