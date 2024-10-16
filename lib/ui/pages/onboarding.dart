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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class OnboardingRestaurant extends ConsumerStatefulWidget {
  const OnboardingRestaurant({super.key});

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

  Set<String> selectedCategories = {};
  double? selectedPrice;
  final Set<Marker> _markers = {};
  Uint8List? _coverPhotoBytes;
  String? _coverPhotoFileName;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

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

  Future<void> _pickCoverPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true, // Needed for web to access file bytes
    );

    if (result != null && result.files.isNotEmpty) {
      if (kIsWeb) {
        // Web: Use bytes directly
        setState(() {
          _coverPhotoBytes = result.files.first.bytes;
          _coverPhotoFileName = result.files.first.name;
        });
      } else {
        // Mobile/Desktop: Use File to read from path if available
        if (result.files.first.path != null) {
          final file = File(result.files.first.path!);
          setState(() {
            _coverPhotoBytes = file.readAsBytesSync();
            _coverPhotoFileName = result.files.first.name;
          });
        } else {
          // Fallback in case path is null (e.g., storage permissions issue)
          setState(() {
            _coverPhotoBytes = result.files.first.bytes;
            _coverPhotoFileName = result.files.first.name;
          });
        }
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
                Text(
                  FlutterI18n.translate(context, "onboarding.welcome"),
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Image.asset(
                  'assets/images/logo.png',
                  height: 84,
                  width: 84,
                ),
                SizedBox(height: 10),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            FlutterI18n.translate(
                                context, "onboarding.tell_us_about_restaurant"),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              hintText: FlutterI18n.translate(
                                  context, "onboarding.restaurant_name"),
                            ),
                          ),
                          SizedBox(height: 20),
                          InternationalPhoneNumberInput(
                            initialValue: number,
                            onInputChanged: (PhoneNumber number) {
                              print(number.phoneNumber);
                            },
                            validator: (String? value) {
                              if (value != null && value.isNotEmpty) {
                                return null;
                              }
                              return FlutterI18n.translate(
                                  context, "onboarding.invalid_phone_number");
                            },
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
                              signed: true,
                              decimal: true,
                            ),
                            inputDecoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: FlutterI18n.translate(
                                context,
                                "onboarding.phone_number",
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            FlutterI18n.translate(
                                context, "onboarding.select_location"),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
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
                                    infoWindow: InfoWindow(
                                      title: FlutterI18n.translate(context,
                                          "onboarding.selected_location_title"),
                                      snippet: FlutterI18n.translate(context,
                                          "onboarding.selected_location_snippet"),
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
                          SizedBox(height: 20),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            FlutterI18n.translate(
                                context, "onboarding.food_type"),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
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
                        ],
                      ),
                      Column(children: [
                        Text(
                          FlutterI18n.translate(
                              context, "onboarding.average_price"),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
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
                      ]),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            FlutterI18n.translate(
                                context, "onboarding.pick_cover_photo"),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          if (_coverPhotoFileName == null &&
                              _coverPhotoBytes == null)
                            Text(
                              FlutterI18n.translate(
                                  context, "onboarding.no_cover_photo"),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          if (_coverPhotoFileName != null &&
                              _coverPhotoBytes != null)
                            Image.memory(
                              _coverPhotoBytes!,
                              height: 200,
                              width: 200,
                            ),
                          ElevatedButton(
                            onPressed: _pickCoverPhoto,
                            child: Text(FlutterI18n.translate(
                                context, "onboarding.select_cover_photo")),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    if (_currentPageIndex > 0)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text(FlutterI18n.translate(
                              context, "onboarding.back")),
                        ),
                      ),
                    if (_currentPageIndex > 0) SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: saving ||
                                (_currentPageIndex == 3 &&
                                    !_canSaveRestaurant())
                            ? null
                            : () async {
                                if (_currentPageIndex == 3 &&
                                    !_canSaveRestaurant()) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(FlutterI18n.translate(
                                            context,
                                            "onboarding.fill_all_fields")),
                                      ),
                                    );
                                  }
                                  return;
                                }

                                if (_currentPageIndex == 3) {
                                  setState(() {
                                    saving = true;
                                  });

                                  final storageService =
                                      ref.read(storageServiceProvider);
                                  final restaurantService =
                                      ref.read(restaurantServiceProvider);
                                  final authenticationService =
                                      ref.read(authenticationServiceProvider);
                                  final profileService =
                                      ref.read(profileServiceProvider);

                                  final authenticatedId =
                                      await authenticationService
                                          .getAuthenticatedUserId();
                                  final profile = await profileService.readBy(
                                      'userId', authenticatedId!);

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

                                  restaurant = await restaurantService
                                      .create(restaurant);

                                  final coverImage = _coverPhotoBytes != null
                                      ? await storageService.uploadFile(
                                          'restaurants/${restaurant.id!}',
                                          _coverPhotoFileName!.split('.').first,
                                          _coverPhotoFileName!.split('.').last,
                                          _coverPhotoBytes!,
                                        )
                                      : '';

                                  await restaurantService.update(
                                    restaurant.copyWith(coverImage: coverImage),
                                    restaurant.id!,
                                  );

                                  final refresh =
                                      ref.refresh(restaurantProfileProvider);
                                  log('Refreshed restaurant profile: $refresh');
                                } else {
                                  pageController.nextPage(
                                    duration: Duration(milliseconds: 300),
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
                                FlutterI18n.translate(
                                  context,
                                  _currentPageIndex == 3
                                      ? "onboarding.save"
                                      : "onboarding.continue",
                                ),
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
