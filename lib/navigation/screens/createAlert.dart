// ignore: file_names
import 'package:flutter/material.dart';

class MyCreateAlert extends StatefulWidget {
  const MyCreateAlert({Key? key}) : super(key: key);

  @override
  State<MyCreateAlert> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyCreateAlert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          icon: const Icon(Icons.home_outlined),
        ),
        title: const Text("Create an alert"),
      ),
    );
  }
}
