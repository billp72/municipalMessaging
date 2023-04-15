//import 'package:cloud_functions/cloud_functions.dart';
//import 'package:firebase_auth/firebase_auth.dart';
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import '../../getUserFromPreference.dart';
import '../flexList/listAlert.dart';

class CreateAlert extends StatefulWidget {
  const CreateAlert({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CreateAlert> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CreateAlert> {
  // final state = LocalState();
  // final HttpsCallable callable =
  //     FirebaseFunctions.instance.httpsCallable('getUserAlerts');
  // dynamic _username;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //String submittedValue = '';
  //bool submittedCheck = false;

  final List<Object> submittedValues = [];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      //print(submittedValues);
    }
  }

  void _captureSubmitted(val) {
    if (val["frequence"] != "" && val["delivery"] != "") {
      submittedValues.add(val);
    } else if (submittedValues.isNotEmpty) {
      for (var i in submittedValues.asMap().entries) {
        if (i.value == val["type"]) {
          submittedValues.remove(i.key);
        }
      }
    }
    print(submittedValues);
  }

  _formatListTypes(int i, data) {
    return MessageItem(
        hex: 0xe738, body: 'events', submitAlert: _captureSubmitted);
  }

  Future _loadUserInfo() async {
    // _username = await state.getMap("USER");
    // final resp =
    //     await callable.call(<String, dynamic>{'uid': _username['uid']});
    // final data = resp.data;
    final items = List<ListItem>.generate(10, (i) => _formatListTypes(i, {}));

    return items;
  }

  void _handleLogout() async {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                _handleLogout();
              },
              icon: const Icon(Icons.home_outlined),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _submitForm,
            )
          ],
          title: const Text("Create Alert"),
        ),
        body: Form(
            key: _formKey,
            child: FutureBuilder(
                builder: (context, alertSnap) {
                  if (!alertSnap.hasData || alertSnap.data.length == 0) {
                    return const Center(
                        child: Text(
                      "No alert types have been added yet",
                    ));
                  } else if (alertSnap.connectionState ==
                          ConnectionState.waiting &&
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
                        dense: true,
                        //leading: const Padding(padding: EdgeInsets.only(left: 4.0)),
                        subtitle: item,
                      );
                    },
                  );
                },
                future: _loadUserInfo())));
  }
}
