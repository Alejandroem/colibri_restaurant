import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/basket.dart';
import '../notifiers/basket_state_notifier.dart';

final currentBasketStateNotifierProvider =
    StateNotifierProvider<BasketStateNotifier, Basket>((ref) {
  return BasketStateNotifier();
});
