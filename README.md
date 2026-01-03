# Favorite Places - Flutter App

A modern, fast, and beautiful mobile application built with Flutter that allows users to capture, store, and manage their favorite locations. The app features a stunning **Glassmorphism UI**, real-time location tracking, and utilizing **Mapbox** for maps.

---

## ✨ Features

- **📍 Track Locations**: Automatically detect your current location or select a custom position on the map using **Mapbox**.
- **📸 Capture Memories**: Take photos of your favorite spots using the device camera.
- **💾 Local Storage**: Persist your places locally using **SQLite**, ensuring your data is safe even when offline.
- **🗺️ Interactive Maps**: View your saved places and their exact locations on an interactive map.
- **📱 Responsive Layout**: Fully responsive design that works seamlessly on both Android and iOS.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
- **Maps**: [mapbox_maps_flutter](https://pub.dev/packages/mapbox_maps_flutter)
- **Location**: [location](https://pub.dev/packages/location) & [geolocator](https://pub.dev/packages/geolocator)
- **Database**: [sqflite](https://pub.dev/packages/sqflite) (SQLite)
- **Camera**: [image_picker](https://pub.dev/packages/image_picker)
- **Fonts**: [google_fonts](https://pub.dev/packages/google_fonts)
- **Environment**: [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)

## 📸 Screenshots

<markdown-accessiblity-table data-catalyst=""><table>
<tbody>
<tr>
<td> <img src="https://github.com/user-attachments/assets/ec3b0fae-40db-4311-9254-ac6330e0a24a" width="300" style="max-width: 100%;"></td>
<td><img src="https://github.com/user-attachments/assets/04185b28-f2b1-4958-992b-9813ab5ae338" width="300" style="max-width: 100%;"></td>
<td><img src="https://github.com/user-attachments/assets/6776ea21-5250-4ecb-b11c-54180dc464f1" width="300" style="max-width: 100%;"></td>
</tr>
</tbody>


## 🚀 Getting Started

### Prerequisites

- Flutter SDK installed (Version 3.8.0 or higher recommended)
- Android Studio / Xcode for emulators
- A **Mapbox** Access Token

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/Mohamedismaell/Favorite_Places_App.git
   cd Favorite_Places_App
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure Mapbox**

   - Get your Public Access Token from [Mapbox](https://www.mapbox.com/).
   - Create a `.env` file in the root directory:
     ```text
     MAPBOX_ACCESS_TOKEN=pk.eyJ1I...<your_token_here>
     ```
   - _Note: Ensure your Android/iOS configurations for Mapbox (permissions, manifest/plist) are set up._

4. **Run the App**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

```
lib/
├── model/           # Data models (Place, PlaceLocation)
├── provider/        # Riverpod providers (UserPlaces)
├── screen/          # App screens (Places List, Add Place, Details, Map)
├── widget/          # Reusable widgets (GlassContainer, ImageInput, etc.)
└── main.dart        # Entry point and Theme setup
```


Developed with ❤️ using Flutter.
