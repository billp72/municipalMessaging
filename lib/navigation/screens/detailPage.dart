// ignore_for_file: avoid_print

//import 'dart:html';

import 'package:cloud_functions/cloud_functions.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import '../../getUserFromPreference.dart';
import '../flexList/listItem.dart';

class MyDetailPage extends StatefulWidget {
  final String alert;

  const MyDetailPage({Key? key, required this.title, required this.alert})
      : super(key: key);

  final String title;

  @override
  // ignore: no_logic_in_create_state
  State<MyDetailPage> createState() => _MyHomePageState(alert: alert);
}

class _MyHomePageState extends State<MyDetailPage> {
  final String alert;
  final state = LocalState();
  final HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('getUserAlerts');
  dynamic _username;

  _MyHomePageState({required this.alert});

  Future<String> userData() async {
    final u = await state.getMap("USER");
    return u["city"];
  }

  _formatListTypes(int i, data) {
    DateTime? myDate;
    try {
      myDate = data[i]["date"]; //.toDate();
    } catch (e) {
      myDate = DateTime.now();
    }
    return i == 0
        ? HeadingItem('Click to add an alert')
        : MessageItem('Subscribed to: ${data[i]["type"].toUpperCase()}',
            'Recieve ${data[i]["frequency"]} messages. Last sent $myDate', "");
  }

  Future _loadUserInfo() async {
    _username = await state.getMap("USER");
    final resp = await callable.call(
        <String, dynamic>{'municipality': alert, 'uid': _username['uid']});
    final data = resp.data;
    final items =
        List<ListItem>.generate(data.length, (i) => _formatListTypes(i, data));

    return items;
  }

  void _handleBack() async {
    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(
        context, '/home', ModalRoute.withName('/home'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _handleBack();
            },
            icon: const Icon(Icons.logout),
          ),
          title: FutureBuilder<String>(
            future: userData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final tit = snapshot.data!;
                return Text('Alerts for $tit');
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const Text('Loading...');
              }
            },
          ),
        ),
        body: FutureBuilder(
            builder: (context, alertSnap) {
              if (alertSnap.connectionState == ConnectionState.waiting &&
                  !alertSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (!alertSnap.hasData || alertSnap.data.length == 0) {
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
                          onPressed: () {}),
                      const Text(
                        "Click to add alarm",
                      )
                    ]));
              }
              return ListView.builder(
                itemCount: alertSnap.data?.length,
                itemBuilder: (context, index) {
                  final item = alertSnap.data?[index];

                  return ListTile(
                    title: item.buildTitle(context),
                    subtitle: item.buildSubtitle(context),
                    onTap: () {},
                  );
                },
              );
            },
            future: _loadUserInfo()));
  }
}
