import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../getUserFromPreference.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final state = LocalState();
  dynamic _username;

  _loadUserInfo() async {
    _username = await state.getMap();
    //if (_username.isNotEmpty) {
    print('$_username is home user');
    //}
  }

  void _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await FirebaseAuth.instance.signOut();
    prefs.remove("USER");
    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  @override
  Widget build(BuildContext context) {
    _loadUserInfo();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome This is the home screen'),
            ElevatedButton(
              onPressed: _handleLogout,
              child: const Text("Logout"),
            )
          ],
        ));
  }
}
