// ignore: file_names
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalState {
  Future getMap(String type) async {
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString(type);
    if (user?.isNotEmpty == true) {
      Map<String, dynamic> data = jsonDecode(user!);
      return data;
    } else {
      return "";
    }
  }
}
