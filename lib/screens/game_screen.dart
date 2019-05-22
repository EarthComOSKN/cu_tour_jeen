import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:monopoly_money/components/log_tile.dart';
import 'package:monopoly_money/providers/game_logs.dart';
import 'package:monopoly_money/providers/players.dart';
import 'package:monopoly_money/providers/user.dart';
import 'package:monopoly_money/providers/world.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Center(
        child: Column(
          children: <Widget>[
            GamePanel(),
            Text("Game Logs"),
            Expanded(child: GameLogsListview()),
          ],
        ),
      ),
    );
  }
}

class GamePanel extends StatefulWidget {
  const GamePanel({
    Key key,
  }) : super(key: key);

  @override
  _GamePanelState createState() => _GamePanelState();
}

class _GamePanelState extends State<GamePanel> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Players>(
      builder: (context, players, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Consumer<User>(
                  builder: (context, user, child) {
                    return Text(user.money.toString());
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Disconnect from Game?"),
                            actions: <Widget>[
                              RaisedButton(
                                child: Text("Yes"),
                                onPressed: () {
                                  Nearby().stopAllEndpoints();
                                  Navigator.of(context).pop();
                                  Provider.of<World>(World.context)
                                      .currentScreen = ScreenState.StartScreen;
                                },
                              )
                            ],
                          );
                        });
                  },
                ),
              ],
            ),
            RaisedButton(
              child: Text("Bank"),
              onPressed: () {
                Player player = Player("bank", "0");
                showDialog(
                    context: World.context,
                    builder: (context) {
                      return SimpleDialog(
                        children: <Widget>[
                          RaisedButton(
                            child: Text("Pay"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              payDialog(player);
                            },
                          ),
                          RaisedButton(
                            child: Text("Get"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              getDialog();
                            },
                          ),
                          RaisedButton(
                            child: Text("Pass Go"),
                            onPressed: () {
                              World world = Provider.of<World>(context);
                              Player rp = world.players.getRandomOpponent();
                              StringBuffer buffer = StringBuffer("go,");
                              buffer.write(world.user.nickName);
                              buffer.write(",");
                              buffer.write(rp.nickName);
                              if (world.user.isHost) {
                                Nearby().sendPayload(
                                    rp.endPointId,
                                    Uint8List.fromList(
                                        buffer.toString().codeUnits));
                              } else {
                                Nearby().sendPayload(
                                    world.hostId,
                                    Uint8List.fromList(
                                        buffer.toString().codeUnits));
                              }

                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
            ...getPlayerTiles(players)
          ],
        );
      },
    );
  }
}

List<Widget> getPlayerTiles(Players players) {
  String userNick = Provider.of<User>(World.context).nickName;
  return players.playerList.map((player) {
    if (userNick == player.nickName)
      return RaisedButton(child: Text(player.nickName), onPressed: null);

    return RaisedButton(
      child: Text(player.nickName),
      onPressed: () {
        payDialog(player);
      },
    );
  }).toList();
}

void payDialog(Player reciever) {
  TextEditingController t = TextEditingController();
  showDialog(
      context: World.context,
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            RaisedButton(
              child: Text("Pay"),
              onPressed: () {
                World world = Provider.of<World>(World.context);
                int amt = int.parse(t.text);
                if (amt > 0 && world.user.money >= amt) {
                  StringBuffer buffer = StringBuffer("pay,");
                  buffer.write(reciever.nickName);
                  buffer.write(",");
                  buffer.write(world.user.nickName);
                  buffer.write(",");
                  buffer.write(amt.toString());

                  if (world.user.isHost) {
                    for (Player player in world.players.opponents) {
                      Nearby().sendPayload(player.endPointId,
                          Uint8List.fromList(buffer.toString().codeUnits));
                    }
                  } else {
                    Nearby().sendPayload(world.hostId,
                        Uint8List.fromList(buffer.toString().codeUnits));
                  }

                  world.user.subtractMoney(amt);

                  Navigator.of(context).pop();
                }
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: t,
            )
          ],
        );
      });
}

void getDialog() {
  TextEditingController t = TextEditingController();
  showDialog(
      context: World.context,
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            RaisedButton(
              child: Text("Get"),
              onPressed: () {
                World world = Provider.of<World>(World.context);
                int amt = int.parse(t.text);
                Player permitter = world.players.getRandomOpponent();
                StringBuffer buffer = StringBuffer("get,");
                buffer.write(world.user.nickName);
                buffer.write(",");
                buffer.write(permitter.nickName);
                buffer.write(",");
                buffer.write(amt.toString());

                if (world.user.isHost) {
                  Nearby().sendPayload(permitter.endPointId,
                      Uint8List.fromList(buffer.toString().codeUnits));
                } else {
                  Nearby().sendPayload(world.hostId,
                      Uint8List.fromList(buffer.toString().codeUnits));
                }

                Navigator.of(context).pop();
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: t,
            )
          ],
        );
      });
}

class GameLogsListview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameLogs>(
      builder: (context, gameLogs, child) {
        int len = gameLogs.logs.length;
        return ListView.builder(
          itemCount: len,
          itemBuilder: (context, i) {
            return LogTile(gameLogs.logs[len - i]);
          },
        );
      },
    );
  }
}
