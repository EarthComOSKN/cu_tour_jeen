import 'package:flutter/material.dart';

class ConnectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Looking for Game Host"),
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
