//import 'package:cloud_functions/cloud_functions.dart';
// ignore_for_file: avoid_print

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

  Map<String, dynamic>? selected;

  Future<String> userData() async {
    final u = await state.getMap("USER");
    return u["city"];
  }

  void broadcast(String title, String body, String link) async {
    if (selected!.isNotEmpty) {
      final username = await state.getMap("USER");
      await callableBroadcast.call(<String, dynamic>{
        'topic': selected!["body"],
        'municipality': username['municipality'],
        'payload': '$title $body $link'
      });
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

  Future loadTopics() async {
    final username = await state.getMap("USER");

    List<Map<String, dynamic>> data1 = [
      {"id": 1, "body": "events"},
      {"id": 2, "body": "emergancy"},
      {"id": 3, "body": "taxes"},
      {"id": 4, "body": "ordinance"},
      {"id": 5, "body": "employment"},
      {"id": 6, "body": "publicworks"},
      {"id": 7, "body": "road_closers"},
      {"id": 8, "body": "construction"},
      {"id": 9, "body": "announcements"},
    ];

    return data1;
  }

  @override
  Widget build(BuildContext context) {
    //print(selected);
    final title = TextEditingController();
    final bodytext = TextEditingController();
    final link = TextEditingController();
    // ignore: no_leading_underscores_for_local_identifiers
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    var dropdown = [];
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
                  builder: (context, alertSnap) {
                    if (alertSnap.hasData) {
                      dropdown = alertSnap.data!;
                    } else if (alertSnap.hasError) {
                      return Text('Error: ${alertSnap.error}');
                    } else {
                      return const Text('Loading...');
                    }

                    return ResponsiveGridRow(children: [
                      ResponsiveGridCol(
                        xs: 12,
                        child: DropdownButtonFormField<Map<String, dynamic>>(
                          validator: (value) {
                            if (value == null) {
                              return 'Please select an option';
                            }
                            return null;
                          },
                          items: (dropdown).map((item) {
                            return DropdownMenuItem<Map<String, dynamic>>(
                                value: item, child: Text(item["body"]));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selected = value!;
                            });
                          },
                          value: dropdown[0],
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
                                broadcast(title.text, bodytext.text, link.text);
                              }
                            },
                            child: const Text('BROADCAST'),
                          ),
                        ),
                      ),
                    ]);
                  },
                  future: loadTopics(),
                )),
          ),
        ])));
  }
}
