import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/restaurant.dart';
import '../../domain/services/restaurant_crud_service.dart';
import 'firebase_crud_service.dart';

class FirebaseRestaurantCrudService extends FirebaseCrudService<Restaurant>
    implements RestaurantCrudService {
  FirebaseRestaurantCrudService()
      : super(
          FirebaseFirestore.instance
              .collection('restaurants')
              .withConverter<Restaurant>(
                fromFirestore: (snapshot, _) =>
                    Restaurant.fromJson(snapshot.data()!),
                toFirestore: (entity, _) => entity.toJson(),
              ),
        );
}
