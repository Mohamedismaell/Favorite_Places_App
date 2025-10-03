import 'dart:io';
import 'package:favorite_places/model/place.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:path_provider/path_provider.dart'
    as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDataBase() async {
  final dbpath = await sql.getDatabasesPath();
  final dp = await sql.openDatabase(
    path.join(dbpath, 'place.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_places (id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)',
      );
    },
    version: 1,
  );

  return dp;
}

class UserPlacesNotifier
    extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final dp = await _getDataBase();
    final data = await dp.query('user_places');
    final places = data.map((row) {
      return Place(
        id: row['id'] as String,
        title: row['title'] as String,
        image: File(row['image'] as String),
        location: PlaceLocation(
          lat: row['lat'] as double,
          lng: row['lng'] as double,
          address: row['address'] as String,
        ),
      );
    }).toList();
    state = places;
  }

  void addPlace(
    String place,
    File image,
    PlaceLocation location,
  ) async {
    final appDir = await syspath
        .getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy(
      '${appDir.path}/$fileName',
    );
    final newPlace = Place(
      title: place,
      image: copiedImage,
      location: location,
    );
    final dp = await _getDataBase();
    await dp.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.lat,
      'lng': newPlace.location.lng,
      'address': newPlace.location.address,
    });
    state = [...state, newPlace];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
      (ref) => UserPlacesNotifier(),
    );
