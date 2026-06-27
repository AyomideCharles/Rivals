import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // bool isLoading = false;
  User? _user;

  User? get user => _user;

  AuthProvider() {
    // Listen to Firebase auth state changes
    auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> signUp(String email, String password, String displayName) async {
    try {
      final userInfo = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      //  Save user other information to firestore
      await firestore.collection('users').doc(userInfo.user!.uid).set({
        'uid': userInfo.user!.uid,
        'displayName': displayName,
        'email': email.trim(),
        'clubId': null,
        'clubName': null,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } on FirebaseAuthException catch (e) {
      SmartDialog.showToast(e.code);
      notifyListeners();
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
}
