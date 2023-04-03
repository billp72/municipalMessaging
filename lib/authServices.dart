// ignore_for_file: file_names, avoid_print
import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final _auth = FirebaseAuth.instance;
  HttpsCallable? myrole;

  Future getCustomClaims(user, prefs) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('getCustomClaim');
    final resp = await callable.call(<String, dynamic>{'uid': user.uid});
    if (resp.data) {
      resp.data["uid"] = user.uid;
      resp.data["displayName"] = user?.displayName;
      resp.data["email"] = user?.email;
      resp.data["phoneNumber"] = user?.phoneNumber;
      prefs.setString("USER", jsonEncode(resp.data));
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = result.user;
      return user?.uid;
      // ignore: duplicate_ignore
    } catch (error) {
      // ignore: avoid_print
      print(error.toString());
      return null;
    }
  }
}
