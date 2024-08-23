import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/address.dart';
import '../../domain/services/address_crud_service.dart';
import '../../infrastructure/services/firebase_address_crud_service.dart';
import 'authentication_providers.dart';

final addressServiceProvider = Provider<AddressCrudService>((ref) {
  return FirebaseAddressCrudService();
});

final currentSelectedAddress = StateProvider<Address?>((ref) {
  
  return null;
});

final newAddressInProcess = StateProvider<Address?>((ref) => null);

final currentUserAddresses = FutureProvider<List<Address>>((ref) async {
  final addressService = ref.read(addressServiceProvider);
  final currentUserId =
      await ref.read(authenticationServiceProvider).getAuthenticatedUserId();
  if (currentUserId == null) {
    return [];
  }
  return await addressService.readBy("userId", currentUserId);
});
