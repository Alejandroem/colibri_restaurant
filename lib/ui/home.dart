import 'package:colibri_shared/application/providers/authentication_providers.dart';
import 'package:colibri_shared/application/providers/navigation_providers.dart';
import 'package:colibri_shared/application/providers/restaurant_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/onboarding.dart';
import 'pages/authentication_page.dart';
import 'widgets/order_list.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Add a global key for the scaffold

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(isAuthenticatedStateNotifierProvider);

    if (!isAuthenticated) {
      return const AuthenticationPage();
    }
    return ref.watch(restaurantProfileProvider).when(
      data: (restaurantProfile) {
        if (restaurantProfile == null) {
          return const OnboardingRestaurant();
        }

        return Scaffold(
          key: _scaffoldKey, // Assign the key to the Scaffold

          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(restaurantProfile.coverImage),
                      fit: BoxFit.cover,
                      opacity: 0.5,
                    ),
                  ),
                  child: Text(
                    restaurantProfile.name,
                  ),
                ),
                ListTile(
                  title: const Text("Orders"),
                  onTap: () {
                    ref.watch(currentDrawerIndexProvider.notifier).state = 0;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Dishes"),
                  onTap: () {
                    ref.watch(currentDrawerIndexProvider.notifier).state = 1;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Profile"),
                  onTap: () {
                    ref.watch(currentDrawerIndexProvider.notifier).state = 2;
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            title: Row(
              children: [
                Text(restaurantProfile.name),
                const Spacer(),
                restaurantProfile.isOpen == true
                    ? const Text("Open")
                    : const Text("Closed"),
                const SizedBox(width: 8),
                Switch(
                  value: restaurantProfile.isOpen ?? false,
                  onChanged: (value) async {
                    final restaurantService =
                        ref.read(restaurantServiceProvider);
                    await restaurantService.update(
                      restaurantProfile.copyWith(isOpen: value),
                      restaurantProfile.id!,
                    );
                    ref.invalidate(
                        restaurantProfileProvider); // Invalidate to trigger a rebuild
                  },
                ),
              ],
            ),
          ),
          body: IndexedStack(
            index: ref.watch(currentDrawerIndexProvider),
            children: [
              OrderList(restaurantProfile.id!),
              const Text("Dishes"),
              const Text("Profile"),
            ],
          ),
        );
      },
      error: (Object error, StackTrace stackTrace) {
        return const Scaffold(
          body: Center(
            child: Text('An error occurred'),
          ),
        );
      },
      loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
