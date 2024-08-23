import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/location_service.dart';
import '../../infrastructure/services/device_location_service.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return DeviceLocationService();
});
