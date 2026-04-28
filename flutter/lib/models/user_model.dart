import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String phone;
  final String name;
  final String role; // 'user' | 'collector' | 'admin'
  final int points;
  final List<String> badges;
  final String referralCode;
  final String? referredBy;
  final String address;
  final bool isVerified;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.phone,
    required this.name,
    required this.role,
    required this.points,
    required this.badges,
    required this.referralCode,
    this.referredBy,
    required this.address,
    required this.isVerified,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      phone: d['phone'] ?? '',
      name: d['name'] ?? 'ব্যবহারকারী',
      role: d['role'] ?? 'user',
      points: (d['points'] ?? 0).toInt(),
      badges: List<String>.from(d['badges'] ?? ['Eco Starter']),
      referralCode: d['referralCode'] ?? '',
      referredBy: d['referredBy'],
      address: d['address'] ?? '',
      isVerified: d['isVerified'] ?? false,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'phone': phone,
    'name': name,
    'role': role,
    'points': points,
    'badges': badges,
    'referralCode': referralCode,
    if (referredBy != null) 'referredBy': referredBy,
    'address': address,
    'isVerified': isVerified,
    'createdAt': FieldValue.serverTimestamp(),
  };

  UserModel copyWith({String? name, String? address, int? points, List<String>? badges}) {
    return UserModel(
      uid: uid, phone: phone, role: role, referralCode: referralCode,
      referredBy: referredBy, isVerified: isVerified, createdAt: createdAt,
      name: name ?? this.name,
      address: address ?? this.address,
      points: points ?? this.points,
      badges: badges ?? this.badges,
    );
  }
}
