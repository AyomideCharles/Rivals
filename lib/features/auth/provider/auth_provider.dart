import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? _user;

  User? get user => _user;
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

  String get displayName => _userData?['displayName'] ?? '';
  String get email => _userData?['email'] ?? '';
  String get clubId => _userData?['clubId'] ?? '';
  String get clubName => _userData?['clubName'] ?? '';
  String get clubColor => _userData?['clubColor'] ?? '';
  String get clubLeague => _userData?['clubLeague'] ?? '';
  bool get hasClub => _userData?['clubId'] != null;

  AuthProvider() {
    auth.authStateChanges().listen((user) async {
      _user = user;
      if (user != null) {
        await _loadUserData(user.uid);
      } else {
        _userData = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _userData = doc.data();
      }
    } catch (e) {
      _userData = null;
    }
    notifyListeners();
  }

  Future<bool> signUp(String email, String password, String displayName) async {
    try {
      final userInfo = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      //  Save user other information to firestore
      await userInfo.user!.updateDisplayName(displayName.trim());

      final data = {
        'uid': userInfo.user!.uid,
        'displayName': displayName.trim(),
        'email': email.trim(),
        'clubId': null,
        'clubName': null,
        'clubColor': null,
        'clubLeague': null,
        'createdAt': FieldValue.serverTimestamp(),
      };
      await firestore.collection('users').doc(userInfo.user!.uid).set(data);
      _userData = data;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      SmartDialog.showToast(e.code);
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      SmartDialog.showToast(e.code);
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
