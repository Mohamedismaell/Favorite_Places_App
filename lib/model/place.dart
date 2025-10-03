import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {
  final double lat;
  final double lng;
  String? address;
  PlaceLocation({
    required this.lat,
    required this.lng,
    this.address,
  });
}

class Place {
  Place({
    required this.title,
    required this.image,
    required this.location,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final dynamic image;
  final PlaceLocation location;
}
