import 'dart:developer';

import 'package:colibri_shared/application/providers/authentication_providers.dart';
import 'package:colibri_shared/application/providers/navigation_providers.dart';
import 'package:colibri_shared/application/providers/restaurant_providers.dart';
import 'package:colibri_shared/application/providers/storage_providers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async'; // Import to use StreamSubscription

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _hasCheckedSubscription = false;

  // StreamSubscriptions to manage notification listeners
  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;

  // Method to check and subscribe to restaurant notifications
  Future<void> checkAndSubscribeToRestaurantNotifications(
      String restaurantId) async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final NotificationSettings settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final String topic = restaurantId;
      final localStorageService = ref.read(localStorageServiceProvider);

      // Check if already subscribed (using local storage to track)
      final isSubscribed = await localStorageService.read('subscribedTo$topic');
      final bool? isSubscribedBool = bool.tryParse(isSubscribed ?? 'false');

      // Subscribe if not already subscribed
      if (isSubscribedBool == null || !isSubscribedBool) {
        await messaging.subscribeToTopic(topic);
        await localStorageService.save('subscribedTo$topic', 'true');
        log('Subscribed to topic: $topic');
      } else {
        log('Already subscribed to topic: $topic');
      }
    } else {
      log('Notification permissions not granted');
    }
  }

  Future<void> initNotificationHandlers() async {
    // Background message handler is static; does not require a subscription
    FirebaseMessaging.onBackgroundMessage((RemoteMessage? message) async {
      if (message != null) {
        log('Handling a background message ${message.messageId}');
        log('Message data: ${message.data}');
        log('Message notification: ${message.notification}');
      }
    });

    // Listen for notifications in the foreground
    _onMessageSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        log('Notification Title: ${message.notification!.title}');
        log('Notification Body: ${message.notification!.body}');
        // Show alert or custom UI here if needed
      }
    });

    // Listen for when the app is opened by tapping a notification
    _onMessageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      if (message != null) {
        log('Message data: ${message.data}');
        log('Message notification: ${message.notification}');
      }
    });

    // Check if the app was launched by tapping a notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        log('Message data: ${message.data}');
        log('Message notification: ${message.notification}');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initNotificationHandlers();
  }

  @override
  void dispose() {
    // Cancel subscriptions to avoid memory leaks
    _onMessageSubscription?.cancel();
    _onMessageOpenedAppSubscription?.cancel();
    super.dispose();
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

        // Trigger check and subscription if not yet done
        if (!_hasCheckedSubscription) {
          _hasCheckedSubscription = true; // Avoid repeated calls
          checkAndSubscribeToRestaurantNotifications(restaurantProfile.id!);
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
