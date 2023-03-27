import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'navigation/screens/login.dart';
import 'navigation/screens/home.dart';
import 'navigation/screens/resident.dart';
import 'navigation/screens/government.dart';
import 'navigation/landing_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('helloWorld');
  try {
    final result = await callable();

    List msg = result.data;
    // ignore: avoid_print
    print(msg);
  } catch (e) {
    // ignore: avoid_print
    print('$e ERROR FETCHING DATA');
  }
  runApp(const MyApp());
}

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
        '/municipality': (context) => const Government(title: 'Municipality'),
        '/home': (context) => const MyHomePage(title: 'Home'),
      },
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    );
  }
}
