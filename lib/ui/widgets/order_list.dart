import 'package:colibri_shared/application/providers/order_providers.dart';
import 'package:colibri_shared/domain/models/orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class OrderList extends ConsumerStatefulWidget {
  final String restaurantId;
  const OrderList(this.restaurantId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderListState();
}

class _OrderListState extends ConsumerState<OrderList> {
  @override
  Widget build(BuildContext context) {
    final ordersService = ref.read(orderCrudSevice);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {},
        child: StreamBuilder(
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
                'value': widget.restaurantId,
              }
            ],
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "${FlutterI18n.translate(context, 'order_list.error')}: ${snapshot.error}",
                ),
              );
            }

            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                child: Text(FlutterI18n.translate(context, 'order_list.no_orders')),
              );
            }

            snapshot.data!.sort((a, b) {
              return b.statusHistory[OrderStatus.placed]!
                  .compareTo(a.statusHistory[OrderStatus.placed]!);
            });

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      FlutterI18n.translate(context, 'order_list.orders'),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  for (var order in snapshot.data!)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(order.restaurantName),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(order.status.toString()),
                                      Text(
                                        "${FlutterI18n.translate(context, 'order_list.total_price')} : ${order.dishes.fold(
                                          0.0,
                                          (previousValue, element) =>
                                              previousValue +
                                              element.price * (element.quantity ?? 0),
                                        )}",
                                      ),
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
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    if (order.status == OrderStatus.placed)
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                        onPressed: () {
                                          var statusHistory = Map<OrderStatus, DateTime>.from(
                                              order.statusHistory);
                                          statusHistory[OrderStatus.preparing] = DateTime.now();
                                          ref.read(orderCrudSevice).update(
                                                order.copyWith(
                                                  status: OrderStatus.preparing,
                                                  statusHistory: statusHistory,
                                                ),
                                                order.id,
                                              );
                                        },
                                        child: Text(
                                          FlutterI18n.translate(context, 'order_list.accept_order'),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    if (order.status == OrderStatus.preparing)
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                        onPressed: () {
                                          var statusHistory = Map<OrderStatus, DateTime>.from(
                                              order.statusHistory);
                                          statusHistory[OrderStatus.pendingdriver] = DateTime.now();
                                          ref.read(orderCrudSevice).update(
                                                order.copyWith(
                                                  status: OrderStatus.pendingdriver,
                                                  statusHistory: statusHistory,
                                                ),
                                                order.id,
                                              );
                                        },
                                        child: Text(
                                          FlutterI18n.translate(context, 'order_list.ready_for_pickup'),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    Text(
                                      "${FlutterI18n.translate(context, 'order_list.order_placed')} ${getTimeAgo(order.statusHistory[OrderStatus.placed])} ${FlutterI18n.translate(context, 'order_list.ago')}",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String getTimeAgo(DateTime? time) {
    if (time == null) {
      return FlutterI18n.translate(context, 'order_list.unknown');
    }
    final diff = DateTime.now().difference(time);
    if (diff.inDays > 0) {
      return "${diff.inDays} ${FlutterI18n.translate(context, 'order_list.days')}";
    }
    if (diff.inHours > 0) {
      return "${diff.inHours} ${FlutterI18n.translate(context, 'order_list.hours')}";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${FlutterI18n.translate(context, 'order_list.minutes')}";
    }
    return FlutterI18n.translate(context, 'order_list.just_now');
  }
}
