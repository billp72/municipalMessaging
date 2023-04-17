import 'package:cloud_functions/cloud_functions.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import '../../getUserFromPreference.dart';
import '../flexList/listAlert.dart';
//import 'package:intl/intl.dart';

class CreateAlert extends StatefulWidget {
  const CreateAlert({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CreateAlert> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CreateAlert> {
  final state = LocalState();
  final HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('addAlerts');
  dynamic _username;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<Map<String, dynamic>> submittedValues = [];

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final resp =
          await callable.call(<String, dynamic>{'data': submittedValues});
      final data = resp.data;
      //print(submittedValues);
    }
  }

  void _captureSubmitted(val) async {
    if (val.containsKey("frequency") && val.containsKey("delivery")) {
      //final DateTime now = DateTime.now();
      // final DateFormat formatter = DateFormat('dd-mm-yyyy');
      // final String formatted = formatter.format(now);
      _username = await state.getMap("USER");
      val["uid"] = _username["uid"];
      val["date"] = '04/16/2023';
      submittedValues.add(val);
    } else if (submittedValues.isNotEmpty) {
      List<Map<String, dynamic>> copyOfList = List.from(submittedValues);
      copyOfList.asMap().forEach((key, value) {
        if (value["type"] == val["type"]) {
          submittedValues.removeAt(key);
        }
      });
    }
  }

  _formatListTypes(int i, data) {
    return MessageItem(
        hex: data[i]["hex"],
        body: data[i]["body"],
        submitAlert: _captureSubmitted);
  }

  List<Map<String, Object>> data1 = [
    {"hex": 0xe23e, "body": "events"},
    {"hex": 0xe151, "body": "emergancy"},
    {"hex": 0xe7b0, "body": "taxes"},
    {"hex": 0xf05c1, "body": "ordinance"},
    {"hex": 0xf4d5, "body": "employment"},
    {"hex": 0xe738, "body": "publicworks"},
    {"hex": 0xe757, "body": "road_closers"},
    {"hex": 0xe189, "body": "construction"}
  ];

  Future _loadUserInfo() async {
    final items = List<ListItem>.generate(
        data1.length, (i) => _formatListTypes(i, data1));

    return items;
  }

  void _handleLogout() async {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 50.0),
                  onPressed: _submitForm,
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 60.0, 0),
                child: IconButton(
                  onPressed: () {
                    _handleLogout();
                  },
                  icon: const Icon(Icons.home_outlined, size: 50.0),
                )),
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
                    itemCount: alertSnap.data?.length,
                    itemBuilder: (context, index) {
                      final item = alertSnap.data?[index];

                      return ListTile(
                        dense: true,
                        subtitle: item,
                      );
                    },
                  );
                },
                future: _loadUserInfo())));
  }
}
