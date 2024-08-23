import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/dish.dart';
import '../../domain/services/dish_crud_service.dart';
import 'firebase_crud_service.dart';

class FirebaseDishCrudService extends FirebaseCrudService<Dish>
    implements DishCrudService {
  FirebaseDishCrudService()
      : super(
          FirebaseFirestore.instance.collection('dishes').withConverter<Dish>(
                fromFirestore: (snapshot, _) => Dish.fromJson(snapshot.data()!),
                toFirestore: (entity, _) => entity.toJson(),
              ),
        );
}
