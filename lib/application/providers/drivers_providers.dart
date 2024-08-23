import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/driver_crud_service.dart';
import '../../infrastructure/services/firebase_driver_crud_service.dart';

final driverServiceProvider = Provider<DriverCrudService>((ref) {
  return FirebaseDriverCrudService();
});
