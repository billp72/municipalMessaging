// ignore: file_names
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../getUserFromPreference.dart';
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
  bool isChecked = false;
  final state = LocalState();
  final HttpsCallable historycallable =
      FirebaseFunctions.instance.httpsCallable('getHistory');
  final HttpsCallable selectioncallable =
      FirebaseFunctions.instance.httpsCallable('getSelection');
  final HttpsCallable callableUpdate =
      FirebaseFunctions.instance.httpsCallable('updateAlert');
  dynamic _username;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _MyHomePageState({required this.alert, required this.historyID});

  Future<String> userData() async {
    final u = await state.getMap("USER");
    return u;
  }

  final Map<String, Object> dropdowns = {
    "frequency": "",
    "delivery": "",
    "type": "",
    "mute": false
  };

  void onSelectedValueChange(String value, String type) {
    dropdowns[type] = value;
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String message = "Processing submission";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );

      final resp = await callableUpdate
          .call(<String, dynamic>{'uid': _username['uid'], 'data': dropdowns});
      final data = resp.data;
      if (data) {
        _handleBack();
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Something went wrong. Alerts not updated.')),
        );
      }
    }
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
          title: const Text("Edit & History"),
        ),
        body: Column(children: [
          SizedBox(
              height: 200,
              width: double.infinity,
              //color: Colors.blue,
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
                        final type = item['type'];
                        dropdowns["type"] = type;

                        return Form(
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: ResponsiveGridRow(children: [
                                  ResponsiveGridCol(
                                      xs: 12,
                                      md: 4,
                                      child: CheckboxListTile(
                                        title: Text('Check to mute $type'),
                                        value: isChecked,
                                        secondary: const Icon(
                                            MyIconData(0xf04b6),
                                            color: Color(0xfffce4ec),
                                            size: 40.0),
                                        contentPadding: const EdgeInsets.only(
                                          right: 100.0,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            isChecked = value!;
                                            dropdowns["mute"] = isChecked;
                                          });
                                        },
                                      )),
                                  ResponsiveGridCol(
                                    xs: 12,
                                    md: 4,
                                    child: DropdownButtonFormField<String>(
                                      value: item['delivery'],
                                      onChanged: (String? value) {
                                        setState(() {
                                          onSelectedValueChange(
                                              value!, 'delivery');
                                        });
                                      },
                                      items: ['email', 'sms', 'text', 'push']
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                            value: value, child: Text(value));
                                      }).toList(),
                                    ),
                                  ),
                                  ResponsiveGridCol(
                                    xs: 12,
                                    md: 4,
                                    child: DropdownButtonFormField<String>(
                                      value: item["frequency"],
                                      onChanged: (String? value) {
                                        setState(() {
                                          onSelectedValueChange(
                                              value!, 'frequency');
                                        });
                                      },
                                      items: [
                                        'all',
                                        'daily',
                                        'weekly',
                                        'monthly'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                            value: value, child: Text(value));
                                      }).toList(),
                                    ),
                                  ),
                                  ResponsiveGridCol(
                                      xs: 12,
                                      md: 4,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 10, 10, 10),
                                            backgroundColor: Colors.red),
                                        child: const Text('DELETE ALERT',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                            )),
                                        onPressed: () {},
                                      )),
                                ])));
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
