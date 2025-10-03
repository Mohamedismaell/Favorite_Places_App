import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/screen/mapbox_screen.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

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

  // String? _previewImageUrl;
  // String staticMapImageUrl(double lat, double lng) {
  //   return 'https://api.mapbox.com/styles/v1/mapbox/streets-v12/static/$lng,$lat,15,0,0/600x300@2x?access_token=pk.eyJ1IjoiZ29vZHNhbnRhIiwiYSI6ImNtZnhpMmwwODA1c3oyaXM3bXBnandremgifQ.CRy55JBebTNe0vP6fJn5xQ';
  // }

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
    //edite this denied error
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
      _pickedLocation = PlaceLocation(
        lat: locationData.latitude!,
        lng: locationData.longitude!,
      );
    });
    // ignore: use_build_context_synchronously
    final pickedLocation = await Navigator.of(context)
        .push<PlaceLocation>(
          MaterialPageRoute(
            builder: (ctx) => MapboxScreen(
              lat: _pickedLocation!.lat,
              lng: _pickedLocation!.lng,
            ),
          ),
        );

    if (pickedLocation != null) {
      setState(() {
        _pickedLocation = pickedLocation;
      });

      // final url =
      //     'https://api.mapbox.com/search/geocode/v6/reverse?longitude=${pickedLocation.lng}&latitude=${pickedLocation.lat}&access_token=pk.eyJ1IjoiZ29vZHNhbnRhIiwiYSI6ImNtZnhpam1vdzBhZGMybHNocWswaWtta2gifQ.lzPs5DuCSEz6d-vZGjQqcg';

      // final response = await http.get(Uri.parse(url));
      // final resData = json.decode(response.body);
      // final address =
      //     resData['features'][0]['full_address'];

      widget.onSelectLocation(_pickedLocation!);
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
    // if (_previewImageUrl != null) {
    //   print("Image is not null ");
    //   print("Mapbox URL: $_previewImageUrl");
    //   content = Image.network(
    //     _previewImageUrl!,
    //     // fit: BoxFit.cover,
    //     // width: double.infinity,
    //     // height: 250,
    //     loadingBuilder: (context, child, progress) {
    //       if (progress == null) return child;
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     },
    //     errorBuilder: (context, error, stackTrace) {
    //       return const Center(
    //         child: Text(
    //           'Failed to load image',
    //           style: TextStyle(color: Colors.red),
    //         ),
    //       );
    //     },
    //   );
    // }

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
            // ElevatedButton.icon(
            //   onPressed: () => generateLocation(),
            //   icon: const Icon(Icons.location_on),
            //   label: const Text('Current Location'),
            // ),
            // const SizedBox(width: 10),
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
