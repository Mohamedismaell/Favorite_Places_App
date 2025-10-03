import 'dart:convert';
import 'dart:async'; // + timeout/async errors
import 'dart:io';

import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/screen/mapbox_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({
    super.key,
    required this.onSelectLocation,
  });

  final void Function(PlaceLocation location)
  onSelectLocation;

  @override
  State<LocationInput> createState() =>
      _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  bool isGettingLocation = false;
  bool _isResolvingAddress = false;

  Future<bool> _ensurePermissions() async {
    final location = Location();
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return false;
    }
    var permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<String?> _reverseGeocode(
    double lat,
    double lng,
  ) async {
    final token = dotenv.env['MAPBOX_ACCESS_TOKEN'];
    if (token == null || token.isEmpty) return null;

    final url = Uri.parse(
      'https://api.mapbox.com/geocoding/v5/mapbox.places/$lng,$lat.json'
      '?access_token=$token&limit=1',
    );

    try {
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 8)); // TIMEOUT
      if (response.statusCode != 200) return null;

      final resData = jsonDecode(response.body);
      final features = resData['features'];
      if (features is List && features.isNotEmpty) {
        return features[0]['place_name'] as String?;
      }
      return null;
    } on TimeoutException {
      return null;
    } on SocketException {
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> generateLocation() async {
    final ok = await _ensurePermissions();
    if (!ok) return;

    setState(() => isGettingLocation = true);
    final locationData = await Location().getLocation();

    if (!mounted) return;
    setState(() => isGettingLocation = false);

    final pickedLocation = await Navigator.of(context)
        .push<PlaceLocation>(
          MaterialPageRoute(
            builder: (ctx) => MapboxScreen(
              lat: locationData.latitude!,
              lng: locationData.longitude!,
            ),
          ),
        );

    if (!mounted || pickedLocation == null) return;

    // Show small spinner while resolving address, but don't block UI
    setState(() => _isResolvingAddress = true);
    final finalAddress = await _reverseGeocode(
      pickedLocation.lat,
      pickedLocation.lng,
    );
    if (!mounted) return;
    setState(() => _isResolvingAddress = false);

    final result = PlaceLocation(
      lat: pickedLocation.lat,
      lng: pickedLocation.lng,
      address: finalAddress,
    );

    setState(() => _pickedLocation = result);
    // Call callback OUTSIDE setState to avoid rebuild-on-dispose issues
    widget.onSelectLocation(result);
  }

  Future<void> _currentLocation() async {
    setState(() => _isResolvingAddress = true);
    final locationData = await Location().getLocation();
    final finalAddress = await _reverseGeocode(
      locationData.latitude!,
      locationData.longitude!,
    );
    if (!mounted) return;
    setState(() => _isResolvingAddress = false);
    final result = PlaceLocation(
      lat: locationData.latitude!,
      lng: locationData.longitude!,
      address: finalAddress,
    );
    setState(() => _pickedLocation = result);
    // Call callback OUTSIDE setState to avoid rebuild-on-dispose issues
    widget.onSelectLocation(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content = TextButton.icon(
      onPressed: generateLocation,
      icon: const Icon(Icons.location_city, size: 30),
      label: Text(
        _pickedLocation == null
            ? 'No Location Chosen'
            : 'Lat: ${_pickedLocation!.lat.toStringAsFixed(5)}, '
                  'Lng: ${_pickedLocation!.lng.toStringAsFixed(5)}'
                  '${_pickedLocation!.address != null ? '\n${_pickedLocation!.address}' : ''}',
        style: theme.textTheme.titleLarge!.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
    );

    if (isGettingLocation || _isResolvingAddress) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

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
              onPressed: generateLocation,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
            const SizedBox(width: 20),
            ElevatedButton.icon(
              onPressed: _currentLocation,
              icon: const Icon(Icons.map),
              label: const Text('Current Location'),
            ),
          ],
        ),
      ],
    );
  }
}
