import '../models/location_point.dart';

abstract class LocationService {
  Future<bool> isRealTimeLocationEnabled();
  Future<bool> enableRealTimeLocation();
  Future<LocationPoint> getCurrentLocation();
  Stream<LocationPoint> getRealTimeLocation();
}
