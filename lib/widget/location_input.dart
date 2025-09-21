import 'package:favorite_places/screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() =>
      _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  bool isGettingLocation = false;
  double? _lat;
  double? _lng;
  void generateLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location
          .requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      isGettingLocation = true;
    });
    locationData = await location.getLocation();
    setState(() {
      isGettingLocation = false;
      _lat = locationData.latitude;
      _lng = locationData.longitude;
    });

    // Now _lat and _lng are set, so open the map screen
    if (_lat != null && _lng != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) =>
              MapScreen(lat: _lat!, lng: _lng!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: () => generateLocation(),
      label: Text(
        'No Location Chosen',
        style: Theme.of(context).textTheme.titleLarge!
            .copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface,
            ),
      ),
      icon: const Icon(Icons.location_city, size: 30),
    );

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 250,
          child: content,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => generateLocation(),
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () => generateLocation(),
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }
}
