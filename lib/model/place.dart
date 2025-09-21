import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  final String id;
  final String title;
  final dynamic image;
  Place({required this.title, required this.image})
    : id = uuid.v4();
}
