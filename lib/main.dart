import 'package:favorite_places/screen/places_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 102, 6, 247),
  surface: const Color.fromARGB(255, 56, 49, 66),
);

final theme = ThemeData().copyWith(
  scaffoldBackgroundColor: colorScheme.surface,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.ubuntuCondensedTextTheme()
      .copyWith(
        titleSmall: GoogleFonts.ubuntuCondensed(
          fontWeight: FontWeight.bold,
        ),
        titleMedium: GoogleFonts.ubuntuCondensed(
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.ubuntuCondensed(
          fontWeight: FontWeight.bold,
        ),
      ),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // <-- FIXED: Ensure Flutter binding is initialized
  await setup();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> setup() async {
  await dotenv.load(fileName: ".env");
  MapboxOptions.setAccessToken(
    dotenv.env['MAPBOX_ACCESS_TOKEN']!,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Great Places',
      theme: theme,
      home: PlacesScreen(),
    );
  }
}
