import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'firebase_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unknown;
  UserModel? _userModel;
  ConfirmationResult? _confirmationResult;

  AuthStatus get status => _status;
  UserModel? get user => _userModel;
  bool get isAdmin => _userModel?.role == 'admin';
  bool get isLoggedIn => _status == AuthStatus.authenticated;

  AuthProvider() {
    FirebaseService.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = AuthStatus.unauthenticated;
      _userModel = null;
    } else {
      _status = AuthStatus.authenticated;
      _userModel = await FirebaseService.getUser(firebaseUser.uid);
      if (_userModel == null) {
        _userModel = await FirebaseService.createUser(
          firebaseUser.uid, firebaseUser.phoneNumber ?? '');
      }
    }
    notifyListeners();
  }

  Future<String?> sendOtp(String phone) async {
    try {
      _confirmationResult = await FirebaseService.sendOtp(phone);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'OTP পাঠাতে সমস্যা হয়েছে';
    }
  }

  Future<String?> verifyOtp(String code, {String? referralCode}) async {
    if (_confirmationResult == null) return 'অনুগ্রহ করে আবার চেষ্টা করুন';
    try {
      await FirebaseService.verifyOtp(_confirmationResult!, code);
      if (referralCode != null && referralCode.isNotEmpty && _userModel != null) {
        await FirebaseService.applyReferral(_userModel!.uid, referralCode);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'OTP যাচাই করতে সমস্যা হয়েছে';
    }
  }

  Future<void> updateProfile({String? name, String? address}) async {
    if (_userModel == null) return;
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (address != null) updates['address'] = address;
    await FirebaseService.updateUser(_userModel!.uid, updates);
    _userModel = _userModel!.copyWith(name: name, address: address);
    notifyListeners();
  }

  Future<void> signOut() async {
    await FirebaseService.signOut();
  }

  void refreshUser() async {
    final uid = FirebaseService.currentUser?.uid;
    if (uid != null) {
      _userModel = await FirebaseService.getUser(uid);
      notifyListeners();
    }
  }
}
