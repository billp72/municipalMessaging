// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../getDeviceInfo.dart';
import '../flexList/states_list.dart';

class Government extends StatelessWidget {
  const Government({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.home_outlined),
          ),
          title: const Text('Sign up'),
        ),
        body: Stack(children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.20), BlendMode.dstATop),
                image: const AssetImage('assets/images/gov.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Align(
              alignment: Alignment.topRight,
              child: SingleChildScrollView(child: MySignupPage(title: '')))
        ]));
  }
}

class MySignupPage extends StatefulWidget {
  const MySignupPage({super.key, required this.title});

  final String title;

  @override
  State<MySignupPage> createState() => _MySignupPageState();
}

class _MySignupPageState extends State<MySignupPage> {
  final dropdowns = {'state': 'Select state'};
  FocusNode inputNode = FocusNode();
  String? selected;

  void openKeyboard() {
    FocusScope.of(context).requestFocus(inputNode);
  }

  bool enabled() {
    return true;
  }

  Future createUser(credentials, String phone, String state, String city,
      String name, String email) async {
    String c = city.replaceAll(' ', '');
    String s = state.replaceAll(' ', '');
    // ignore: unnecessary_brace_in_string_interps
    String muni = '${c.toLowerCase()}_${s.toLowerCase()}';
    final u = FirebaseAuth.instance.currentUser;
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('adminLevel');
    final HttpsCallable callclaims =
        FirebaseFunctions.instance.httpsCallable('getCustomClaim');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final deviceID = await getDeviceId();
    final resp = await callable.call(<String, dynamic>{
      'uid': u?.uid,
      'city': city,
      'state': state,
      'municipality': muni,
      'phone': phone,
      'name': name,
      'email': email,
      'token': deviceID
    });

    final isUser = FirebaseAuth.instance.currentUser;
    if (resp.data != null && isUser != null) {
      final theclaim = await callclaims.call(<String, dynamic>{'uid': u?.uid});
      var data = theclaim.data;
      data["uid"] = u?.uid;
      data["city"] = city;

      String json = jsonEncode(data);

      prefs.setString("USER", json);
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, '/admin', ModalRoute.withName('/admin'));
    }
  }

  Future checkMunicipality(String muni) async {
    final HttpsCallable check =
        FirebaseFunctions.instance.httpsCallable('checkAdmin');
    final answer = await check.call({'municipality': muni});
    return answer.data;
  }

  Future submit(String email, String password, String phone, String city,
      String name) async {
    if (selected != null) {
      final String c = city.replaceAll(' ', '');
      final String s = selected!.replaceAll(' ', '');
      final String muni = '${c.toLowerCase()}_${s.toLowerCase()}';
      final exists = await checkMunicipality(muni);
      if (!exists) {
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);
          createUser(userCredential, phone, selected!, city, name, email);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('The password provided is too weak.')),
            );
          } else if (e.code == 'email-already-in-use') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('The account already exists for that email.')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('this account has already been created by the admin')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final myPassword = TextEditingController();
    final myEmail = TextEditingController();
    final name = TextEditingController();
    final city = TextEditingController();
    final phone = TextEditingController();
    final remyPassword = TextEditingController();
    return ResponsiveGridRow(children: [
      ResponsiveGridCol(
        xs: 12,
        child: Form(
            key: _formKey,
            child: ResponsiveGridRow(children: [
              ResponsiveGridCol(
                xs: 12,
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: name,
                    focusNode: inputNode,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Name (optional)',
                    ),
                  ),
                ),
              ),
              ResponsiveGridCol(
                xs: 12,
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.all(10.0),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    ),
                    validator: (value) {
                      if (value == null || value == 'Select state') {
                        return 'Please select an option';
                      }
                      return null;
                    },
                    value: selected,
                    items: states().map((String item) {
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
              ),
              ResponsiveGridCol(
                xs: 12,
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: city,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'City',
                    ),
                  ),
                ),
              ),
              ResponsiveGridCol(
                xs: 12,
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: myEmail,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                    ),
                  ),
                ),
              ),
              ResponsiveGridCol(
                xs: 12,
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Phone',
                    ),
                  ),
                ),
              ),
              ResponsiveGridCol(
                xs: 12,
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: myPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Password',
                    ),
                  ),
                ),
              ),
              ResponsiveGridCol(
                xs: 12,
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: remyPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Re-enter password',
                    ),
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
                        if (myPassword.text == remyPassword.text) {
                          submit(myEmail.text, myPassword.text, phone.text,
                              city.text, name.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                      }
                    },
                    child: const Text('SUBMIT'),
                  ),
                ),
              ),
            ])),
      ),
      /**/
    ]);
  }
}
