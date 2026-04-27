# Vangari Mobile App

Flutter Android-first MVP for Vangari scrap pickup.

## Stack

- Flutter
- Firebase Auth
- Cloud Firestore
- Firebase Storage
- Firebase Analytics
- Firebase Crashlytics
- Google Maps

## MVP roles

- Customer
- Collector
- Admin

Admin email for MVP: munimm247@gmail.com

## First build order

1. Phone OTP login
2. Bengali-first pickup request flow
3. Scrap category and weight estimate
4. Location and address collection
5. Firestore order creation
6. Admin order list
7. Manual collector assignment
8. Collector status updates
9. Payment proof upload
10. Reviews and WhatsApp support

## Setup

Run from this folder:

```bash
flutter pub get
flutter run
```

Firebase files are not committed yet. Add them after creating the Firebase project:

- android/app/google-services.json
- ios/Runner/GoogleService-Info.plist, only when iOS is added

Use FlutterFire CLI later:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
