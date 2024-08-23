import 'package:freezed_annotation/freezed_annotation.dart';

part 'colibri_profile.freezed.dart';
part 'colibri_profile.g.dart';

@freezed
abstract class ColibriProfile with _$ColibriProfile {
  const factory ColibriProfile({
    required String id,
    required String userId,
    String? profilePicture,
    String? firstName,
    String? lastName,
    List<String>? favoriteRestaurants,
  }) = _ColibriProfile;

  factory ColibriProfile.fromJson(Map<String, dynamic> json) =>
      _$ColibriProfileFromJson(json);
}
