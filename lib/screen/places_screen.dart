import 'package:favorite_places/provider/user_places.dart';
import 'package:favorite_places/screen/add_place_screen.dart';
import 'package:favorite_places/widget/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() =>
      PlacesListScreen();
}

class PlacesListScreen extends ConsumerState<PlacesScreen> {
  void _goToAddPlace() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => AddPlaceScreen()),
    );
  }

  late Future<void> _placesFutuer;
  @override
  void initState() {
    super.initState();

    _placesFutuer = ref
        .read(userPlacesProvider.notifier)
        .loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Great Places'),
        actions: [
          IconButton(
            onPressed: () {
              _goToAddPlace();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _placesFutuer,
        builder: (context, snapshot) =>
            snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : PlacesList(places: userPlaces),
      ),
    );
  }
}
