// ignore_for_file: avoid_print, duplicate_ignore
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'navigation/screens/login.dart';
import 'navigation/screens/home.dart';
import 'navigation/screens/admin.dart';
import 'navigation/screens/resident.dart';
import 'navigation/screens/government.dart';
import 'navigation/landing_page.dart';
import 'authServices.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final authenticate = FirebaseAuth.instance;

  //remove emulator when deployed
  // FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  // authenticate.useAuthEmulator("localhost", 9099);
  // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

  var auth = AuthServices();
  final prefs = await SharedPreferences.getInstance();

  authenticate.authStateChanges().listen((User? user) {
    if (user == null) {
      prefs.clear();
    } else {
      if (user.uid.isNotEmpty) {
        auth.getCustomClaims(user, prefs);
      }
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final myColor = const MaterialColor(
    0xFF123456, // The primary value
    <int, Color>{
      50: Color(0xFFEDF0F2),
      100: Color(0xFFCED5DE),
      200: Color(0xFFABC0CB),
      300: Color(0xFF88ABB8),
      400: Color(0xFF6C97A4),
      500: Color(0xFF508290),
      600: Color(0xFF47787B),
      700: Color(0xFF3E6D70),
      800: Color(0xFF356265),
      900: Color(0xFF254E52),
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const Login(title: ''),
        '/resident': (context) => const Resident(
              title: 'Resident',
            ),
        '/municipality': (context) => const Government(title: 'Municipality'),
        '/home': (context) => const MyHomePage(title: 'Home'),
        '/admin': (context) => const MyAdminPage(title: 'Admin'),
      },
      theme: ThemeData(
        primarySwatch: myColor,
      ),
    );
  }
}
