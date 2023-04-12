// ignore: file_names
import 'package:flutter/material.dart';
import 'package:municipal_messaging/navigation/icons/my_icon.dart';

abstract class ListItem{

  Widget buildSubtitle();

}



class MessageItem extends StatefulWidget implements ListItem{
  const MessageItem({Key? key, required this.hex, required this.body}) : super(key: key);

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

class _MyStatefulWidgetState extends State<MessageItem>{
  final int hex;
  bool isChecked = false;
  _MyStatefulWidgetState(this.hex);

  @override
  Widget build(BuildContext context) => 
    CheckboxListTile(
        title: widget.buildSubtitle(),
        value: isChecked,
        secondary: Icon(
          MyIconData(hex),
          size: 35.0
        ), 
        controlAffinity: ListTileControlAffinity.trailing,
        onChanged: (bool? value) { 
            setState(() {
              isChecked = value!;
            });
         },
    );
}