import 'package:firebase_core/firebase_core.dart';

/// Placeholder Firebase options.
///
/// Replace this file by running:
/// dart pub global activate flutterfire_cli
/// flutterfire configure
///
/// Do not manually commit private keys or service account files.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    throw UnsupportedError(
      'Firebase is not configured yet. Run flutterfire configure to generate real FirebaseOptions.',
    );
  }
}
