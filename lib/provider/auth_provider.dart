import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  ValueNotifier flag = ValueNotifier<bool>(false);

  bool _loginLoading = false;
  bool _registrationLoading = false;

  bool get loginLoading => _loginLoading;
  bool get registrationLoading => _registrationLoading;

  void setLoginLoading(bool value) {
    _loginLoading = value;
    notifyListeners();
  }

  void setRegistrationLoading(bool value) {
    _registrationLoading = value;
    notifyListeners();
  }

  void toggleFlag() {
    flag.value = !flag.value;
  }

  Future<(bool, String)> login(String email, String password) async {
    try {
      setLoginLoading(true);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      setLoginLoading(false);
      return (true, "Login successful");
    } on FirebaseException catch (e) {
      setLoginLoading(false);
      String code = e.code;
      return (false, code);
    }
  }

  Future<(bool, String)> registration(
      String firstName, String lastName, String email, String password) async {
    try {
      setRegistrationLoading(true);
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'likedArticle': [],
      });

      setRegistrationLoading(false);
      return (true, "Registration Successful");
    } on FirebaseAuthException catch (e) {
      setRegistrationLoading(false);
      return (false, e.code);
    }
  }
}
