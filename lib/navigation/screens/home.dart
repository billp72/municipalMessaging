import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../getUserFromPreference.dart';
import '../flexList/listItem.dart';
import 'createAlert.dart';
import 'detailScreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final state = LocalState();
  
  dynamic _username;

  Future _loadUserInfo() async {
    _username = await state.getMap();
    final items = List<ListItem>.generate(
    100,
    (i) => i == 0
        ? HeadingItem('Click to add an alert')
        : MessageItem('Event $i', 'Will receive public events $i'),
    );
    //if (_username.isNotEmpty) {
    // ignore: avoid_print
    print('$_username is home user');
    //}
    return items;
  }

  void _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await FirebaseAuth.instance.signOut();
    prefs.remove("USER");
    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  void _selectPage(item, int index) {
    if (index > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyDetailPage(alert: item),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyCreateAlert(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _handleLogout();
            },
            icon: const Icon(Icons.home_outlined),
          ),
          title: const Text("Home"),
        ),
        body: FutureBuilder(
          builder: (context, alertSnap){
              if (alertSnap.connectionState == ConnectionState.none &&
                  !alertSnap.hasData) {
                return Container();
              }else if(alertSnap.connectionState == ConnectionState.waiting &&
                  !alertSnap.hasData){
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
              // Let the ListView know how many items it needs to build.
              itemCount: alertSnap.data?.length,
              // Provide a builder function. This is where the magic happens.
              // Convert each item into a widget based on the type of item it is.
              itemBuilder: (context, index) {
                final item = alertSnap.data?[index];

                return ListTile(
                  title: item.buildTitle(context),
                  subtitle: item.buildSubtitle(context),
                  onTap: () {
                    _selectPage(item, index);
                  },
                );
              },
            );
          },
        future: _loadUserInfo()
      ));
  }
}
