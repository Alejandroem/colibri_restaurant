import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/providers/order_providers.dart';
import '../application/providers/restaurant_providers.dart';
import '../application/providers/storage_providers.dart';
import '../domain/models/orders.dart';
import '../domain/services/orders_crud_service.dart';
import 'pages/settings.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  String? restaurantId;

  @override
  void initState() {
    super.initState();
    ref
        .read(localStorageServiceProvider)
        .read("selected_restaurant_id")
        .then((value) {
      setState(() {
        restaurantId = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersService = ref.read(orderCrudSevice);

    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurant Alpha"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              )
                  .then((value) {
                ref
                    .read(localStorageServiceProvider)
                    .read("selected_restaurant_id")
                    .then((value) {
                  setState(() {
                    restaurantId = value;
                  });
                });
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref
                .read(localStorageServiceProvider)
                .read("selected_restaurant_id")
                .then((value) {
              setState(() {
                restaurantId = value;
              });
            });
          },
          child: restaurantId == null
              ? const Center(
                  child: Text("No restaurant selected"),
                )
              : StreamBuilder(
                  stream: ordersService.streamByFilters(
                    [
                      {
                        'field': 'isActive',
                        'operator': '==',
                        'value': true,
                      },
                      {
                        'field': 'restaurantId',
                        'operator': '==',
                        'value': restaurantId,
                      }
                    ],
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    }

                    if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text("No data"),
                      );
                    }
                    //order by date time based on placed
                    snapshot.data!.sort((a, b) {
                      return b.statusHistory[OrderStatus.placed]!
                          .compareTo(a.statusHistory[OrderStatus.placed]!);
                    });
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: ListView(
                          children: [
                            for (var order in snapshot.data!)
                              Column(
                                children: [
                                  Card(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(order.restaurantName),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(order.status.toString()),
                                              Text(
                                                  "Total Price : ${order.dishes.fold(
                                                0.0,
                                                (previousValue, element) =>
                                                    previousValue +
                                                    element.price *
                                                        (element.quantity ?? 0),
                                              )}")
                                            ],
                                          ),
                                          trailing: Column(
                                            children: order.dishes
                                                .map(
                                                  (dish) => Text(
                                                    '${dish.name} x ${dish.quantity}',
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            if (order.status ==
                                                OrderStatus.placed)
                                              OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                ),
                                                onPressed: () {
                                                  var statusHistory = Map<
                                                          OrderStatus,
                                                          DateTime>.from(
                                                      order.statusHistory);
                                                  statusHistory[OrderStatus
                                                          .preparing] =
                                                      DateTime.now();
                                                  ref
                                                      .read(orderCrudSevice)
                                                      .update(
                                                        order.copyWith(
                                                          status: OrderStatus
                                                              .preparing,
                                                          statusHistory:
                                                              statusHistory,
                                                        ),
                                                        order.id,
                                                      );
                                                },
                                                child: Text(
                                                  "Accept Order",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            if (order.status ==
                                                OrderStatus.preparing)
                                              OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                ),
                                                onPressed: () {
                                                  var statusHistory = Map<
                                                          OrderStatus,
                                                          DateTime>.from(
                                                      order.statusHistory);
                                                  statusHistory[OrderStatus
                                                          .pendingdriver] =
                                                      DateTime.now();
                                                  ref
                                                      .read(orderCrudSevice)
                                                      .update(
                                                        order.copyWith(
                                                          status: OrderStatus
                                                              .pendingdriver,
                                                          statusHistory:
                                                              statusHistory,
                                                        ),
                                                        order.id,
                                                      );
                                                },
                                                child: Text(
                                                  "Ready for pickup",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            Text(
                                              "Order Placed ${getTimeAgo(order.statusHistory[OrderStatus.placed])} ago",
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  String getTimeAgo(DateTime? time) {
    if (time == null) {
      return "Unknown";
    }
    final diff = DateTime.now().difference(time);
    if (diff.inDays > 0) {
      return "${diff.inDays} days";
    }
    if (diff.inHours > 0) {
      return "${diff.inHours} hours";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} minutes";
    }
    return "Just now";
  }
}
