import 'package:cloud_functions/cloud_functions.dart';
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
  final HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('getUserAlerts');
  dynamic _username;

  _formatListTypes(int i, data) {
    return i == 0
        ? HeadingItem('Click to add an alert')
        : MessageItem('Subscribed to: ${data[i]["type"].toUpperCase()}',
            'Recieve: ${data[i]["frequency"]} messages. Last sent ${data[i]["date"]["_seconds"]}');
  }

  Future _loadUserInfo() async {
    _username = await state.getMap("USER");
    final resp =
        await callable.call(<String, dynamic>{'uid': _username['uid']});
    final data = resp.data;
    final items =
        List<ListItem>.generate(data.length, (i) => _formatListTypes(i, data));

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
          title: const Text("Alarm List"),
        ),
        body: FutureBuilder(
            builder: (context, alertSnap) {
              if (!alertSnap.hasData || alertSnap.data.length == 0) {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      IconButton(
                          iconSize: 150,
                          icon: const Icon(
                            Icons.add_alarm_rounded,
                            color: Colors.green,
                            size: 150.0,
                          ),
                          onPressed: () {
                            _selectPage({}, 0);
                          }),
                      const Text(
                        "Click to add alarm",
                      )
                    ]));
              } else if (alertSnap.connectionState == ConnectionState.waiting &&
                  !alertSnap.hasData) {
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
            future: _loadUserInfo()));
  }
}
