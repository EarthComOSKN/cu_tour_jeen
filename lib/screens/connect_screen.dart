import 'package:flutter/material.dart';
import 'package:monopoly_money/providers/players.dart';
import 'package:monopoly_money/providers/world.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';

class ConnectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Looking for a Game Host"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
          RaisedButton(
            child: Text(
              "Cancel",
            ),
            onPressed: () {
              Nearby().stopAllEndpoints();
              Nearby().stopDiscovery();
              Provider.of<World>(World.context).currentScreen =
                  ScreenState.StartScreen;
              Provider.of<Players>(context).removeAllPlayers();
            },
          )
        ],
      ),
    );
  }
}
