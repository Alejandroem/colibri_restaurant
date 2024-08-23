import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/address.dart';
import '../../domain/services/address_crud_service.dart';
import 'firebase_crud_service.dart';

class FirebaseAddressCrudService extends FirebaseCrudService<Address>
    implements AddressCrudService {
  FirebaseAddressCrudService()
      : super(
          FirebaseFirestore.instance
              .collection('addresses')
              .withConverter<Address>(
                fromFirestore: (snapshot, _) =>
                    Address.fromJson(snapshot.data()!),
                toFirestore: (entity, _) => entity.toJson(),
              ),
        );
}
