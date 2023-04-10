import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDropdown extends StatefulWidget {
  const MyDropdown({Key? key, required this.selected}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final String selected;
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _MyDropdownState createState() => _MyDropdownState(selected);
}

class _MyDropdownState extends State<MyDropdown> {
  String selectedState = "Maine";
  final String selected;

  _MyDropdownState(this.selected);
  // ignore: no_leading_underscores_for_local_identifiers
  void _setSelectedValue(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(selected, value);
    setState(() {
      selectedState = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedState,
      onChanged: (String? value) {
        _setSelectedValue(value!);
      },
      items: <String>[
        'Maine',
        'New Hamshire',
        'New York',
        'New Jersey',
        'Pennsylvyania'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
