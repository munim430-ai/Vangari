import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/user_model.dart';
import '../models/order_model.dart';
import '../models/collector_model.dart';
import '../utils/constants.dart';

class FirebaseService {
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;
  static final _storage = FirebaseStorage.instance;

  // ── Auth ──────────────────────────────────────────────────────────────────

  static Future<ConfirmationResult> sendOtp(String phone) =>
      _auth.signInWithPhoneNumber(phone);

  static Future<UserCredential> verifyOtp(
    ConfirmationResult result, String smsCode) =>
      result.confirm(smsCode);

  static Future<void> signOut() => _auth.signOut();

  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── User Profile ──────────────────────────────────────────────────────────

  static Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  static Stream<UserModel?> userStream(String uid) =>
      _db.collection('users').doc(uid).snapshots().map(
        (doc) => doc.exists ? UserModel.fromFirestore(doc) : null,
      );

  static Future<UserModel> createUser(String uid, String phone) async {
    final code = _generateReferralCode();
    final user = UserModel(
      uid: uid,
      phone: phone,
      name: 'ব্যবহারকারী',
      role: 'user',
      points: 0,
      badges: ['Eco Starter'],
      referralCode: code,
      address: '',
      isVerified: false,
      createdAt: DateTime.now(),
    );
    await _db.collection('users').doc(uid).set(user.toMap());
    return user;
  }

  static Future<void> updateUser(String uid, Map<String, dynamic> data) =>
      _db.collection('users').doc(uid).update({...data, 'updatedAt': FieldValue.serverTimestamp()});

  // ── Orders ────────────────────────────────────────────────────────────────

  static Stream<List<OrderModel>> userOrdersStream(String uid) =>
      _db.collection('orders')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map(OrderModel.fromFirestore).toList());

  static Stream<List<OrderModel>> allOrdersStream() =>
      _db.collection('orders')
        .orderBy('createdAt', descending: true)
        .limit(100)
        .snapshots()
        .map((s) => s.docs.map(OrderModel.fromFirestore).toList());

  static Stream<List<OrderModel>> pendingOrdersStream() =>
      _db.collection('orders')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map(OrderModel.fromFirestore).toList());

  static Future<String> createOrder(Map<String, dynamic> data) async {
    final ref = await _db.collection('orders').add({
      ...data,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  static Future<void> updateOrderStatus(String orderId, String status,
      {Map<String, dynamic>? extra}) =>
      _db.collection('orders').doc(orderId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
        if (extra != null) ...extra,
      });

  static Future<void> assignCollector(String orderId, String collectorId) =>
      _db.collection('orders').doc(orderId).update({
        'collectorId': collectorId,
        'status': 'assigned',
        'updatedAt': FieldValue.serverTimestamp(),
      });

  // ── Collectors ────────────────────────────────────────────────────────────

  static Stream<List<CollectorModel>> collectorsStream() =>
      _db.collection('users')
        .where('role', isEqualTo: 'collector')
        .snapshots()
        .map((s) => s.docs.map(CollectorModel.fromFirestore).toList());

  // ── Pricing ───────────────────────────────────────────────────────────────

  static Future<Map<String, double>> getPricing() async {
    final docs = await _db.collection('pricing').get();
    final map = <String, double>{};
    for (final doc in docs.docs) {
      map[doc.id] = (doc.data()['pricePerKg'] ?? 0).toDouble();
    }
    // fallback to constants if Firestore is empty
    if (map.isEmpty) {
      for (final c in kScrapCategories) {
        map[c.id] = c.pricePerKg;
      }
    }
    return map;
  }

  static Future<void> updatePricing(String categoryId, double price) =>
      _db.collection('pricing').doc(categoryId).set({'pricePerKg': price, 'updatedAt': FieldValue.serverTimestamp()});

  // ── Storage ───────────────────────────────────────────────────────────────

  static Future<String> uploadPhoto(String uid, File file) async {
    final path = 'orders/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref().child(path);
    await ref.putFile(file);
    return ref.getDownloadURL();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static String _generateReferralCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(6, (_) {
      final idx = DateTime.now().microsecondsSinceEpoch % chars.length;
      return chars[idx];
    }).join();
  }

  static Future<void> applyReferral(String uid, String code) async {
    final query = await _db.collection('users')
        .where('referralCode', isEqualTo: code).limit(1).get();
    if (query.docs.isNotEmpty) {
      final referrerId = query.docs.first.id;
      await _db.collection('users').doc(referrerId).update({
        'points': FieldValue.increment(50),
      });
      await _db.collection('users').doc(uid).update({
        'referredBy': referrerId,
        'points': FieldValue.increment(25),
      });
    }
  }
}
