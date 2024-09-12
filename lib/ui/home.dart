import 'package:colibri_shared/application/providers/authentication_providers.dart';
import 'package:colibri_shared/application/providers/restaurant_providers.dart';
import 'package:colibri_shared/application/providers/storage_providers.dart';
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
    final isAuthenticated = ref.watch(isAuthenticatedStateNotifierProvider);

    if (!isAuthenticated) {
      return const AuthenticationPage();
    }
    return ref.watch(restaurantProfileProvider).when(
      data: (restaurantProfile) {
        if (restaurantProfile == null) {
          return const OnboardingRestaurant();
        }
        return const OrderList();
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
