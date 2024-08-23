import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/basket.dart';
import '../../domain/models/dish.dart';

class BasketStateNotifier extends StateNotifier<Basket> {
  BasketStateNotifier() : super(const Basket());

  int getDishQuantity(Dish dish) {
    if (state.dishes == null) {
      return 0;
    }
    if (state.dishes!.any((d) => d.id == dish.id)) {
      return state.dishes!.firstWhere((d) => d.id == dish.id).quantity ?? 0;
    }
    return 0;
  }

  void addDishToBasket(Dish dish) {
    // If the dish is already in the basket, increase the quantity
    if (state.dishes == null) {
      state = state.copyWith(dishes: [dish.copyWith(quantity: 1)]);
      return;
    }
    if (state.dishes!.any((d) => d.id == dish.id)) {
      state = state.copyWith(
        dishes: state.dishes!.map((d) {
          if (d.id == dish.id) {
            return d.copyWith(quantity: d.quantity! + 1);
          }
          return d;
        }).toList(),
      );
      return;
    }
    // If the dish is not in the basket, add it
    state = state.copyWith(
      dishes: [
        ...state.dishes!,
        dish.copyWith(
          quantity: 1,
        ),
      ],
    );
  }

  void removeDishFromBasket(Dish dish) {
    if (state.dishes == null) {
      return;
    }
    if (state.dishes!.any((d) => d.id == dish.id)) {
      final dishQuantity =
          state.dishes!.firstWhere((d) => d.id == dish.id).quantity!;
      if (dishQuantity == 1) {
        if (state.dishes!.length == 1) {
          state = const Basket();
          return;
        } else {
          state = state.copyWith(
            dishes: state.dishes!.where((d) => d.id != dish.id).toList(),
          );
          return;
        }
      } else {
        state = state.copyWith(
          dishes: state.dishes!.map((d) {
            if (d.id == dish.id) {
              return d.copyWith(quantity: d.quantity! - 1);
            }
            return d;
          }).toList(),
        );
        return;
      }
    }
  }

  void removeDishCompletelyFromBasket(Dish dish) {
    if (state.dishes == null) {
      return;
    }
    if (state.dishes!.any((d) => d.id == dish.id)) {
      state = state.copyWith(
        dishes: state.dishes!.where((d) => d.id != dish.id).toList(),
      );
      return;
    }
  }

  void clearBasket() {
    state = const Basket();
  }
}
