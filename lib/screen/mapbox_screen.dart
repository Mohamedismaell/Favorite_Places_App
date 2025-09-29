// import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'dart:async';
import 'dart:typed_data';
import 'package:favorite_places/model/place.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:location/location.dart';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapboxScreen extends StatefulWidget {
  MapboxScreen({
    super.key,
    required this.lat,
    required this.lng,
  });
  double lat;
  double lng;
  @override
  State<MapboxScreen> createState() => _MapboxScreenState();
}

class _MapboxScreenState extends State<MapboxScreen> {
  MapboxMap? _mapboxMapController;
  Location? _location;
  StreamSubscription<LocationData>? _locationSubscription;
  PointAnnotationManager? _pointAnnotationManager;
  PointAnnotation? _marker;
  bool _isFollowing = false;

  void _onMapCreated(MapboxMap controller) async {
    setState(() {
      _mapboxMapController = controller;
    });

    _mapboxMapController?.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingColor: Colors.red.value,
        pulsingEnabled: true,
      ),
    );

    _location = Location();
    _pointAnnotationManager = await _mapboxMapController
        ?.annotations
        .createPointAnnotationManager();

    // Load marker image

    creatingMarker(widget.lng, widget.lat);
  }

  void creatingMarker(double lng, double lat) async {
    final ByteData bytes = await rootBundle.load(
      'assets/image/location.png',
    );
    final Uint8List imageData = bytes.buffer.asUint8List();

    final pointAnnotationOptions = PointAnnotationOptions(
      geometry: Point(coordinates: Position(lng, lat)),
      image: imageData,
      iconSize: 0.25,
    );
    _marker = await _pointAnnotationManager?.create(
      pointAnnotationOptions,
    );
  }

  Future<void> toggleFollowingLocation() async {
    if (_isFollowing) {
      // Stop following
      await _locationSubscription?.cancel();
      _locationSubscription = null;
      setState(() {
        _isFollowing = false;
      });
    } else {
      // Start following
      _locationSubscription = _location!.onLocationChanged
          .listen((locationData) async {
            if (locationData.accuracy != null &&
                locationData.accuracy! <= 10) {
              widget.lat = locationData.latitude!;
              widget.lng = locationData.longitude!;

              // Move camera
              await _mapboxMapController?.setCamera(
                CameraOptions(
                  center: Point(
                    coordinates: Position(
                      widget.lng,
                      widget.lat,
                    ),
                  ),
                  zoom: 15,
                ),
              );

              // Remove previous marker
              if (_marker != null) {
                await _pointAnnotationManager?.delete(
                  _marker!,
                );
              }

              creatingMarker(widget.lng, widget.lat);
            }
          });
      setState(() {
        _isFollowing = true;
      });
    }
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final camera = CameraOptions(
      center: Point(
        coordinates: Position(widget.lng, widget.lat),
      ),
      zoom: 15,
      bearing: 0,
      pitch: 0,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapbox Map'),
        actions: [
          TextButton.icon(
            label: const Text(
              'Save Location',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop(
                PlaceLocation(
                  lat: widget.lat,
                  lng: widget.lng,
                ),
              );
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: MapWidget(
        onMapCreated: (controller) {
          _onMapCreated(controller);
        },
        onTapListener: (context) async {
          if (_mapboxMapController != null) {
            widget.lng = context.point.coordinates.lng
                .toDouble();
            widget.lat = context.point.coordinates.lat
                .toDouble();

            if (_marker != null) {
              await _pointAnnotationManager?.delete(
                _marker!,
              );
            }
            print(
              'Tapped at: (${widget.lng}, ${widget.lat})',
            );
            creatingMarker(widget.lng, widget.lat);
          }
        },
        cameraOptions: camera,
        styleUri: MapboxStyles.STANDARD_SATELLITE,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleFollowingLocation,
        child: Icon(
          _isFollowing
              ? Icons.location_disabled
              : Icons.my_location,
        ),
      ),
    );
  }
}
