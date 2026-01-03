import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/screen/place_details_screen.dart';
import 'package:favorite_places/widget/glass_container.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.place_outlined,
              size: 64,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No places added yet.',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start by adding your favorite spots!',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.black45),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: places.length,
      padding: const EdgeInsets.only(
        top: 100,
        bottom: 20,
      ), // Add top padding for behind the app bar
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => PlaceDetailsScreen(place: places[index]),
                ),
              );
            },
            child: GlassContainer(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              opacity: 0.6,
              borderRadius: BorderRadius.circular(20),
              child: Row(
                children: [
                  Hero(
                    tag: places[index].id,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: FileImage(places[index].image),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          places[index].title,
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(
                                color: const Color(0xFF2D3436),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                places[index].location.address ??
                                    'No address', // Fixed null check
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(color: Colors.grey[600]),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
