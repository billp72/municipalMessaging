// ignore: file_names
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class LocalState {
  Future getMap() async {
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString("USER");
    if (user?.isNotEmpty == true) {
      return jsonDecode(user ?? "") ?? {};
    } else {
      return "";
    }
  }
}