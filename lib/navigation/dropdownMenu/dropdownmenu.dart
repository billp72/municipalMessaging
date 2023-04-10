import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDropdown extends StatefulWidget {
  const MyDropdown({Key? key, required this.selected}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables

  final String selected;
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _MyDropdownState createState() =>
      // ignore: no_logic_in_create_state
      _MyDropdownState(selected);
}

class _MyDropdownState extends State<MyDropdown> {
  final String selected;

  _MyDropdownState(this.selected);

  String initialselection = "Select";
  final _myController = TextEditingController();

  List<String> createDdArray() {
    List<String> thearray = [];
    if (selected == "STATE") {
      thearray = [
        'Select',
        'Maine',
        'New Hamshire',
        'New York',
        'New Jersey',
        'Pennsylvyania'
      ];
    } else {
      thearray = ["Select", "Lisbon", "Portland"];
    }
    return thearray;
  }

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
  }

  // ignore: no_leading_underscores_for_local_identifiers
  void _setSelectedValue(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(selected, value);
    setState(() {
      initialselection = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: initialselection,
      onChanged: (String? value) {
        _setSelectedValue(value!);
      },
      validator: (value) {
        if (value == null || value == "Select") {
          return 'Please select an option';
        }
        return null;
      },
      items: createDdArray().map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
