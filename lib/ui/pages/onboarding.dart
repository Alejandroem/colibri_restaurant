import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:colibri_shared/application/providers/authentication_providers.dart';
import 'package:colibri_shared/application/providers/location_providers.dart';
import 'package:colibri_shared/application/providers/profile_providers.dart';
import 'package:colibri_shared/application/providers/restaurant_providers.dart';
import 'package:colibri_shared/application/providers/storage_providers.dart';
import 'package:colibri_shared/constants.dart';
import 'package:colibri_shared/domain/models/location_point.dart';
import 'package:colibri_shared/domain/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class OnboardingRestaurant extends ConsumerStatefulWidget {
  const OnboardingRestaurant({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingRestaurantState();
}

class _OnboardingRestaurantState extends ConsumerState<OnboardingRestaurant> {
  late GoogleMapController mapController;
  PageController pageController = PageController();
  int _currentPageIndex = 0;
  bool saving = false;
  PhoneNumber number = PhoneNumber(isoCode: 'GT');

  // Local state for multi-selection of food categories
  Set<String> selectedCategories = {};

  // Local state for single-select average price
  double? selectedPrice;

  final Set<Marker> _markers = {};

  // Local state for the cover photo bytes and file name
  Uint8List? _coverPhotoBytes;
  String? _coverPhotoFileName;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // Get current location and update the camera position
    ref.read(locationServiceProvider).getCurrentLocation().then((latLng) {
      mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            latLng.latitude,
            latLng.longitude,
          ),
        ),
      );
    });
  }

  // Method to pick a cover photo
  Future<void> _pickCoverPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null) {
      if (result.files.first.bytes != null) {
        setState(() {
          _coverPhotoBytes = result.files.first.bytes;
          _coverPhotoFileName = result.files.first.name;
        });
      } else if (result.files.first.path != null) {
        final file = File(result.files.first.path!);
        setState(() {
          _coverPhotoBytes = file.readAsBytesSync();
          _coverPhotoFileName = result.files.first.name;
        });
      }
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    return phoneNumber.isNotEmpty;
  }

  bool _canSaveRestaurant() {
    return _nameController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _isValidPhoneNumber(_phoneNumberController.text) &&
        selectedCategories.isNotEmpty &&
        selectedPrice != null &&
        _coverPhotoBytes != null &&
        _markers.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
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
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentPageIndex = index;
                      });
                    },
                    children: [
                      // First Page
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            "Tell us about your restaurant",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          // Restaurant Name Input
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              hintText: 'Restaurant Name',
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Phone Number Input
                          InternationalPhoneNumberInput(
                            initialValue: number,
                            onInputChanged: (PhoneNumber number) {},
                            onInputValidated: (bool value) {},
                            selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            ),
                            ignoreBlank: false,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            textFieldController: _phoneNumberController,
                            formatInput: true,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            inputDecoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: 'Phone Number',
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
                      // Second Page
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            "Type of food",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 4.0,
                            children: restaurantCategories
                                .where((category) => category != "All")
                                .map((category) {
                              final isSelected =
                                  selectedCategories.contains(category);
                              return InkWell(
                                onTap: () {
                                  setState(() {
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
                          const SizedBox(height: 10),
                          const Text(
                            "Average Price",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 2.0,
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
                      // Third Page
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            "Pick a cover photo",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          if (_coverPhotoFileName != null &&
                              _coverPhotoBytes != null)
                            Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(13),
                                ),
                              ),
                              child: Image.memory(
                                _coverPhotoBytes!,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (_coverPhotoFileName == null &&
                              _coverPhotoBytes == null)
                            const SizedBox(
                              height: 150,
                              child: Center(
                                child: Text(
                                  "No cover photo selected",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _pickCoverPhoto,
                            child: const Text("Select Cover Photo"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (_currentPageIndex > 0)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text('Back'),
                        ),
                      ),
                    if (_currentPageIndex > 0) const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: saving
                            ? null
                            : () async {
                                if (_currentPageIndex == 2 &&
                                    !_canSaveRestaurant()) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please fill in all the fields',
                                        ),
                                      ),
                                    );
                                  }
                                  return;
                                }

                                if (_currentPageIndex == 2) {
                                  setState(() {
                                    saving = true;
                                  });
                                  // Save action on the last page
                                  // Add save logic here
                                  final storageService =
                                      ref.read(storageServiceProvider);
                                  final restaurantService =
                                      ref.read(restaurantServiceProvider);
                                  final authenticationService = ref.read(
                                    authenticationServiceProvider,
                                  );
                                  final profileService =
                                      ref.read(profileServiceProvider);

                                  final authenticatedId =
                                      await authenticationService
                                          .getAuthenticatedUserId();
                                  final profile = await profileService.readBy(
                                    'userId',
                                    authenticatedId!,
                                  );

                                  Restaurant restaurant = Restaurant(
                                    id: null,
                                    coverImage: '',
                                    name: _nameController.text,
                                    typeOfFood: selectedCategories.toList(),
                                    averagePrice: selectedPrice ?? 0.0,
                                    location: LocationPoint(
                                      latitude:
                                          _markers.first.position.latitude,
                                      longitude:
                                          _markers.first.position.longitude,
                                    ),
                                    phoneNumber: profile.isNotEmpty
                                        ? profile.first.phoneNumber
                                        : '',
                                    ownerId: authenticatedId,
                                    isOpen: false,
                                  );

                                  restaurant = await restaurantService.create(
                                    restaurant,
                                  );

                                  final coverImage = _coverPhotoBytes != null
                                      ? await storageService.uploadFile(
                                          'restaurants/${restaurant.id!}',
                                          _coverPhotoFileName!,
                                          _coverPhotoFileName!.split('.').last,
                                          _coverPhotoBytes!,
                                        )
                                      : '';

                                  await restaurantService.update(
                                    restaurant.copyWith(
                                      coverImage: coverImage,
                                    ),
                                    restaurant.id!,
                                  );

                                  final refresh = ref.refresh(
                                    restaurantProfileProvider,
                                  );
                                  log('Refreshed restaurant profile: $refresh');
                                } else {
                                  pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                        child: saving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                _currentPageIndex == 2 ? 'Save' : 'Continue',
                              ),
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
