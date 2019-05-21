import 'package:flutter/material.dart';

class PlayerTile extends StatelessWidget {
  final String name;
  PlayerTile(this.name);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(),
        ),
        Text(name),
      ],
    );
  }
}
