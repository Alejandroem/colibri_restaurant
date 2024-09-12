import 'package:colibri_shared/application/providers/authentication_providers.dart';
import 'package:colibri_shared/application/providers/restaurant_providers.dart';
import 'package:colibri_shared/application/providers/storage_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final restaurants = ref.watch(restaurantServiceProvider);
    final localStorageService = ref.watch(localStorageServiceProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant Alpha"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              final authenticationService =
                  ref.read(authenticationServiceProvider);
              authenticationService.signOut();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: restaurants.list(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No data"),
              );
            }
            final restaurants = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  for (var restaurant in restaurants!)
                    FutureBuilder(
                      future:
                          localStorageService.read("selected_restaurant_id"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error}"),
                          );
                        }
                        final selectedRestaurantId = snapshot.data;
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: selectedRestaurantId == restaurant.id
                                ? Colors.blue[200]
                                : Colors.grey[200],
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text(restaurant.name),
                            onTap: () async {
                              final selectedId = await localStorageService
                                  .read("selected_restaurant_id");
                              if (selectedId == restaurant.id) {
                                await localStorageService
                                    .delete("selected_restaurant_id");
                              } else {
                                await localStorageService.save(
                                  "selected_restaurant_id",
                                  restaurant.id!,
                                );
                              }
                              setState(() {});
                            },
                            trailing: selectedRestaurantId == restaurant.id
                                ? const Icon(Icons.check)
                                : null,
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
