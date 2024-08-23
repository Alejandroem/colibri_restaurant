import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_point.freezed.dart';
part 'location_point.g.dart';

@freezed
abstract class LocationPoint with _$LocationPoint {
  const factory LocationPoint({
    required double latitude,
    required double longitude,
  }) = _Location;

  factory LocationPoint.fromJson(Map<String, dynamic> json) =>
      _$LocationPointFromJson(json);
}
