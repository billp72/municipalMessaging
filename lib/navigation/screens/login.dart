// ignore_for_file: prefer_const_constructors, avoid_print
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../authServices.dart';

class Login extends StatelessWidget {
  const Login({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Login or Sign up'),
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
              child: SingleChildScrollView(child: MyLoginPage(title: '')))
        ]));
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.title});

  final String title;

  @override
  State<MyLoginPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyLoginPage> {
  Future login(String email, String password) async {
    final AuthServices auth = AuthServices();
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('getCustomClaim');
    final HttpsCallable user =
        FirebaseFunctions.instance.httpsCallable('getUserDetails');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isAuth = await auth.signInWithEmailAndPassword(email, password);
    if (isAuth != null) {
      final resp = await callable.call(<String, dynamic>{'uid': isAuth});
      final u = await user.call(<String, dynamic>{
        'uid': isAuth,
        'municipality': resp.data['municipality']
      });

      var data = resp.data;
      data["uid"] = isAuth;
      data["city"] = u.data["city"];

      String json = jsonEncode(data);

      prefs.setString("USER", json);

      _loginRoute(data);
      return 'Processing request';
    } else {
      return 'Log in failed';
    }
  }

  void _loginRoute(data) {
    if (data["admin"] == false) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', ModalRoute.withName('/home'));
    } else if (data["admin"] == true) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/admin', ModalRoute.withName('/admin'));
    }
  }

  // ignore: use_build_context_synchronously
  void _handleNavigation(String route) {
    //if (route != '/admin') {
    Navigator.pushNamedAndRemoveUntil(
        context, route, ModalRoute.withName(route));
    //}
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _formKey = GlobalKey<FormState>();
    final myPassword = TextEditingController();
    final myEmail = TextEditingController();
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
                    controller: myPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
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
                xs: 4,
                child: Container(
                  height: 30,
                  margin: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String text =
                            await login(myEmail.text, myPassword.text);
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(text)),
                        );
                      }
                    },
                    child: const Text('LOG IN'),
                  ),
                ),
              ),
            ])),
      ),
      ResponsiveGridCol(
        lg: 12,
        child: Container(
          height: 150,
          padding: const EdgeInsets.all(8.0),
          alignment: const Alignment(0, 0),
          child: Text(
              'Welcome to Municipal Messaging! An app to get direct messages from your city government. To begin, click Resident. Or if you\'re a government employee, enter the provided municipal code. (get code)',
              maxLines: 10,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                height: 1.3,
                color: Colors.grey[600],
              )),
        ),
      ),
      ResponsiveGridCol(
        xs: 6,
        md: 4,
        child: Container(
          height: 80,
          alignment: const Alignment(0, 0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.fromLTRB(55, 18, 55, 18)),
            child: const Text('RESIDENT',
                style: TextStyle(
                  fontSize: 15.0,
                )),
            onPressed: () {
              _handleNavigation('/resident');
            },
          ),
        ),
      ),
      ResponsiveGridCol(
        xs: 5,
        md: 4,
        child: Container(
            height: 80,
            alignment: const Alignment(0, 0),
            child: TextField(
                decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(15, 18, 55, 18),
              fillColor: Colors.orange,
              filled: true,
              border: OutlineInputBorder(),
              hintText: 'CODE',
              hintStyle: TextStyle(fontSize: 13),
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  _handleNavigation('/municipality');
                },
              ),
            ))),
      ),
      /**/
    ]);
  }
}
