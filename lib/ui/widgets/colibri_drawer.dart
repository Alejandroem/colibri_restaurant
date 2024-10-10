import 'package:colibri_shared/application/providers/authentication_providers.dart';
import 'package:colibri_shared/application/providers/navigation_providers.dart';
import 'package:colibri_shared/domain/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class ColibriDrawer extends ConsumerWidget {
  final Restaurant restaurantProfile;
  const ColibriDrawer(this.restaurantProfile, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
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
            title: Text(FlutterI18n.translate(context, "drawer.orders")),
            onTap: () {
              ref.watch(currentDrawerIndexProvider.notifier).state = 0;
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(FlutterI18n.translate(context, "drawer.dishes")),
            onTap: () {
              ref.watch(currentDrawerIndexProvider.notifier).state = 1;
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(FlutterI18n.translate(context, "drawer.profile")),
            onTap: () {
              ref.watch(currentDrawerIndexProvider.notifier).state = 2;
              Navigator.pop(context);
            },
          ),
          const Divider(),
          const SizedBox(height: 100),
          ListTile(
            title: Text(FlutterI18n.translate(context, "drawer.logout")),
            onTap: () {
              final authProvider = ref.read(authenticationServiceProvider);
              authProvider.signOut();
            },
          ),
        ],
      ),
    );
  }
}
