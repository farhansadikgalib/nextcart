# NextCart

A full-featured e-commerce app built with Flutter, Firebase, and Clean Architecture.

<div align="center">

[![Download APK](https://img.shields.io/badge/Download_APK-v1.0.0-brightgreen?style=for-the-badge&logo=android&logoColor=white)](assets/apk/nextcart-v1.0.0.apk)

</div>

## Tech Stack

- **Flutter** (Dart 3.8+) -- cross-platform (Android, iOS, Web)
- **Firebase** -- Auth, Firestore, Cloud Storage, Cloud Messaging
- **Riverpod** -- state management (with code generation)
- **GoRouter** -- declarative routing with auth guards (StatefulShellRoute)
- **Freezed** -- immutable data models
- **Dio** -- HTTP networking
- **GNav** -- modern bottom navigation bar
- **Local Notifications** -- push notifications for order status updates
- **Material Design 3** -- green-themed UI with responsive layout (ScreenUtil)

## Features

- Google Sign-In & Firebase Authentication
- Product browsing by categories
- Product search
- Shopping cart management
- Wishlist
- Checkout flow
- Order history & tracking
- Push notifications on order status changes (pending, confirmed, shipped, delivered, cancelled)
- In-app notification center with unread badge
- User profile & address management
- Onboarding flow for new users

## Project Structure

```
lib/
├── app/                # Router, routes, navigation shell
├── core/               # DI providers, theme, storage, utils, shared widgets
├── features/           # Feature modules (Clean Architecture)
│   ├── auth/           #   Authentication
│   ├── home/           #   Home screen
│   ├── categories/     #   Product categories
│   ├── products/       #   Product listings
│   ├── product_detail/ #   Product detail view
│   ├── cart/           #   Shopping cart
│   ├── checkout/       #   Checkout process
│   ├── orders/         #   Order management
│   ├── notifications/  #   Push & in-app notifications
│   ├── wishlist/       #   Wishlist
│   ├── profile/        #   User profile
│   └── search/         #   Product search
└── shared/             # App-wide shared widgets
```

Each feature follows the **data / domain / presentation** layer split.

## Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- Dart 3.8+
- Android Studio / Xcode (for emulators)
- A Firebase project (see [Firebase setup docs](https://firebase.google.com/docs/flutter/setup))

### Setup

```bash
# Clone the repo
git clone <repo-url>
cd nextcart

# Install dependencies
flutter pub get

# Run code generation (Freezed, Riverpod, JSON serialization)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Useful Commands

```bash
# Watch mode for code generation (re-runs on file changes)
dart run build_runner watch --delete-conflicting-outputs

# Run linter
flutter analyze

# Run tests
flutter test

# Build release APK
flutter build apk

# Build for iOS
flutter build ios

# Build for web
flutter build web
```

## Firebase Setup

The app uses the following Firebase services:

| Service | Purpose |
|---------|---------|
| Firebase Auth | User authentication (email, Google Sign-In) |
| Cloud Firestore | Product catalog, orders, cart, notifications, user data |
| Cloud Storage | Product images and assets |
| Cloud Messaging | Push notification permissions and token management |

Firestore security rules allow public reads for products/categories and user-scoped writes for carts, orders, and notifications. See [firestore.rules](firestore.rules) and [storage.rules](storage.rules).

### Notifications

When an order status changes in Firestore, the app:
1. Detects the change via a real-time orders stream listener
2. Writes a notification document to `users/{uid}/notifications/`
3. Shows a local push notification on the device
4. Tapping the notification navigates to the order detail screen

## Architecture

The app follows **Clean Architecture** with three layers per feature:

1. **Data** -- repository implementations (Firebase, API calls)
2. **Domain** -- models (Freezed classes), repository interfaces
3. **Presentation** -- UI widgets, ViewModels (Riverpod providers)

Dependency injection is handled via Riverpod providers in `core/di/`.

## License

This project is private and not licensed for redistribution.
