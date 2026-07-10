# Luxury Music Streaming App

A premium, enterprise-grade music streaming application built with Flutter.

## Features

*   **Luxury UI/UX:** Stunning, pixel-perfect design inspired by top-tier apps (Apple Music, Spotify, Tidal) featuring Glassmorphism, smooth Hero animations, and premium color palettes.
*   **API Integration:** Real-time search and fetching using the robust **iTunes Search API**.
*   **Offline Mode & SQLite Caching:** Save your favorite songs and create custom playlists stored locally via `sqflite`.
*   **Riverpod State Management:** Clean, predictable, and scalable state management using `flutter_riverpod`.
*   **Clean Architecture:** Strict adherence to Domain-Driven Design (Clean Architecture) principles separating Presentation, Domain, and Data layers.
*   **Audio Playback:** Native 30-second song previews via `audioplayers`.
*   **Debounced Search:** Instant, optimized search with local history tracking.

## Architecture

This project strictly follows **Clean Architecture**:

*   **Presentation Layer:** Contains Riverpod providers, UI Screens, and custom widgets (Glassmorphism cards, skeletons).
*   **Domain Layer:** Contains core Entities (`Song`, `Playlist`), Repositories (Interfaces), and UseCases.
*   **Data Layer:** Contains Remote Data Sources (Dio), Local Data Sources (SQLite), Models (Freezed), and concrete Repository implementations.

## Folder Structure

```
lib/
├── core/
│   ├── constants/
│   ├── routes/
│   ├── theme/
│   └── utils/
├── data/
│   ├── datasource/
│   │   ├── local/
│   │   └── remote/
│   ├── models/
│   └── repository/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── providers/
│   ├── screens/
│   └── widgets/
└── main.dart
```

## Packages Used

*   `flutter_riverpod`: State management
*   `dio`: Networking
*   `sqflite`: Local Database caching
*   `freezed` / `json_serializable`: Data modeling
*   `go_router`: Navigation and Routing
*   `cached_network_image`: Image caching
*   `flutter_animate`: Complex UI animations
*   `audioplayers`: Audio preview playback

## Screenshots Placeholder

*(Insert screenshots of Splash Screen, Home Screen, Detail Screen, and Library here)*

## How to Run

1.  Clone the repository.
2.  Run `flutter pub get`.
3.  (Optional) Run `flutter pub run build_runner build --delete-conflicting-outputs` to regenerate Freezed models if you modify them.
4.  Run `flutter run` on your preferred device (iOS/Android/Desktop).

## Future Improvements

*   Full audio playback with background audio services.
*   User Authentication and Profile management.
*   Lyrics fetching from external API.
