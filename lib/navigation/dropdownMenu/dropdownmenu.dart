import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyDropdown extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final Function(String, String) onSelectedValueChange;

  // ignore: prefer_typing_uninitialized_variables
  final drop;

  const MyDropdown(
      {Key? key,
      required this.selected,
      required this.drop,
      required this.onSelectedValueChange})
      : super(key: key);

  final String selected;

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _MyDropdownState createState() =>

      // ignore: no_logic_in_create_state
      _MyDropdownState(selected, drop, onSelectedValueChange);
}

class _MyDropdownState extends State<MyDropdown> {
  final String selected;
  final Function(String, String) onSelectedValueChange;

  // ignore: prefer_typing_uninitialized_variables
  final drop;

  _MyDropdownState(this.selected, this.drop, this.onSelectedValueChange);

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
    } else {
      thearray = ['Select $selected', 'Lisbon', 'Portland'];
    }
    return thearray;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: drop[selected],
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
      items: createDdArray().map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
