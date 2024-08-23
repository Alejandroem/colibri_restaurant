import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/colibri_profile.dart';
import '../../domain/models/restaurant.dart';
import '../../domain/services/profile_service.dart';
import '../../infrastructure/services/firebase_profile_service.dart';
import 'authentication_providers.dart';
import 'restaurant_providers.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  return FirebaseProfileService();
});

final createOrReadCurrentUserProfile = FutureProvider.autoDispose((ref) async {
  final profileService = ref.read(profileServiceProvider);
  final authenticationService = ref.read(authenticationServiceProvider);
  final userId = await authenticationService.getAuthenticatedUserId();
  if (userId == null) {
    return null;
  }

  final profile = await profileService.readBy("userId", userId);
  if (profile.isEmpty) {
    return await profileService.create(
      ColibriProfile(
        id: "",
        userId: userId,
      ),
    );
  } else {
    return profile.first;
  }
});

final favoriteRestaurantsProvider =
    StreamProvider.autoDispose<List<Restaurant>?>((ref) {
  final profile = ref.watch(createOrReadCurrentUserProfile);
  return profile.when(
    data: (profile) {
      final restaurantService = ref.read(restaurantServiceProvider);
      if (profile == null || profile.favoriteRestaurants == null) {
        return Stream.value([]);
      }
      if (profile.favoriteRestaurants!.isEmpty) {
        return Stream.value([]);
      }
      return restaurantService.streamByFilters(
        [
          {
            'field': 'id',
            'operator': 'in',
            'value': profile.favoriteRestaurants,
          }
        ],
      );
    },
    loading: () {
      return Stream.value([]);
    },
    error: (err, stack) {
      return Stream.value([]);
    },
  );
});
