import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

class Signup extends StatelessWidget {
  const Signup({Key? key, required this.title}) : super(key: key);
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MySignupPage> createState() => _MySignupPageState();
}

class _MySignupPageState extends State<MySignupPage> {
  //int _counter = 0;

  //void _incrementCounter() {
  // setState(() {
  // This call to setState tells the Flutter framework that something has
  // changed in this State, which causes it to rerun the build method below
  // so that the display can reflect the updated values. If we changed
  // _counter without calling setState(), then the build method would not be
  // called again, and so nothing would appear to happen.
  // _counter++;
  // });
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign up'),
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
                lg: 12,
                child: Container(
                  height: 80,
                  alignment: const Alignment(0, 0),
                  child: Text('signup',
                      maxLines: 10,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          height: 1.3,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic)),
                ),
              ),
              ResponsiveGridCol(
                xs: 6,
                md: 3,
                child: Container(
                  height: 100,
                  alignment: const Alignment(0, 0),
                  //color: Colors.green,
                  child: ElevatedButton(
                    child: const Text('BACK', style: TextStyle(fontSize: 15.0)),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        '/',
                        arguments: 'Landing!',
                      );
                    },
                  ),
                ),
              ),
              ResponsiveGridCol(
                xs: 6,
                md: 3,
                child: Container(
                  height: 100,
                  alignment: const Alignment(0, 0),
                  //color: Colors.orange,
                  child:
                      const Text('SIGN UP', style: TextStyle(fontSize: 15.0)),
                ),
              ),
              /**/
            ])));
  }
}
