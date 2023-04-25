//import 'package:cloud_functions/cloud_functions.dart';
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

  Future<String> userData() async {
    final u = await state.getMap("USER");
    return u["city"];
  }

  void _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await FirebaseAuth.instance.signOut();
    prefs.remove("USER");
    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  @override
  Widget build(BuildContext context) {
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
        body: ResponsiveGridRow(children: [
      ResponsiveGridCol(
        xs: 12,
        child: 
        
        Form(
            key: _formKey,
            child: FutureBuilder(
                  builder: (context, alertSnap) {
            if (alertSnap.hasData) {
                final dropdown = alertSnap.data!;
                // ignore: avoid_print
                print(dropdown);
              } else if (alertSnap.hasError) {
                return Text('Error: ${alertSnap.error}');
              } else {
                return const Text('Loading...');
              }
            return ResponsiveGridRow(children: [  
              ResponsiveGridCol(
                xs: 12,
                child: Container(
                  ),
              ),
              ResponsiveGridCol(
                xs: 12,
                child: Container(
                  ),
              ),
              ResponsiveGridCol(
                xs: 12,
                child: Container(),
              ),
              ResponsiveGridCol(
                xs: 12,
                child: Container(),
              ),
              ResponsiveGridCol(
                xs: 12,
                child: Container(
                  height: 30,
                  margin: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // if (_formKey.currentState!.validate()) {
                      //   if (myPassword.text == remyPassword.text) {
                      //     submit(myEmail.text, myPassword.text, phone.text,
                      //         dropdowns["state"]!, city.text, name.text);
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(content: Text('Processing Data')),
                      //     );
                      //   }
                      // }
                    },
                    child: const Text('BROADCAST'),
                  ),
                ),
              ),
            ]);
            },
            future: userData(),
          )),
      ),
    ])
    );
  }
}