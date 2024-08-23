import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/driver.dart';
import '../../domain/services/driver_crud_service.dart';
import 'firebase_crud_service.dart';

class FirebaseDriverCrudService extends FirebaseCrudService<Driver>
    implements DriverCrudService {
  FirebaseDriverCrudService()
      : super(
          FirebaseFirestore.instance
              .collection('drivers')
              .withConverter<Driver>(
                fromFirestore: (snapshot, _) =>
                    Driver.fromJson(snapshot.data()!),
                toFirestore: (entity, _) => entity.toJson(),
              ),
        );
}
