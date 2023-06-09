// ignore: file_names
import 'package:flutter/material.dart';

abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

class HeadingItem implements ListItem {
  final String heading;
  final String type;

  HeadingItem(this.heading, this.type);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(heading,
        style: const TextStyle(
          fontSize: 24,
          color: Colors.red,
        ));
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

class MessageItem implements ListItem {
  final String sender;
  final String body;
  final String type;

  MessageItem(this.sender, this.body, this.type);

  @override
  Widget buildTitle(BuildContext context) => Text(sender,
      style: const TextStyle(
        color: Colors.blue,
      ));

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}
