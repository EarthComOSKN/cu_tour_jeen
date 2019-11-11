import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cu_tour_jeen/providers/players.dart';
import 'package:cu_tour_jeen/providers/user.dart';
import 'package:cu_tour_jeen/providers/world.dart';
import 'package:cu_tour_jeen/theme/style.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new TextField(
          controller: _controller,
          decoration: new InputDecoration(
            hintText: 'Type something',
          ),
        ),
        new RaisedButton(
          onPressed: () {
            print(_controller.text);
          },
          child: new Text('DONE'),
        ),
      ],
    );
  }
}
