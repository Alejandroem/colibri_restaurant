import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;

import '../../domain/models/orders.dart' show Order;
import '../../domain/services/orders_crud_service.dart';
import 'firebase_crud_service.dart';

class FirebaseOrdersCrudService extends FirebaseCrudService<Order>
    implements OrdersCrudService {
  FirebaseOrdersCrudService()
      : super(
          FirebaseFirestore.instance.collection('orders').withConverter<Order>(
                fromFirestore: (snapshot, _) =>
                    Order.fromJson(snapshot.data()!),
                toFirestore: (entity, _) => entity.toJson(),
              ),
        );
}
