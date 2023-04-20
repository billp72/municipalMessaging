// ignore: file_names
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../getUserFromPreference.dart';
//import '../dropdownMenu/dropdownmenu.dart';
import '../flexList/listItem.dart';
import '../icons/my_icon.dart';

class MyDetailPage extends StatefulWidget {
  final String alert;
  final String historyID;

  const MyDetailPage(
      {Key? key,
      required this.title,
      required this.alert,
      required this.historyID})
      : super(key: key);

  final String title;

  @override
  // ignore: no_logic_in_create_state
  State<MyDetailPage> createState() =>
      // ignore: no_logic_in_create_state
      _MyHomePageState(alert: alert, historyID: historyID);
}

class _MyHomePageState extends State<MyDetailPage> {
  final String alert;
  final String historyID;

  final state = LocalState();
  final HttpsCallable historycallable =
      FirebaseFunctions.instance.httpsCallable('getHistory');
  final HttpsCallable selectioncallable =
      FirebaseFunctions.instance.httpsCallable('getSelection');
  dynamic _username;
  final List<Map<String, dynamic>> submittedValues = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _MyHomePageState({required this.alert, required this.historyID});

  Future<String> userData() async {
    final u = await state.getMap("USER");
    return u;
  }

  _formatListTypes(int i, data) {
    DateTime? myDate;
    try {
      myDate = data[i]["date"]; //.toDate();
    } catch (e) {
      myDate = DateTime.now();
    }

    return i == 0
        ? HeadingItem('Message History', '', '')
        : MessageItem(
            'Subscribed to: ${data[i]["type"].toUpperCase()}',
            'Recieve ${data[i]["frequency"]} messages. Last sent $myDate',
            '',
            '');
  }

  Future _loadFormSelection() async {
    _username = await state.getMap("USER");
    final resp = await selectioncallable
        .call(<String, dynamic>{'type': alert, 'uid': _username['uid']});

    return resp.data;
  }

  Future _loadUserInfo() async {
    _username = await state.getMap("USER");
    final resp = await historycallable
        .call(<String, dynamic>{historyID: historyID, 'uid': _username['uid']});
    final data = resp.data;
    final items =
        List<ListItem>.generate(data.length, (i) => _formatListTypes(i, data));

    return items;
  }

  void _handleBack() async {
    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(
        context, '/home', ModalRoute.withName('/home'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _handleBack();
            },
            icon: const Icon(Icons.home_filled),
          ),
          title: Text('$alert history & edit'),
        ),
        body: Column(children: [
          Container(
              height: 150,
              width: double.infinity,
              color: Colors.blue,
              child: Form(
                  key: _formKey,
                  child: FutureBuilder(
                      builder: (context, alertSnap) {
                        if (alertSnap.connectionState ==
                                ConnectionState.waiting &&
                            !alertSnap.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (!alertSnap.hasData ||
                            alertSnap.data?.length == 0) {
                          return const Center(
                              child: Text(
                            "Something bad happened",
                          ));
                        }
                        final item = alertSnap.data;

                        return Form(
                            child: ResponsiveGridRow(children: [
                          ResponsiveGridCol(
                              xs: 12, md: 4, child: Text(item["type"])),
                          ResponsiveGridCol(
                            xs: 12,
                            md: 4,
                            child: Text(item["delivery"]),
                          ),
                          ResponsiveGridCol(
                            xs: 12,
                            md: 4,
                            child: Text(item["frequency"]),
                          ),
                        ]));
                      },
                      future: _loadFormSelection()))),
          Flexible(
              child: FutureBuilder(
                  builder: (context, alertSnap) {
                    if (alertSnap.connectionState == ConnectionState.waiting &&
                        !alertSnap.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (!alertSnap.hasData ||
                        alertSnap.data?.length == 0) {
                      return Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                            Icon(
                              Icons.add_alarm_rounded,
                              color: Colors.green,
                              size: 150.0,
                            ),
                            Text(
                              "No history for this alert",
                            )
                          ]));
                    }
                    return ListView.builder(
                      itemCount: alertSnap.data?.length,
                      itemBuilder: (context, index) {
                        final item = alertSnap.data?[index];

                        return ListTile(
                          title: item.buildTitle(context),
                          subtitle: item.buildSubtitle(context),
                          onTap: () {},
                        );
                      },
                    );
                  },
                  future: _loadUserInfo()))
        ]));
  }
}
