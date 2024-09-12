import 'package:colibri_shared/application/providers/location_providers.dart';
import 'package:colibri_shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OnboardingRestaurant extends ConsumerStatefulWidget {
  const OnboardingRestaurant({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingRestaurantState();
}

class _OnboardingRestaurantState extends ConsumerState<OnboardingRestaurant> {
  bool showBackButton = false;
  late GoogleMapController mapController;
  PageController pageController = PageController();

  // Local state for multi-selection of food categories
  Set<String> selectedCategories = {};

  // Local state for single-select average price
  double? selectedPrice;

  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get current location and update the camera position
    ref.watch(locationServiceProvider).getCurrentLocation().then((latLng) {
      mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            latLng.latitude,
            latLng.longitude,
          ),
        ),
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Welcome to Colibri!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Image.asset(
                  'assets/images/logo.png',
                  height: 84,
                  width: 84,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Tell us about your restaurant",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              hintText: 'How do you want to be called?',
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Select your location',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: GoogleMap(
                                mapToolbarEnabled: false,
                                myLocationEnabled: true,
                                mapType: MapType.normal,
                                onTap: (LatLng latLng) {
                                  _markers.clear();
                                  _markers.add(Marker(
                                    markerId: MarkerId(latLng.toString()),
                                    position: latLng,
                                    infoWindow: const InfoWindow(
                                      title: 'Selected Location',
                                      snippet: 'This is the selected location',
                                    ),
                                    icon: BitmapDescriptor.defaultMarker,
                                  ));

                                  setState(() {});
                                },
                                markers: _markers,
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: const CameraPosition(
                                  target: LatLng(0.0, 0.0),
                                  zoom: 17.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            "Type of food",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Display the list of chips in a Wrap to handle multiple rows
                          Wrap(
                            spacing: 4.0, // Space between the chips
                            children: restaurantCategories
                                .where((category) => category != "All")
                                .toList()
                                .map((category) {
                              final isSelected =
                                  selectedCategories.contains(category);

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    // Toggle the selected category in the Set
                                    if (isSelected) {
                                      selectedCategories.remove(category);
                                    } else {
                                      selectedCategories.add(category);
                                    }
                                  });
                                },
                                child: Chip(
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: isSelected
                                      ? Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.2)
                                      : Theme.of(context)
                                          .chipTheme
                                          .backgroundColor,
                                  padding: const EdgeInsets.all(0),
                                  label: Text(
                                    category,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Average Price",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Display the list of average prices in a Wrap to handle single selection
                          Wrap(
                            spacing: 4.0, // Space between the chips
                            children: [
                              30.00,
                              50.00,
                              75.00,
                              100.00,
                            ].map((price) {
                              final isSelected = selectedPrice == price;

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    // Set the selected price for single selection
                                    selectedPrice = price;
                                  });
                                },
                                child: Chip(
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: isSelected
                                      ? Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.2)
                                      : Theme.of(context)
                                          .chipTheme
                                          .backgroundColor,
                                  padding: const EdgeInsets.all(0),
                                  label: Text(
                                    "Q${price.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    if (showBackButton)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (pageController.page == 1) {
                                showBackButton = false;
                              }
                            });
                            pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text('Back'),
                        ),
                      ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (pageController.page == 0) {
                              showBackButton = true;
                            }
                          });
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text('Continue'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
