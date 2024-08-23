import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/colibri_profile.dart';
import '../../domain/services/profile_service.dart';
import 'firebase_crud_service.dart';

class FirebaseProfileService extends FirebaseCrudService<ColibriProfile>
    implements ProfileService {
  FirebaseProfileService()
      : super(
          FirebaseFirestore.instance
              .collection('profiles')
              .withConverter<ColibriProfile>(
                fromFirestore: (snapshot, _) =>
                    ColibriProfile.fromJson(snapshot.data()!),
                toFirestore: (entity, _) => entity.toJson(),
              ),
        );
}
