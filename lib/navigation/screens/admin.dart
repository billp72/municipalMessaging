//import 'package:cloud_functions/cloud_functions.dart';
// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../getUserFromPreference.dart';
import 'package:responsive_grid/responsive_grid.dart';

class MyAdminPage extends StatefulWidget {
  const MyAdminPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyAdminPage> createState() => _MyAdminPageState();
}

class _MyAdminPageState extends State<MyAdminPage> {
  final state = LocalState();
  final HttpsCallable callableBroadcast =
      FirebaseFunctions.instance.httpsCallable('PublishEvent');

  String? selected;

  Future<String> userData() async {
    final u = await state.getMap("USER");
    return u["city"];
  }

  void broadcast(String title, String body, String link) async {
    if (selected!.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
      final username = await state.getMap("USER");
      final result = await callableBroadcast.call(<String, dynamic>{
        'topic': selected!,
        'municipality': username['municipality'],
        'admin_uid': username["uid"],
        'title': title,
        'body': '$body $link'
      });

      if (result.data) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Complete')),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('a failure occured')));
      }
    }
  }

  void _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await FirebaseAuth.instance.signOut();
    prefs.remove("USER");
    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  Future<List<dynamic>> loadTopics() async {
    List<String> newArray = [];

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

    for (int i = 0; i < data1.length; i++) {
      String? val = data1[i]["body"] as String?;
      newArray.add(val!);
    }

    return newArray;
  }

  @override
  Widget build(BuildContext context) {
    //print(selected);
    final title = TextEditingController();
    final bodytext = TextEditingController();
    final link = TextEditingController();
    // ignore: no_leading_underscores_for_local_identifiers
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _handleLogout();
            },
            icon: const Icon(Icons.logout),
          ),
          title: FutureBuilder<String>(
            future: userData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final d = snapshot.data!;
                return Text('Admin of $d');
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const Text('Loading...');
              }
            },
          ),
        ),
        body: SingleChildScrollView(
            child: ResponsiveGridRow(children: [
          ResponsiveGridCol(
            xs: 12,
            child: Form(
                key: _formKey,
                child: FutureBuilder(
                  builder: (context, AsyncSnapshot<List<dynamic>> alertSnap) {
                    if (alertSnap.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (alertSnap.hasError) {
                      return Text('Error: ${alertSnap.error}');
                    } else {
                      final data = alertSnap.data!.cast<String>();
                      return ResponsiveGridRow(children: [
                        ResponsiveGridCol(
                          xs: 12,
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select an option';
                              }
                              return null;
                            },
                            value: selected,
                            items: data.map((String item) {
                              return DropdownMenuItem<String>(
                                  value: item, child: Text(item));
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selected = value!;
                              });
                            },
                          ),
                        ),
                        ResponsiveGridCol(
                          xs: 12,
                          child: TextFormField(
                            controller: title,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Title',
                            ),
                          ),
                        ),
                        ResponsiveGridCol(
                          xs: 12,
                          child: TextFormField(
                            controller: bodytext,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter text';
                              }
                              return null;
                            },
                            maxLines: 8,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Body Text',
                            ),
                          ),
                        ),
                        ResponsiveGridCol(
                          xs: 12,
                          child: TextFormField(
                            controller: link,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Optional link',
                            ),
                          ),
                        ),
                        ResponsiveGridCol(
                          xs: 12,
                          child: Container(
                            height: 30,
                            margin: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  broadcast(
                                      title.text, bodytext.text, link.text);
                                }
                              },
                              child: const Text('BROADCAST'),
                            ),
                          ),
                        ),
                      ]);
                    }
                  },
                  future: loadTopics(),
                )),
          ),
        ])));
  }
}
