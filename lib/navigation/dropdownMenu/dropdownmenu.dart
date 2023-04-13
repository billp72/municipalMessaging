import 'package:flutter/material.dart';

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
  _MyDropdownState createState() =>

      // ignore: no_logic_in_create_state
      _MyDropdownState(selected, drop, onSelectedValueChange, enable);
}

class _MyDropdownState extends State<MyDropdown>
    with AutomaticKeepAliveClientMixin {
  final String selected;
  final Function(String, String) onSelectedValueChange;
  final Function() enable;

  // ignore: prefer_typing_uninitialized_variables
  final drop;
  // final state = LocalState();
  // final HttpsCallable callable =
  //     FirebaseFunctions.instance.httpsCallable('getUserAlerts');
  // dynamic _username;

  _MyDropdownState(
      this.selected, this.drop, this.onSelectedValueChange, this.enable);

  List<String> createDdArray() {
    List<String> thearray = [];
    if (selected == "state") {
      thearray = [
        'Select $selected',
        'Maine',
        'New Hamshire',
        'New York',
        'New Jersey',
        'Pennsylvyania'
      ];
    } else if (selected == "city") {
      // _username = await state.getMap("USER");
      // final resp =
      //     await callable.call(<String, dynamic>{'uid': _username['uid']});
      // final data = resp.data;
      thearray = ['Select $selected', 'Lisbon', 'Portland'];
    } else if (selected == "frequency") {
      thearray = ['Select $selected', 'all', 'daily', 'weekly', 'monthly'];
    } else if (selected == "delivery") {
      thearray = ['Select $selected', 'email', 'sms', 'push'];
    }

    return thearray;
  }

  List<String> returnList() {
    return enable() ? createDdArray() : [];
  }

  //bool onDropdownChanged = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      items: returnList().map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
