// ignore: file_names
import 'package:flutter/material.dart';
import 'package:municipal_messaging/navigation/icons/my_icon.dart';
import 'package:municipal_messaging/navigation/dropdownMenu/dropdownmenu.dart';

abstract class ListItem {
  Widget buildSubtitle();
}

class MessageItem extends StatefulWidget implements ListItem {
  const MessageItem({Key? key, required this.hex, required this.body})
      : super(key: key);

  @override
  Widget buildSubtitle() {
    return Text(body);
  }

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState(hex);
  final int hex;
  final String body;
}

class _MyStatefulWidgetState extends State<MessageItem> {
  final int hex;
  bool isChecked = false;

  final dropdowns = {
    'frequency': 'Select frequency',
    'delivery': 'Select delivery'
  };

  void _setSelectedValue(String value, String type) async {
    dropdowns[type] = value;
  }

  bool enabled() {
    return isChecked;
  }

  _MyStatefulWidgetState(this.hex);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
          child: CheckboxListTile(
        title: widget.buildSubtitle(),
        value: isChecked,
        secondary: Icon(MyIconData(hex), size: 35.0),
        contentPadding: const EdgeInsets.only(
          right: 50.0,
        ),
        onChanged: (value) {
          setState(() {
            isChecked = value!;
          });
        },
      )),
      Expanded(
          child: MyDropdown(
              selected: "frequency",
              drop: dropdowns,
              enable: enabled,
              onSelectedValueChange: _setSelectedValue)),
      Expanded(
          child: MyDropdown(
              selected: "delivery",
              drop: dropdowns,
              enable: enabled,
              onSelectedValueChange: _setSelectedValue))
    ]);
  }
}
