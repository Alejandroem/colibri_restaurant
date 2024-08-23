import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/orders.dart';
import '../../domain/services/orders_crud_service.dart';
import '../../infrastructure/services/firebase_orders_crud_service.dart';
import 'authentication_providers.dart';

final orderCrudSevice = Provider<OrdersCrudService>(
  (ref) => FirebaseOrdersCrudService(),
);

//We assume it should only be one order at a time
final currentOrderProvider = StreamProvider<List<Order>?>(
  (ref) {
    return ref.watch(authenticatedUserIdStreamProvider).when(
      data: (userId) {
        if (userId != null) {
          final ordersService = ref.watch(orderCrudSevice);
          return ordersService.streamByFilters(
            [
              {
                'field': 'isActive',
                'operator': '==',
                'value': true,
              },
              {
                'field': 'customerId',
                'operator': '==',
                'value': userId,
              }
            ],
          );
        }
        return Stream.value(null);
      },
      loading: () {
        return Stream.value(null);
      },
      error: (err, stack) {
        return Stream.value(null);
      },
    );
  },
);

final orderHistoryForUserProvider = StreamProvider<List<Order>?>(
  (ref) {
    return ref.watch(authenticatedUserIdStreamProvider).when(
      data: (userId) {
        if (userId != null) {
          final ordersService = ref.watch(orderCrudSevice);
          return ordersService.streamByFilters(
            [
              {
                'field': 'customerId',
                'operator': '==',
                'value': userId,
              },
              {
                'field': 'isActive',
                'operator': '==',
                'value': false,
              },
              {
                'field': 'status',
                'operator': '==',
                'value': 'delivered',
              }
            ],
          );
        }
        return Stream.value(null);
      },
      loading: () {
        return Stream.value(null);
      },
      error: (err, stack) {
        return Stream.value(null);
      },
    );
  },
);

final currentDriverOrders = StreamProvider.family<List<Order>?, String>(
  (ref, driverId) {
    final ordersService = ref.watch(orderCrudSevice);
    return ordersService.streamByFilters(
      [
        {
          'field': 'isActive',
          'operator': '==',
          'value': true,
        },
        {
          'field': 'driverId',
          'operator': '==',
          'value': driverId,
        }
      ],
    );
  },
);
