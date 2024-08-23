import 'package:firebase_core/firebase_core.dart';

import '../../domain/services/backend_service.dart';

class FirebaseBackendService extends BackendService {
  @override
  Future<void> initializeBackendServices() async {
    await Firebase.initializeApp();
  }
}
