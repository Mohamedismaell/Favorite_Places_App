import 'dart:io';

import 'package:favorite_places/provider/user_places.dart';
import 'package:favorite_places/widget/image_input.dart';
import 'package:favorite_places/widget/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() =>
      _AddPlaceScreenState();
}

class _AddPlaceScreenState
    extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  final _titleController = TextEditingController();
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _savePlace() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(userPlacesProvider.notifier)
          .addPlace(_titleController.text, _pickedImage!);
      _titleController.clear();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final TextEditingController titleController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Add a New Place')),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle:
                      Theme.of(
                        context,
                      ).textTheme.titleLarge!.copyWith(
                        color: Theme.of(
                          context,
                          // ignore: deprecated_member_use
                        ).colorScheme.onSurface.withOpacity(0.5),
                      ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter a title.';
                  }
                  return null;
                },
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(
                      color:
                          Theme.of(
                            context,
                            // ignore: deprecated_member_use
                          ).colorScheme.onSurface.withOpacity(
                            0.8,
                          ),
                    ),
              ),
              SizedBox(height: 16),

              ImageInput(
                onPickImage: (image) {
                  _pickedImage = image;
                },
              ),
              SizedBox(height: 16),
              LocationInput(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _savePlace();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add),
                    const Text('Add Place'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
