import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

import '../../getUserFromPreference.dart';

// ignore: must_be_immutable
class MyDropdown extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final Function(String, String) onSelectedValueChange;
  final Function() enable;
  // ignore: prefer_typing_uninitialized_variables
  final drop;

  const MyDropdown(
      {Key? key,
      required this.selected,
      required this.drop,
      required this.onSelectedValueChange,
      required this.enable})
      : super(key: key);

  final String selected;

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  MyDropdownState createState() =>

      // ignore: no_logic_in_create_state
      MyDropdownState(selected, drop, onSelectedValueChange, enable);
}

class MyDropdownState extends State<MyDropdown>
    with AutomaticKeepAliveClientMixin {
  final String selected;
  final Function(String, String) onSelectedValueChange;
  final Function() enable;

  // ignore: prefer_typing_uninitialized_variables
  final drop;
  final state = LocalState();
  final HttpsCallable cityCallable =
      FirebaseFunctions.instance.httpsCallable('getCities');
  final HttpsCallable stateCallable =
      FirebaseFunctions.instance.httpsCallable('getStates');

  MyDropdownState(
      this.selected, this.drop, this.onSelectedValueChange, this.enable);

  Future<List<String>> createDdArray() async {
    final username = await state.getMap("USER");
    List<String> thearray = [];
    if (selected == "state") {
      final state =
          await stateCallable.call(<String, dynamic>{'uid': username['uid']});
      thearray = state.data;
      //  [
      //   'Select $selected',
      //   'Maine',
      //   'New Hamshire',
      //   'New York',
      //   'New Jersey',
      //   'Pennsylvyania'
      // ];
    } else if (selected == "city") {
      final city =
          await cityCallable.call(<String, dynamic>{'uid': username['uid']});
      thearray = city.data; //['Select $selected', 'Lisbon', 'Portland'];
    } else if (selected == "frequency") {
      thearray = ['Select $selected', 'all', 'daily', 'weekly', 'monthly'];
    } else if (selected == "delivery") {
      thearray = ['Select $selected', 'email', 'sms', 'push'];
    }

    return thearray;
  }

  Future<List<String>> returnList() async {
    return enable() ? await createDdArray() : [];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        builder: (context, alertSnap) {
          if (alertSnap.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (alertSnap.hasError) {
            return Text('Error: ${alertSnap.error}');
          } else {
            List<String> data = alertSnap.data!;
            return DropdownButtonFormField<String>(
              value: enable() ? drop[selected] : null,
              onChanged: (String? value) {
                setState(() {
                  onSelectedValueChange(value!, selected);
                });
              },
              validator: (value) {
                if (value == null || value == 'Select $selected') {
                  return 'Please select an option';
                }
                return null;
              },
              items: data.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList(),
            );
          }
        },
        future: returnList());
  }

  @override
  bool get wantKeepAlive => true;
}
