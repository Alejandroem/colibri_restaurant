import 'dart:developer';
import 'dart:io';
import 'package:colibri_shared/application/providers/restaurant_providers.dart';
import 'package:colibri_shared/application/providers/storage_providers.dart';
import 'package:colibri_shared/domain/models/dish.dart';
import 'package:colibri_shared/domain/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ManageDishPage extends ConsumerStatefulWidget {
  final Restaurant restaurant;
  final Dish? dish;
  const ManageDishPage(
    this.restaurant, {
    super.key,
    this.dish,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ManageDishPageState();
}

class _ManageDishPageState extends ConsumerState<ManageDishPage> {
  bool _isSaving = false;
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // List to store selected image files (locally picked images)
  final List<File> _newImages = [];

  // List to store existing image URLs (for editing)
  List<String> _existingImageUrls = [];

  // List to track images marked for deletion
  final List<String> _imagesToDelete = [];

  @override
  void initState() {
    super.initState();
    if (widget.dish != null) {
      // Pre-populate fields with existing dish data if it's an update
      nameController.text = widget.dish!.name;
      descriptionController.text = widget.dish!.description;
      priceController.text = widget.dish!.price.toString();
      // Populate existing image URLs for editing
      _existingImageUrls = List.from(widget.dish!.images);
    }
  }

  // Method to pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newImages.add(File(pickedFile.path));
      });
    }
  }

  // Method to take picture using the camera
  Future<void> _takePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _newImages.add(File(pickedFile.path));
      });
    }
  }

  // Mark existing image URL for deletion
  void _markImageForDeletion(String imageUrl) {
    setState(() {
      _existingImageUrls.remove(imageUrl); // Temporarily remove from UI
      _imagesToDelete.add(imageUrl); // Add to delete list
    });
  }

  // Remove new image before it's uploaded
  void _deleteNewImage(int index) {
    setState(() {
      _newImages.removeAt(index);
    });
  }

  // Method to save form
  Future<void> _saveForm() async {
    setState(() {
      _isSaving = true;
    });

    if (_formKey.currentState!.validate()) {
      final dishService = ref.read(dishServiceProvider);
      final storageService = ref.read(storageServiceProvider);

      // Get values from the form
      String name = nameController.text;
      String description = descriptionController.text;
      double? price = double.tryParse(priceController.text);
      if (price == null) {
        // Handle invalid price input
        setState(() {
          _isSaving = false;
        });
        return;
      }

      List<String> finalImageUrls = List.from(_existingImageUrls);

      // If the dish is new (no ID yet), create the dish first to get the ID
      String dishId;
      if (widget.dish == null) {
        final newDish = Dish(
          id: '',
          restaurantId: widget.restaurant.id!,
          name: name,
          description: description,
          price: price,
          images: [], // Images will be added after upload
          baseIngredients: null,
          extraIngredients: null,
          removableIngredients: null,
          isAvailable: null,
        );

        // Create the dish and get the newly generated ID
        final createdDish = await dishService.create(newDish);
        dishId = createdDish
            .id; // Assuming create() returns the dish with the generated ID
      } else {
        // For updating an existing dish, use the existing ID
        dishId = widget.dish!.id;
      }

      // Delete marked images
      for (var imageUrl in _imagesToDelete) {
        await storageService.deleteFileFromUrl(imageUrl); // Delete from storage
      }

      // Upload new images
      for (var image in _newImages) {
        final uploadedImageUrl = await storageService.uploadFile(
          'dishes/$dishId', // Now we have the dish ID
          image.path.split('/').last,
          image.path.split('.').last,
          await image.readAsBytes(),
        );
        finalImageUrls
            .add(uploadedImageUrl); // Add the new image URL to the final list
      }

      // Now update the dish with the final image URLs
      final updatedDish = Dish(
        id: dishId,
        restaurantId: widget.restaurant.id!,
        name: name,
        description: description,
        price: price,
        images: finalImageUrls, // Updated image list
        baseIngredients: widget.dish?.baseIngredients,
        extraIngredients: widget.dish?.extraIngredients,
        removableIngredients: widget.dish?.removableIngredients,
        isAvailable: widget.dish?.isAvailable,
      );

      await dishService.update(updatedDish, dishId);

      if (mounted) {
        Navigator.of(context)
            .pop(true); // Return true to trigger refresh on pop
      }
    }

    setState(() {
      _isSaving = false;
    });
  }

  Future<void> _deleteDish() async {
    final dishService = ref.read(dishServiceProvider);
    final storageService = ref.read(storageServiceProvider);

    // Show confirmation dialog before deletion
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Dish'),
        content: const Text(
            'Are you sure you want to delete this dish? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Cancel
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Confirm delete
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) {
      return; // User canceled the deletion
    }

    // Proceed with deletion
    try {
      // Delete all images from Firebase Storage
      for (String imageUrl in widget.dish!.images) {
        await storageService.deleteFileFromUrl(imageUrl);
      }

      // Delete the dish from the database
      await dishService.delete(widget.dish!.id);

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to refresh the list
      }
    } catch (e) {
      log('Error deleting dish: $e');
      // Handle any errors here, such as showing a snackbar or alert
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Dish'),
        actions: widget.dish != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed:
                      _deleteDish, // Call the delete function when pressed
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Name Field
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Dish Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the dish name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Description Field
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Price Field
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                    prefixText: 'Q', // This will add the "Q" prefix
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Existing Image Section (for editing)
                if (_existingImageUrls.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Existing Dish Images',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _existingImageUrls.map((imageUrl) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  imageUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () =>
                                      _markImageForDeletion(imageUrl),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),

                // New Image Upload Section
                const Text(
                  'New Dish Images',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),

                // Display selected new images
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _newImages.map((image) {
                    int index = _newImages.indexOf(image);
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteNewImage(index),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16.0),

                // Buttons to pick image from gallery or take picture
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Upload Image'),
                    ),
                    ElevatedButton(
                      onPressed: _takePicture,
                      child: const Text('Take Picture'),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                // Save Button
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveForm,
                  child: _isSaving
                      ? const CircularProgressIndicator()
                      : const Text('Save Dish'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
