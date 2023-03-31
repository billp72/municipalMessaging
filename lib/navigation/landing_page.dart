import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  _loadUserInfo() async {
    var user = await getMap();
    // ignore: avoid_print
    if (user.isEmpty) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
          context, '/login', ModalRoute.withName('/login'));
    } else {
      if (user.containsKey('admin')) {
        if (user["admin"]) {
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(
              context, '/admin', ModalRoute.withName('/admin'));
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(
              context, '/home', ModalRoute.withName('/home'));
        }
      }
    }
  }

  static Future getMap() async {
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString("USER");
    if (user?.isNotEmpty == true) {
      return jsonDecode(user ?? "") ?? {};
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
