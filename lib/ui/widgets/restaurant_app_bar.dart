import 'package:colibri_shared/application/providers/restaurant_providers.dart';
import 'package:colibri_shared/domain/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class RestaurantAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final Restaurant restaurantProfile;
  const RestaurantAppBar(this._scaffoldKey, this.restaurantProfile,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
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
          Text(
            restaurantProfile.isOpen == true
                ? FlutterI18n.translate(context, "app_bar.open")
                : FlutterI18n.translate(context, "app_bar.closed"),
          ),
          const SizedBox(width: 8),
          Switch(
            value: restaurantProfile.isOpen ?? false,
            onChanged: (value) async {
              final restaurantService = ref.read(restaurantServiceProvider);
              await restaurantService.update(
                restaurantProfile.copyWith(isOpen: value),
                restaurantProfile.id!,
              );
              ref.invalidate(
                restaurantProfileProvider,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
