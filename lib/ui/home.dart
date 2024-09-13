import 'package:colibri_shared/application/providers/authentication_providers.dart';
import 'package:colibri_shared/application/providers/navigation_providers.dart';
import 'package:colibri_shared/application/providers/restaurant_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/manage_dish_page.dart';
import 'pages/onboarding.dart';
import 'pages/authentication_page.dart';
import 'widgets/colibri_drawer.dart';
import 'widgets/dish_list.dart';
import 'widgets/order_list.dart';
import 'widgets/restaurant_app_bar.dart';
import 'widgets/restaurant_profile.dart';

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
          key: _scaffoldKey,
          drawer: ColibriDrawer(restaurantProfile),
          appBar: RestaurantAppBar(_scaffoldKey, restaurantProfile),
          floatingActionButton: ref.watch(currentDrawerIndexProvider) == 1
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => ManageDishPage(
                          restaurantProfile,
                        ),
                      ),
                    )
                        .then((value) {
                      setState(() {});
                    });
                  },
                  child: const Icon(Icons.add),
                )
              : null,
          body: IndexedStack(
            index: ref.watch(currentDrawerIndexProvider),
            children: [
              OrderList(restaurantProfile.id!),
              DishList(restaurantProfile),
              RestaurantProfile(restaurantProfile),
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
