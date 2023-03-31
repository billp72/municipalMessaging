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
    resp.data["uid"] = user.uid;
    resp.data["displayName"] = user?.displayName;
    resp.data["email"] = user?.email;
    resp.data["phoneNumber"] = user?.phoneNumber;
    print(resp.data);
    prefs.setString("USER", jsonEncode(resp.data));
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = result.user;
      //print('Successfully logged in, User UID: ${user?.uid}');
      return user?.uid;
    } catch (error) {
      // ignore: avoid_print
      print(error.toString());
      return null;
    }
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
        final user = await myrole?.call(<String, dynamic>{
          'uid': uid,
          'municipality': muni,
          'push': push,
          'phone': phone,
          'email': email,
          'name': name
        });
        var u = user?.data;
        // ignore: avoid_print
        print(u);
      } catch (e) {
        // ignore: avoid_print
        print('$e ERROR FETCHING USER DATA');
      }
    } on FirebaseAuthException catch (e) {
      // ignore: duplicate_ignore
      if (e.code == 'weak-password') {
        // ignore: avoid_print
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // ignore: avoid_print
        print('The account already exists for that email.');
      }
      // ignore: duplicate_ignore
    } catch (error) {
      // ignore: avoid_print
      print(error.toString());
      return null;
    }
  }
}
