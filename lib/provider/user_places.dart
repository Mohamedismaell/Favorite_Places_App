import 'dart:io';
import 'package:favorite_places/model/place.dart';
import 'package:flutter_riverpod/legacy.dart';

class UserPlacesNotifier
    extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);
  void addPlace(String place, File image) {
    final newPlace = Place(title: place, image: image);
    state = [...state, newPlace];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
      (ref) => UserPlacesNotifier(),
    );
