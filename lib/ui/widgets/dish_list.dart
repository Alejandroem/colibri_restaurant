import 'package:carousel_slider/carousel_slider.dart';
import 'package:colibri_shared/application/providers/restaurant_providers.dart';
import 'package:colibri_shared/domain/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/manage_dish_page.dart';

class DishList extends ConsumerStatefulWidget {
  final Restaurant restaurant;
  const DishList(this.restaurant, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DishListState();
}

class _DishListState extends ConsumerState<DishList> {
  // Method to toggle dish availability
  Future<void> _toggleAvailability(dishService, dish) async {
    final updatedDish = dish.copyWith(
      isAvailable: !(dish.isAvailable ?? false), // Default to false if null
    );
    // Update the dish in the backend
    await dishService.update(updatedDish, dish.id);

    // Optimistically update the UI
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final dishService = ref.watch(dishServiceProvider);
    return SingleChildScrollView(
      child: FutureBuilder(
        future: dishService.readBy("restaurantId", widget.restaurant.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred'),
            );
          }
          final dishes = snapshot.data;
          if (dishes == null || dishes.isEmpty) {
            return const Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Icon(Icons.dining, size: 100, color: Colors.grey),
                Center(
                  child: Text(
                    'No dishes found',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  "Dishes",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Dishes you offer",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: dishes.length,
                itemBuilder: (context, index) {
                  final dish = dishes[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) => ManageDishPage(
                            widget.restaurant,
                            dish: dish,
                          ),
                        ),
                      )
                          .then((value) {
                        setState(
                            () {}); // Refresh the list after managing a dish
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Dish ${dish.name}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              // Toggle switch for isAvailable, defaulting to false if null
                              Switch(
                                value: dish.isAvailable ?? false,
                                onChanged: (value) {
                                  _toggleAvailability(dishService, dish);
                                },
                              ),
                            ],
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                      enlargeStrategy:
                                          CenterPageEnlargeStrategy.height,
                                      height: 80,
                                      enableInfiniteScroll: true,
                                      autoPlay: true,
                                      autoPlayInterval:
                                          const Duration(seconds: 3),
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: true,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                    items: dish.images.map((image) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        child: Container(
                                          clipBehavior: Clip.hardEdge,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(13),
                                            ),
                                          ),
                                          child: Image.network(
                                            image,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            height: 80,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Q${dish.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
