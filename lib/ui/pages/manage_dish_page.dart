import 'dart:developer';
import 'dart:typed_data';
import 'package:colibri_shared/application/providers/restaurant_providers.dart';
import 'package:colibri_shared/application/providers/storage_providers.dart';
import 'package:colibri_shared/domain/models/dish.dart';
import 'package:colibri_shared/domain/models/restaurant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

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

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final List<dynamic> _newImages =
      []; // Holds File for mobile, Uint8List for web
  List<String> _existingImageUrls = [];
  final List<String> _imagesToDelete = [];

  @override
  void initState() {
    super.initState();
    if (widget.dish != null) {
      nameController.text = widget.dish!.name;
      descriptionController.text = widget.dish!.description;
      priceController.text = widget.dish!.price.toString();
      _existingImageUrls = List.from(widget.dish!.images);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageBytes =
          await pickedFile.readAsBytes(); // Use bytes for both platforms
      setState(() {
        _newImages.add(imageBytes);
      });
    }
  }

  Future<void> _takePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _newImages.add(imageBytes);
      });
    }
  }

  void _markImageForDeletion(String imageUrl) {
    setState(() {
      _existingImageUrls.remove(imageUrl);
      _imagesToDelete.add(imageUrl);
    });
  }

  void _deleteNewImage(int index) {
    setState(() {
      _newImages.removeAt(index);
    });
  }

  Future<void> _saveForm() async {
    setState(() {
      _isSaving = true;
    });

    if (_formKey.currentState!.validate()) {
      final dishService = ref.read(dishServiceProvider);
      final storageService = ref.read(storageServiceProvider);

      String name = nameController.text;
      String description = descriptionController.text;
      double? price = double.tryParse(priceController.text);
      if (price == null) {
        setState(() {
          _isSaving = false;
        });
        return;
      }

      List<String> finalImageUrls = List.from(_existingImageUrls);
      String dishId;
      if (widget.dish == null) {
        final newDish = Dish(
          id: '',
          restaurantId: widget.restaurant.id!,
          name: name,
          description: description,
          price: price,
          images: [],
          baseIngredients: null,
          extraIngredients: null,
          removableIngredients: null,
          isAvailable: null,
        );

        final createdDish = await dishService.create(newDish);
        dishId = createdDish.id;
      } else {
        dishId = widget.dish!.id;
      }

      for (var imageUrl in _imagesToDelete) {
        await storageService.deleteFileFromUrl(imageUrl);
      }

      for (var imageBytes in _newImages) {
        final uniqueFileName =
            '${DateTime.now().millisecondsSinceEpoch}.jpg'; // Generate a unique filename
        final uploadedImageUrl = await storageService.uploadFile(
          'dishes/$dishId',
          uniqueFileName,
          'jpg', // You can specify the format as 'jpg' or 'png'
          imageBytes,
        );
        finalImageUrls.add(uploadedImageUrl);
      }

      final updatedDish = Dish(
        id: dishId,
        restaurantId: widget.restaurant.id!,
        name: name,
        description: description,
        price: price,
        images: finalImageUrls,
        baseIngredients: widget.dish?.baseIngredients,
        extraIngredients: widget.dish?.extraIngredients,
        removableIngredients: widget.dish?.removableIngredients,
        isAvailable: widget.dish?.isAvailable,
      );

      await dishService.update(updatedDish, dishId);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    }

    setState(() {
      _isSaving = false;
    });
  }

  Future<void> _deleteDish() async {
    final dishService = ref.read(dishServiceProvider);
    final storageService = ref.read(storageServiceProvider);

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(FlutterI18n.translate(context, 'manage_dish.delete_dish')),
        content: Text(
            FlutterI18n.translate(context, 'manage_dish.delete_dish_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(FlutterI18n.translate(context, 'manage_dish.cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(FlutterI18n.translate(context, 'manage_dish.delete')),
          ),
        ],
      ),
    );

    if (shouldDelete != true) {
      return;
    }

    try {
      for (String imageUrl in widget.dish!.images) {
        await storageService.deleteFileFromUrl(imageUrl);
      }
      await dishService.delete(widget.dish!.id);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      log('Error deleting dish: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, 'manage_dish.manage_dish')),
        actions: widget.dish != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: _deleteDish,
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
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText:
                        FlutterI18n.translate(context, 'manage_dish.dish_name'),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return FlutterI18n.translate(
                          context, 'manage_dish.enter_dish_name');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: FlutterI18n.translate(
                        context, 'manage_dish.description'),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return FlutterI18n.translate(
                          context, 'manage_dish.enter_description');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText:
                        FlutterI18n.translate(context, 'manage_dish.price'),
                    border: OutlineInputBorder(),
                    prefixText: 'Q',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return FlutterI18n.translate(
                          context, 'manage_dish.enter_price');
                    }
                    if (double.tryParse(value) == null) {
                      return FlutterI18n.translate(
                          context, 'manage_dish.valid_price');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                if (_existingImageUrls.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        FlutterI18n.translate(
                            context, 'manage_dish.existing_images'),
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
                Text(
                  FlutterI18n.translate(context, 'manage_dish.new_images'),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _newImages.map((image) {
                    int index = _newImages.indexOf(image);
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.memory(
                            image as Uint8List,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text(FlutterI18n.translate(
                          context, 'manage_dish.upload_image')),
                    ),
                    ElevatedButton(
                      onPressed: _takePicture,
                      child: Text(FlutterI18n.translate(
                          context, 'manage_dish.take_picture')),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveForm,
                  child: _isSaving
                      ? CircularProgressIndicator()
                      : Text(FlutterI18n.translate(
                          context, 'manage_dish.save_dish')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
