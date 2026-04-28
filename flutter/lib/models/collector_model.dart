import 'package:cloud_firestore/cloud_firestore.dart';

class CollectorModel {
  final String uid;
  final String name;
  final String phone;
  final List<String> areas;
  final bool isAvailable;
  final bool isVerified;
  final double rating;
  final int totalPickups;

  CollectorModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.areas,
    required this.isAvailable,
    required this.isVerified,
    required this.rating,
    required this.totalPickups,
  });

  factory CollectorModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return CollectorModel(
      uid: doc.id,
      name: d['name'] ?? '',
      phone: d['phone'] ?? '',
      areas: List<String>.from(d['areas'] ?? []),
      isAvailable: d['isAvailable'] ?? true,
      isVerified: d['isVerified'] ?? false,
      rating: (d['rating'] ?? 5.0).toDouble(),
      totalPickups: (d['totalPickups'] ?? 0).toInt(),
    );
  }
}
