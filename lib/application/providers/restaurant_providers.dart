import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/dish_crud_service.dart';
import '../../domain/services/restaurant_crud_service.dart';
import '../../infrastructure/services/firebase_dish_crud_service.dart';
import '../../infrastructure/services/firebase_restaurant_crud_service.dart';

final restaurantServiceProvider = Provider<RestaurantCrudService>((ref) {
  return FirebaseRestaurantCrudService();
});

final dishServiceProvider = Provider<DishCrudService>((ref) {
  return FirebaseDishCrudService();
});
