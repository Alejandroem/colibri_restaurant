import 'dart:developer';
import '../../domain/models/location_point.dart';
import 'package:location/location.dart';

import '../../domain/services/location_service.dart';

class DeviceLocationService extends LocationService {
  @override
  Future<bool> enableRealTimeLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    locationData = await location.getLocation();
    log('LocationPoint: ${locationData.latitude}, ${locationData.longitude}');
    return true;
  }

  @override
  Future<LocationPoint> getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return const LocationPoint(latitude: 0, longitude: 0);
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return const LocationPoint(latitude: 0, longitude: 0);
      }
    }

    locationData = await location.getLocation();
    log('LocationPoint: ${locationData.latitude}, ${locationData.longitude}');
    return LocationPoint(
      latitude: locationData.latitude!,
      longitude: locationData.longitude!,
    );
  }

  @override
  Stream<LocationPoint> getRealTimeLocation() {
    Location location = Location();
    Stream<LocationData> locationDataStream = location.onLocationChanged;
    return locationDataStream.map((locationData) {
      log('LocationPoint: ${locationData.latitude}, ${locationData.longitude}');
      return LocationPoint(
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
      );
    });
  }

  @override
  Future<bool> isRealTimeLocationEnabled() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();

    PermissionStatus permissionGranted;
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      return false;
    }
    return serviceEnabled;
  }
}
