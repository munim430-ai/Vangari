import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final String? collectorId;
  final String status; // pending | assigned | picked | paid | cancelled
  final List<String> categories;
  final double estimatedPrice;
  final double? finalPrice;
  final double? estimatedWeight;
  final String pickupAddress;
  final String area;
  final String? photoUrl;
  final String? aiDescription;
  final String? paymentMethod; // bkash | nagad
  final String? paymentNumber;
  final String? paymentProofUrl;
  final double? userRating;
  final String? userReview;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? scheduledAt;

  OrderModel({
    required this.id,
    required this.userId,
    this.collectorId,
    required this.status,
    required this.categories,
    required this.estimatedPrice,
    this.finalPrice,
    this.estimatedWeight,
    required this.pickupAddress,
    required this.area,
    this.photoUrl,
    this.aiDescription,
    this.paymentMethod,
    this.paymentNumber,
    this.paymentProofUrl,
    this.userRating,
    this.userReview,
    required this.createdAt,
    this.updatedAt,
    this.scheduledAt,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: d['userId'] ?? '',
      collectorId: d['collectorId'],
      status: d['status'] ?? 'pending',
      categories: List<String>.from(d['categories'] ?? []),
      estimatedPrice: (d['estimatedPrice'] ?? 0).toDouble(),
      finalPrice: d['finalPrice']?.toDouble(),
      estimatedWeight: d['estimatedWeight']?.toDouble(),
      pickupAddress: d['pickupAddress'] ?? '',
      area: d['area'] ?? '',
      photoUrl: d['photoUrl'],
      aiDescription: d['aiDescription'],
      paymentMethod: d['paymentMethod'],
      paymentNumber: d['paymentNumber'],
      paymentProofUrl: d['paymentProofUrl'],
      userRating: d['userRating']?.toDouble(),
      userReview: d['userReview'],
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (d['updatedAt'] as Timestamp?)?.toDate(),
      scheduledAt: (d['scheduledAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': userId,
    if (collectorId != null) 'collectorId': collectorId,
    'status': status,
    'categories': categories,
    'estimatedPrice': estimatedPrice,
    if (finalPrice != null) 'finalPrice': finalPrice,
    if (estimatedWeight != null) 'estimatedWeight': estimatedWeight,
    'pickupAddress': pickupAddress,
    'area': area,
    if (photoUrl != null) 'photoUrl': photoUrl,
    if (aiDescription != null) 'aiDescription': aiDescription,
    if (paymentMethod != null) 'paymentMethod': paymentMethod,
    if (paymentNumber != null) 'paymentNumber': paymentNumber,
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  };
}
