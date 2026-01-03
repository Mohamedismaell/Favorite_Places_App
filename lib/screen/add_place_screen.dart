import 'dart:io';

import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/provider/user_places.dart';
import 'package:favorite_places/widget/image_input.dart';
import 'package:favorite_places/widget/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  File _pickedImage = File('assets/image/noimage.png');
  final _titleController = TextEditingController();
  PlaceLocation? _pickedLocation;
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _setLocation(PlaceLocation location) {
    _pickedLocation = location;
  }

  void _savePlace() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(userPlacesProvider.notifier)
          .addPlace(_titleController.text, _pickedImage, _pickedLocation!);
      _titleController.clear();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Add a New Place'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE3F2FD), Color(0xFFF5F7FA)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: "Title",
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.title,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a title.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  // Improvements to Image Input and Location Input matching the style
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.8)),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        ImageInput(
                          onPickImage: (image) {
                            _pickedImage = image;
                          },
                        ),
                        const SizedBox(height: 16),
                        LocationInput(onSelectLocation: _setLocation),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _savePlace,
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Add Place',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 4,
                      shadowColor: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
