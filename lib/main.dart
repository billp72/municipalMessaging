import 'package:flutter/material.dart';
import 'navigation/screens/login.dart';
import 'navigation/screens/home.dart';
import 'navigation/screens/signup.dart';
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
        '/login': (context) => const Login(
              title: '',
            ),
        '/signup': (context) => const Signup(
              title: '',
            ),
        '/home': (context) => const MyHomePage(title: 'Login Demo'),
      },
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    );
  }
}
