import 'package:flutter/material.dart';
import 'navigation/screens/login.dart';
import 'navigation/screens/home.dart';
import 'navigation/screens/resident.dart';
import 'navigation/screens/government.dart';
import 'navigation/landing_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        '/government': (context) => const Government(title: 'Government'),
        '/home': (context) => const MyHomePage(title: 'Home'),
      },
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    );
  }
}
