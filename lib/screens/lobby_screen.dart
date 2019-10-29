import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cu_tour_jeen/components/player_tile.dart';
import 'package:cu_tour_jeen/providers/players.dart';
import 'package:cu_tour_jeen/providers/user.dart';
import 'package:cu_tour_jeen/providers/world.dart';
import 'package:cu_tour_jeen/theme/style.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';

class LobbyScreen extends StatelessWidget {
  final bool hostScreen;

  LobbyScreen(this.hostScreen);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: roundedBorderShape,
                          title: Text("Leave Game Lobby?"),
                          actions: <Widget>[
                            RaisedButton(
                              shape: roundedBorderShape,
                              child: Text(
                                "Yes",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Nearby().stopAllEndpoints();
                                Nearby()
                                    .stopAdvertising(); //discover was already stopped before reaching here
                                Navigator.of(context).pop();
                                Provider.of<World>(World.context)
                                    .currentScreen = ScreenState.StartScreen;
                                Provider.of<Players>(context)
                                    .removeAllPlayers();
                              },
                            )
                          ],
                        );
                      });
                },
              ),
            ],
          ),
          Text(
            " Lobby",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
          ),
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
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            RaisedButton(
                color: Colors.blue,
                padding: EdgeInsets.all(8),
                child: Text(
                  "Let Tour",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
                ),
                onPressed: () => {}),
          ])
        ],
      ),
    );
  }
}
