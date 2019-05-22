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
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(
              name.substring(0, 1).toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Text(name),
      ],
    );
  }
}
