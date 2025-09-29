import 'package:favorite_places/model/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation pickedLoacation;
  const MapScreen({
    super.key,
    required this.pickedLoacation,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng _markerPosition;

  @override
  void initState() {
    super.initState();
    _markerPosition = LatLng(
      widget.pickedLoacation.lat,
      widget.pickedLoacation.lng,
    );
  }

  void _onTapTap(TapPosition tapPosition, LatLng latLng) {
    setState(() {
      _markerPosition = latLng;
    });
    print('Marker position updated: $_markerPosition');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        actions: [
          TextButton.icon(
            onPressed: () =>
                Navigator.of(context).pop(_markerPosition),
            label: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _markerPosition,
          initialZoom: 15.0,
          onTap: _onTapTap,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=DsGz0NdPpQ7jQjYPGlKe', // For demonstration only
            userAgentPackageName:
                'com.example.favorite_places', // Add your app identifier
            // And many more recommended properties!
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _markerPosition,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
          RichAttributionWidget(
            // Include a stylish prebuilt attribution widget that meets all requirments
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => launchUrl(
                  Uri.parse(
                    'https://openstreetmap.org/copyright',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
