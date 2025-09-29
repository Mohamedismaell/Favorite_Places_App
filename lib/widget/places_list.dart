import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/screen/place_details_screen.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No places added yet. Start adding some!',
          style: Theme.of(context).textTheme.titleLarge!
              .copyWith(
                color: Theme.of(
                  context,
                  // ignore: deprecated_member_use
                ).colorScheme.onSurface.withOpacity(0.7),
              ),
        ),
      );
    }
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 8,
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: FileImage(
                places[index].image,
              ),
              radius: 26,
            ),
            title: Text(
              places[index].title,
              style: Theme.of(context).textTheme.titleLarge!
                  .copyWith(
                    color: Theme.of(
                      context,
                      // ignore: deprecated_member_use
                    ).colorScheme.onSurface,
                  ),
            ),
            subtitle: Text(
              places[index].location.address ??
                  'No address available',
              style: Theme.of(context).textTheme.titleSmall!
                  .copyWith(
                    color:
                        Theme.of(
                          context,
                          // ignore: deprecated_member_use
                        ).colorScheme.onSurface.withOpacity(
                          0.7,
                        ),
                  ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => PlaceDetailsScreen(
                    place: places[index],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
