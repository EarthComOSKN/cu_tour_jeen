import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:monopoly_money/components/player_tile.dart';
import 'package:monopoly_money/providers/players.dart';
import 'package:monopoly_money/providers/user.dart';
import 'package:monopoly_money/providers/world.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';

class LobbyScreen extends StatelessWidget {
  final bool hostScreen;

  LobbyScreen(this.hostScreen);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Game Settings\n\n"),
          Text("Starting Money: 1500\$"),
          Text("Pass Go Money: 200\$\n\n"),
          if (hostScreen)
            Center(
              child: RaisedButton(
                child: Text("Start"),
                onPressed: () async {
                  Provider.of<World>(context).currentScreen =
                      ScreenState.GameScreen;
                  // send Payload for gamestart
                  StringBuffer buffer = StringBuffer("start,1500,200");
                  Provider.of<World>(context).goMoney = 200;
                  Provider.of<User>(context).money = 1500;
                  
                  for (var player in Provider.of<Players>(context).playerList) {
                    buffer.write(",");
                    buffer.write(player.nickName);
                  }
                  for (var player in Provider.of<Players>(context).opponents) {
                    await Nearby().sendPayload(player.endPointId,
                        Uint8List.fromList(buffer.toString().codeUnits));
                  }
                },
              ),
            ),
          Text("Lobby"),
          Expanded(
            child: Consumer<Players>(
              builder: (context, players, child) {
                return ListView.builder(
                  itemCount: players.playerList.length,
                  itemBuilder: (context, i) {
                    return PlayerTile(players.playerList[i].nickName);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
