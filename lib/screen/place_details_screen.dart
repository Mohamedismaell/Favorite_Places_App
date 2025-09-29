import 'package:favorite_places/model/place.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({
    super.key,
    required this.place,
  });

  final Place place;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          place.title,
          style: Theme.of(context).textTheme.titleLarge!
              .copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface,
              ),
        ),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 44,
                horizontal: 24,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent.withOpacity(0.0),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: Text(
                textAlign: TextAlign.center,
                place.location.address ??
                    'There is no selected address for this place',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
