// ignore: file_names
import 'package:flutter/material.dart';
import 'package:municipal_messaging/navigation/icons/my_icon.dart';
import 'package:municipal_messaging/navigation/dropdownMenu/dropdownmenu.dart';
import 'package:responsive_grid/responsive_grid.dart';

abstract class ListItem {
  Widget buildSubtitle();
}

class MessageItem extends StatefulWidget implements ListItem {
  final Function(Object) submitAlert;
  const MessageItem(
      {Key? key,
      required this.hex,
      required this.body,
      required this.color,
      required this.submitAlert})
      : super(key: key);

  @override
  Widget buildSubtitle() {
    return Text(body);
  }

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _MyStatefulWidgetState createState() =>
      // ignore: no_logic_in_create_state
      _MyStatefulWidgetState(hex, body, color, submitAlert);
  final int hex;
  final String body;
  final int color;
}

class _MyStatefulWidgetState extends State<MessageItem>
    with AutomaticKeepAliveClientMixin {
  final int hex;
  final String body;
  final int color;
  final String frequencyDefault = "Select frequency";
  final String deliveryDefault = "Select delivery";
  final Function(Object) submitAlert;

  bool isChecked = false;

  final Map<String, Object> dropdowns = {
    "frequency": "Select frequency",
    "delivery": "Select delivery",
    "type": "",
    "start": false
  };

  void _setSelectedValue(String value, String type) async {
    dropdowns[type] = value;
    if (dropdowns["frequency"] != frequencyDefault &&
        dropdowns["delivery"] != deliveryDefault &&
        type.isNotEmpty) {
      submitAlert(dropdowns);
    }
  }

  bool enabled() {
    return isChecked;
  }

  _MyStatefulWidgetState(this.hex, this.body, this.color, this.submitAlert);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
        child: Form(
            child: ResponsiveGridRow(children: [
      ResponsiveGridCol(
          xs: 12,
          md: 4,
          child: CheckboxListTile(
            title: widget.buildSubtitle(),
            value: isChecked,
            secondary: Icon(MyIconData(hex), color: Color(color), size: 40.0),
            contentPadding: const EdgeInsets.only(
              right: 100.0,
            ),
            onChanged: (value) {
              setState(() {
                isChecked = value!;
                if (isChecked) {
                  dropdowns["type"] = body;
                } else {
                  dropdowns["frequency"] = frequencyDefault;
                  dropdowns["delivery"] = deliveryDefault;
                  submitAlert({"type": body});
                }
              });
            },
          )),
      ResponsiveGridCol(
          xs: 12,
          md: 4,
          child: MyDropdown(
              selected: "frequency",
              drop: dropdowns,
              enable: enabled,
              onSelectedValueChange: _setSelectedValue)),
      ResponsiveGridCol(
          xs: 12,
          md: 4,
          child: MyDropdown(
              selected: "delivery",
              drop: dropdowns,
              enable: enabled,
              onSelectedValueChange: _setSelectedValue))
    ])));
  }

  @override
  bool get wantKeepAlive => true;
}
