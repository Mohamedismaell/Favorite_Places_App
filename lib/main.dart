import 'package:favorite_places/screen/places_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color(0xFF4A90E2), // Primary Blue
  surface: const Color(
    0xFFF5F7FA,
  ), // Soft Grey-White background for contrast with white glass
  secondary: const Color(0xFFFFFFFF),
);

final theme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: colorScheme.surface,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.interTextTheme().copyWith(
    titleSmall: GoogleFonts.inter(fontWeight: FontWeight.bold),
    titleMedium: GoogleFonts.inter(fontWeight: FontWeight.bold),
    titleLarge: GoogleFonts.inter(fontWeight: FontWeight.bold),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    iconTheme: const IconThemeData(color: Colors.black87),
  ),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // <-- FIXED: Ensure Flutter binding is initialized
  await setup();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> setup() async {
  await dotenv.load(fileName: ".env");
  MapboxOptions.setAccessToken(dotenv.env['MAPBOX_ACCESS_TOKEN']!);
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
