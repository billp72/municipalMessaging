// ignore_for_file: file_names, avoid_print
//import 'dart:convert';
import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  final _auth = FirebaseAuth.instance;
  dynamic myrole;

  void initializeFbState() {
    _userFromFirebase();
  }

  Future _userFromFirebase() async {
    final prefs = await SharedPreferences.getInstance();
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print("NO AUTH CHANGE");
        prefs.clear();
      } else {
        getCustomClaims(user, prefs);
      }
    });
  }

  Future getCustomClaims(user, prefs) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('customClaim');
    final resp = await callable.call(<String, dynamic>{'uid': user.uid});
    user.claims = resp;
    prefs.setString("USER", jsonEncode(user));
  }

  Future registerWithEmailAndPassword(String email, String password,
      String role, String muni, String phone, String push, String name) async {
    try {
      // ignore: unused_local_variable
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      var uid = result.user?.uid;
      if (role == "admin") {
        myrole = FirebaseFunctions.instance.httpsCallable('adminLevel');
      } else {
        myrole = FirebaseFunctions.instance.httpsCallable('residentLevel');
      }
      // ignore: duplicate_ignore
      try {
        final user = await myrole.call(<String, dynamic>{
          'uid': uid,
          'municipality': muni,
          'push': push,
          'phone': phone,
          'email': email,
          'name': name
        });
        var u = user.data;
        print(u);
      } catch (e) {
        print('$e ERROR FETCHING USER DATA');
      }
    } on FirebaseAuthException catch (e) {
      // ignore: duplicate_ignore
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      // ignore: duplicate_ignore
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
