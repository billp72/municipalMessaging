// ignore: file_names
import '../flexList/listItem.dart';
import 'package:flutter/material.dart';

class MyDetailPage extends StatefulWidget {
  const MyDetailPage({Key? key, required this.alert}) : super(key: key);

  final ListItem alert;

  @override
  State<MyDetailPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyDetailPage>  {
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
          title: const Text("Detail Screen"),
        ),
    );
  }
}

