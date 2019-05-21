import 'package:flutter/material.dart';
import 'package:monopoly_money/components/player_tile.dart';
import 'package:monopoly_money/providers/players.dart';
import 'package:monopoly_money/providers/world.dart';
import 'package:provider/provider.dart';

class LobbyScreen extends StatelessWidget {
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
          Center(
            child: RaisedButton(
              child: Text("Start"),
              onPressed: () {
                Provider.of<World>(context).currentScreen = ScreenState.GameScreen;
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
