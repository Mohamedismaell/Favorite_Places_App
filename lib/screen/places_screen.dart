import 'dart:ui';
import 'package:favorite_places/provider/user_places.dart';
import 'package:favorite_places/screen/add_place_screen.dart';
import 'package:favorite_places/widget/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() => PlacesListScreen();
}

class PlacesListScreen extends ConsumerState<PlacesScreen> {
  void _goToAddPlace() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => AddPlaceScreen()));
  }

  late Future<void> _placesFutuer;
  @override
  void initState() {
    super.initState();

    _placesFutuer = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);
    return Scaffold(
      backgroundColor: Colors.transparent, // Allow gradient to show
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('My Favorite Places'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.white.withOpacity(0.2)),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                _goToAddPlace();
              },
              icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE3F2FD), // Light Blue
              Color(0xFFF5F7FA), // White/Grey
            ],
          ),
        ),
        child: FutureBuilder(
          future: _placesFutuer,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : PlacesList(places: userPlaces),
        ),
      ),
    );
  }
}
