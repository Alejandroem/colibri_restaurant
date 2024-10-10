import 'dart:io';
import 'dart:typed_data';
import 'package:colibri_shared/application/providers/storage_providers.dart';
import 'package:colibri_shared/application/providers/restaurant_providers.dart';
import 'package:colibri_shared/constants.dart';
import 'package:colibri_shared/domain/models/restaurant.dart';
import 'package:colibri_shared/domain/models/location_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class RestaurantProfile extends ConsumerStatefulWidget {
  final Restaurant restaurantProfile;
  const RestaurantProfile(this.restaurantProfile, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RestaurantProfileState();
}

class _RestaurantProfileState extends ConsumerState<RestaurantProfile> {
  late GoogleMapController mapController;
  bool saving = false;

  Set<String> selectedCategories = {};
  double? selectedPrice;
  Uint8List? _coverPhotoBytes;
  String? _coverPhotoFileName;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.restaurantProfile.name;
    _phoneNumberController.text = widget.restaurantProfile.phoneNumber ?? '';
    selectedCategories = widget.restaurantProfile.typeOfFood.toSet();
    selectedPrice = widget.restaurantProfile.averagePrice;

    _markers.add(Marker(
      markerId: MarkerId(widget.restaurantProfile.location.toString()),
      position: LatLng(
        widget.restaurantProfile.location.latitude,
        widget.restaurantProfile.location.longitude,
      ),
      infoWindow: InfoWindow(
        title: FlutterI18n.translate(
            context, 'restaurant_profile.selected_location'),
      ),
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

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

  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty ||
        selectedCategories.isEmpty ||
        selectedPrice == null ||
        _markers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(FlutterI18n.translate(
              context, 'restaurant_profile.fill_all_fields')),
        ),
      );
      return;
    }

    setState(() {
      saving = true;
    });

    final storageService = ref.read(storageServiceProvider);
    final restaurantService = ref.read(restaurantServiceProvider);

    String coverImageUrl = widget.restaurantProfile.coverImage;
    if (_coverPhotoBytes != null && _coverPhotoFileName != null) {
      coverImageUrl = await storageService.uploadFile(
        'restaurants/${widget.restaurantProfile.id}',
        _coverPhotoFileName!,
        _coverPhotoFileName!.split('.').last,
        _coverPhotoBytes!,
      );
    }

    final updatedRestaurant = widget.restaurantProfile.copyWith(
      name: _nameController.text,
      typeOfFood: selectedCategories.toList(),
      averagePrice: selectedPrice!,
      coverImage: coverImageUrl,
      location: LocationPoint(
        latitude: _markers.first.position.latitude,
        longitude: _markers.first.position.longitude,
      ),
    );

    await restaurantService.update(
        updatedRestaurant, widget.restaurantProfile.id!);

    setState(() {
      saving = false;
    });

    ref.invalidate(restaurantProfileProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(FlutterI18n.translate(
              context, 'restaurant_profile.profile_updated')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            FlutterI18n.translate(context, 'restaurant_profile.edit_profile')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: FlutterI18n.translate(
                      context, 'restaurant_profile.restaurant_name'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                FlutterI18n.translate(
                    context, 'restaurant_profile.type_of_food'),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 4.0,
                children: restaurantCategories.map((category) {
                  final isSelected = selectedCategories.contains(category);
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
                      backgroundColor: isSelected
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.2),
                      label: Text(FlutterI18n.translate(
                          context, 'categories.$category')),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text(
                FlutterI18n.translate(
                    context, 'restaurant_profile.average_price'),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 4.0,
                children: [30.00, 50.00, 75.00, 100.00].map((price) {
                  final isSelected = selectedPrice == price;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedPrice = price;
                      });
                    },
                    child: Chip(
                      backgroundColor: isSelected
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.2),
                      label: Text("Q${price.toStringAsFixed(2)}"),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text(
                FlutterI18n.translate(
                    context, 'restaurant_profile.cover_photo'),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (_coverPhotoBytes != null)
                Image.memory(
                  _coverPhotoBytes!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              else if (widget.restaurantProfile.coverImage.isNotEmpty)
                Image.network(
                  widget.restaurantProfile.coverImage,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              else
                SizedBox(
                  height: 150,
                  child: Center(
                    child: Text(FlutterI18n.translate(
                        context, 'restaurant_profile.no_cover_photo')),
                  ),
                ),
              ElevatedButton(
                onPressed: _pickCoverPhoto,
                child: Text(FlutterI18n.translate(
                    context, 'restaurant_profile.select_cover_photo')),
              ),
              const SizedBox(height: 16),
              Text(
                FlutterI18n.translate(
                    context, 'restaurant_profile.select_location'),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  markers: _markers,
                  onTap: (latLng) {
                    setState(() {
                      _markers.clear();
                      _markers.add(Marker(
                        markerId: MarkerId(latLng.toString()),
                        position: latLng,
                      ));
                    });
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.restaurantProfile.location.latitude,
                        widget.restaurantProfile.location.longitude),
                    zoom: 15.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              saving
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _saveProfile,
                      child: Text(FlutterI18n.translate(
                          context, 'restaurant_profile.save_changes')),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
