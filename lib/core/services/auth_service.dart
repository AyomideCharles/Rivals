import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:rivals/core/services/cloudinary_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? _user;
  Map<String, dynamic>? _userData;

  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;

  String get displayName => _userData?['displayName'] ?? '';
  String get email => _userData?['email'] ?? '';
  String get clubId => _userData?['clubId'] ?? '';
  String get clubName => _userData?['clubName'] ?? '';
  String get clubNickname => _userData?['clubNickname'] ?? '';
  String get clubColor => _userData?['clubColor'] ?? '';
  String get clubLeague => _userData?['clubLeague'] ?? '';
  bool get hasClub => _userData?['clubId'] != null;
  String get profileImageUrl => _userData?['profileImageUrl'] ?? '';

  AuthProvider() {
    auth.authStateChanges().listen((user) async {
      _user = user;
      if (user != null && _userData == null) {
        await _loadUserData(user.uid);
      } else if (user == null) {
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

      await userInfo.user!.updateDisplayName(displayName.trim());
      await userInfo.user!.reload();
      _user = auth.currentUser;

      final data = {
        'uid': userInfo.user!.uid,
        'displayName': displayName.trim(),
        'email': email.trim(),
        'clubId': null,
        'clubName': null,
        'clubNickname': null,
        'clubColor': null,
        'clubLeague': null,
        'profileImageUrl': '',
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
      final cred = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await _loadUserData(cred.user!.uid);
      return true;
    } on FirebaseAuthException catch (e) {
      SmartDialog.showToast(e.code);
      return false;
    }
  }

  Future<void> refreshUserData() async {
    if (_user == null) return;
    await _loadUserData(_user!.uid);
  }

  Future<void> signOut() async {
    _userData = null;
    notifyListeners();
    await auth.signOut();
  }

  Future<void> updateProfilePhoto(File file) async {
    if (_user == null) return;

    // upload to cloudinary
    final url = await CloudinaryService.uploadMedia(file);

    // this is to update user document on FS, for latest change
    await firestore.collection('users').doc(_user!.uid).update({
      'profileImageUrl': url,
    });

    //update existing post with new PP
    final posts = await firestore
        .collection('posts')
        .where('userId', isEqualTo: _user!.uid)
        .get();

    if (posts.docs.isNotEmpty) {
      for (var i = 0; i < posts.docs.length; i += 500) {
        final chunk = posts.docs.sublist(
          i,
          i + 500 > posts.docs.length ? posts.docs.length : i + 500,
        );
        final batch = firestore.batch();
        for (final doc in chunk) {
          batch.update(doc.reference, {'profileImageUrl': url});
        }
        await batch.commit();
      }
    }

    _userData?['profileImageUrl'] = url;
    notifyListeners();
  }
}
