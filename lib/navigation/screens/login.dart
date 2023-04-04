// ignore_for_file: prefer_const_constructors
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
        appBar: AppBar(
          title: const Text('Municipal Messageing'),
        ),
        body: const MyLoginPage(title: ''));
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyLoginPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyLoginPage> {
  Future login(String email, String password) async {
    final AuthServices auth = AuthServices();
    final isAuth = await auth.signInWithEmailAndPassword(email, password);
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('getCustomClaim');
    final resp = await callable.call(<String, dynamic>{'uid': isAuth});
    var d = resp.data;
    if (d["admin"] == false) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', ModalRoute.withName('/home'));
    } else if (d["admin"] == true) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
          context, '/admin', ModalRoute.withName('/admin'));
    }
  }

  // ignore: use_build_context_synchronously
  void _handleNavigation(String route) {
    if (route != '/admin') {
      Navigator.pushNamedAndRemoveUntil(
          context, route, ModalRoute.withName(route));
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _formKey = GlobalKey<FormState>();
    final myPassword = TextEditingController();
    final myEmail = TextEditingController();
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.20), BlendMode.dstATop),
            image: const AssetImage('assets/images/gov.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ResponsiveGridRow(children: [
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
                        onPressed: () {
                          // ignore: avoid_print
                          if (_formKey.currentState!.validate()) {
                            login(myEmail.text, myPassword.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
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
              //color: Colors.green,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(64.0, 23.7, 64.0, 23.7)),
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
                height: 50,
                margin: const EdgeInsets.all(15.0),
                //color: Colors.orange,
                child: TextField(
                    decoration: InputDecoration(
                  fillColor: Colors.orange,
                  filled: true,
                  border: OutlineInputBorder(),
                  hintText: 'MUNICIPAL CODE',
                  hintStyle: TextStyle(fontSize: 13),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      _handleNavigation('/admin');
                    },
                  ),
                ))),
          ),
          /**/
        ]));
  }
}
