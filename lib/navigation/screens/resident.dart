import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

class Resident extends StatelessWidget {
  const Resident({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: MySignupPage(
      title: '',
    ));
  }
}

class MySignupPage extends StatefulWidget {
  const MySignupPage({super.key, required this.title});

  final String title;

  @override
  State<MySignupPage> createState() => _MySignupPageState();
}

class _MySignupPageState extends State<MySignupPage> {
  Future submit(String email, String password) async {}

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _formKey = GlobalKey<FormState>();
    final myPassword = TextEditingController();
    final myEmail = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Municipal Message - Sign up'),
        ),
        body: Container(
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
                          //alignment: const Alignment(0, 0),
                          //color: Colors.blue,
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
                          //alignment: const Alignment(0, 0),
                          //color: Colors.blue,
                          child: TextFormField(
                            controller: myEmail,
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
                          //alignment: const Alignment(0, 0),
                          //color: Colors.blue,
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
                              hintText: 'State',
                            ),
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        xs: 12,
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.all(10.0),
                          //alignment: const Alignment(0, 0),
                          //color: Colors.blue,
                          child: TextFormField(
                            controller: myPassword,
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
                          //alignment: const Alignment(0, 0),
                          //color: Colors.blue,
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
                          //alignment: const Alignment(0, 0),
                          //color: Colors.blue,
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
                          //alignment: const Alignment(0, 0),
                          //color: Colors.blue,
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
                          //alignment: const Alignment(0, 0),
                          //color: Colors.blue,
                          child: ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              // ignore: avoid_print
                              if (_formKey.currentState!.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                submit(myEmail.text, myPassword.text);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Processing Data')),
                                );
                              }
                            },
                            child: const Text('SUBMIT'),
                          ),
                        ),
                      ),
                    ])),
              ),
              /**/
            ])));
  }
}
