// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dish.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Dish _$DishFromJson(Map<String, dynamic> json) {
  return _Dish.fromJson(json);
}

/// @nodoc
mixin _$Dish {
  String get id => throw _privateConstructorUsedError;
  String get restaurantId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  List<Ingredient> get baseIngredients => throw _privateConstructorUsedError;
  List<Ingredient> get extraIngredients => throw _privateConstructorUsedError;
  List<Ingredient> get removableIngredients =>
      throw _privateConstructorUsedError;
  int? get quantity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DishCopyWith<Dish> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DishCopyWith<$Res> {
  factory $DishCopyWith(Dish value, $Res Function(Dish) then) =
      _$DishCopyWithImpl<$Res, Dish>;
  @useResult
  $Res call(
      {String id,
      String restaurantId,
      String name,
      String description,
      double price,
      List<String> images,
      List<Ingredient> baseIngredients,
      List<Ingredient> extraIngredients,
      List<Ingredient> removableIngredients,
      int? quantity});
}

/// @nodoc
class _$DishCopyWithImpl<$Res, $Val extends Dish>
    implements $DishCopyWith<$Res> {
  _$DishCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? restaurantId = null,
    Object? name = null,
    Object? description = null,
    Object? price = null,
    Object? images = null,
    Object? baseIngredients = null,
    Object? extraIngredients = null,
    Object? removableIngredients = null,
    Object? quantity = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      restaurantId: null == restaurantId
          ? _value.restaurantId
          : restaurantId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      baseIngredients: null == baseIngredients
          ? _value.baseIngredients
          : baseIngredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      extraIngredients: null == extraIngredients
          ? _value.extraIngredients
          : extraIngredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      removableIngredients: null == removableIngredients
          ? _value.removableIngredients
          : removableIngredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DishImplCopyWith<$Res> implements $DishCopyWith<$Res> {
  factory _$$DishImplCopyWith(
          _$DishImpl value, $Res Function(_$DishImpl) then) =
      __$$DishImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String restaurantId,
      String name,
      String description,
      double price,
      List<String> images,
      List<Ingredient> baseIngredients,
      List<Ingredient> extraIngredients,
      List<Ingredient> removableIngredients,
      int? quantity});
}

/// @nodoc
class __$$DishImplCopyWithImpl<$Res>
    extends _$DishCopyWithImpl<$Res, _$DishImpl>
    implements _$$DishImplCopyWith<$Res> {
  __$$DishImplCopyWithImpl(_$DishImpl _value, $Res Function(_$DishImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? restaurantId = null,
    Object? name = null,
    Object? description = null,
    Object? price = null,
    Object? images = null,
    Object? baseIngredients = null,
    Object? extraIngredients = null,
    Object? removableIngredients = null,
    Object? quantity = freezed,
  }) {
    return _then(_$DishImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      restaurantId: null == restaurantId
          ? _value.restaurantId
          : restaurantId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      baseIngredients: null == baseIngredients
          ? _value._baseIngredients
          : baseIngredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      extraIngredients: null == extraIngredients
          ? _value._extraIngredients
          : extraIngredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      removableIngredients: null == removableIngredients
          ? _value._removableIngredients
          : removableIngredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DishImpl implements _Dish {
  const _$DishImpl(
      {required this.id,
      required this.restaurantId,
      required this.name,
      required this.description,
      required this.price,
      required final List<String> images,
      required final List<Ingredient> baseIngredients,
      required final List<Ingredient> extraIngredients,
      required final List<Ingredient> removableIngredients,
      this.quantity})
      : _images = images,
        _baseIngredients = baseIngredients,
        _extraIngredients = extraIngredients,
        _removableIngredients = removableIngredients;

  factory _$DishImpl.fromJson(Map<String, dynamic> json) =>
      _$$DishImplFromJson(json);

  @override
  final String id;
  @override
  final String restaurantId;
  @override
  final String name;
  @override
  final String description;
  @override
  final double price;
  final List<String> _images;
  @override
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<Ingredient> _baseIngredients;
  @override
  List<Ingredient> get baseIngredients {
    if (_baseIngredients is EqualUnmodifiableListView) return _baseIngredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_baseIngredients);
  }

  final List<Ingredient> _extraIngredients;
  @override
  List<Ingredient> get extraIngredients {
    if (_extraIngredients is EqualUnmodifiableListView)
      return _extraIngredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_extraIngredients);
  }

  final List<Ingredient> _removableIngredients;
  @override
  List<Ingredient> get removableIngredients {
    if (_removableIngredients is EqualUnmodifiableListView)
      return _removableIngredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_removableIngredients);
  }

  @override
  final int? quantity;

  @override
  String toString() {
    return 'Dish(id: $id, restaurantId: $restaurantId, name: $name, description: $description, price: $price, images: $images, baseIngredients: $baseIngredients, extraIngredients: $extraIngredients, removableIngredients: $removableIngredients, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DishImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.restaurantId, restaurantId) ||
                other.restaurantId == restaurantId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality()
                .equals(other._baseIngredients, _baseIngredients) &&
            const DeepCollectionEquality()
                .equals(other._extraIngredients, _extraIngredients) &&
            const DeepCollectionEquality()
                .equals(other._removableIngredients, _removableIngredients) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      restaurantId,
      name,
      description,
      price,
      const DeepCollectionEquality().hash(_images),
      const DeepCollectionEquality().hash(_baseIngredients),
      const DeepCollectionEquality().hash(_extraIngredients),
      const DeepCollectionEquality().hash(_removableIngredients),
      quantity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DishImplCopyWith<_$DishImpl> get copyWith =>
      __$$DishImplCopyWithImpl<_$DishImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DishImplToJson(
      this,
    );
  }
}

abstract class _Dish implements Dish {
  const factory _Dish(
      {required final String id,
      required final String restaurantId,
      required final String name,
      required final String description,
      required final double price,
      required final List<String> images,
      required final List<Ingredient> baseIngredients,
      required final List<Ingredient> extraIngredients,
      required final List<Ingredient> removableIngredients,
      final int? quantity}) = _$DishImpl;

  factory _Dish.fromJson(Map<String, dynamic> json) = _$DishImpl.fromJson;

  @override
  String get id;
  @override
  String get restaurantId;
  @override
  String get name;
  @override
  String get description;
  @override
  double get price;
  @override
  List<String> get images;
  @override
  List<Ingredient> get baseIngredients;
  @override
  List<Ingredient> get extraIngredients;
  @override
  List<Ingredient> get removableIngredients;
  @override
  int? get quantity;
  @override
  @JsonKey(ignore: true)
  _$$DishImplCopyWith<_$DishImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
