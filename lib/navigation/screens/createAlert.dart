// ignore: file_names
import 'package:cloud_functions/cloud_functions.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import '../../getUserFromPreference.dart';
import '../flexList/listAlert.dart';
import 'package:intl/intl.dart';

class CreateAlert extends StatefulWidget {
  const CreateAlert({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CreateAlert> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CreateAlert> {
  final state = LocalState();
  final HttpsCallable callableAdd =
      FirebaseFunctions.instance.httpsCallable('addAlerts');
  final HttpsCallable callableCheck =
      FirebaseFunctions.instance.httpsCallable('checkAlerts');
  dynamic _username;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<Map<String, dynamic>> submittedValues = [];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String message = "Processing submission";
      if (submittedValues.isEmpty) {
        message = "No alerts selected";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );

      callableAdd
          .call(<String, dynamic>{'data': submittedValues}).then((data) => {
                if (data.data)
                  {_handleBack()}
                else
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Something went wrong. Alerts not added.')),
                    )
                  }
              });
    }
  }

  void _captureSubmitted(val) async {
    if (val.containsKey("frequency") && val.containsKey("delivery")) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);

      _username = await state.getMap("USER");
      val["uid"] = _username["uid"];
      val["date"] = formattedDate;
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
        color: data[i]["color"],
        submitAlert: _captureSubmitted);
  }

  List<Map<String, Object>> data1 = [
    {"hex": 0xe23e, "body": "events", "color": 0xffef6c00},
    {"hex": 0xe151, "body": "emergancy", "color": 0xffffca28},
    {"hex": 0xe7b0, "body": "taxes", "color": 0xff90a4ae},
    {"hex": 0xf05c1, "body": "ordinance", "color": 0xff78909c},
    {"hex": 0xf4d5, "body": "employment", "color": 0xff01579b},
    {"hex": 0xe4f0, "body": "publicworks", "color": 0xff004d40},
    {"hex": 0xe757, "body": "road_closers", "color": 0xffd50000},
    {"hex": 0xe189, "body": "construction", "color": 0xffff5722},
    {"hex": 0xe087, "body": "announcements", "color": 0xfff48fb1},
  ];

  Future _loadUserInfo() async {
    _username = await state.getMap("USER");
    final List newList = [];
    for (int i = 0; i < data1.length; i++) {
      final resp = await callableCheck.call(
          <String, dynamic>{'uid': _username["uid"], 'type': data1[i]["body"]});
      if (resp.data) {
        newList.add(data1[i]);
      }
    }

    final items = List<ListItem>.generate(
        newList.length, (i) => _formatListTypes(i, newList));

    return items;
  }

  void _handleBack() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          actions: [
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 110.0, 0),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 40.0),
                  onPressed: _submitForm,
                )),
          ],
          title: const Text("Add Alert(s)"),
        ),
        body: Form(
            key: _formKey,
            child: FutureBuilder(
                builder: (context, alertSnap) {
                  if (alertSnap.connectionState == ConnectionState.waiting &&
                      !alertSnap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!alertSnap.hasData ||
                      alertSnap.data?.length == 0) {
                    return const Center(
                        child: Text(
                      "No alert types have been added yet",
                    ));
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
