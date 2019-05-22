import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monopoly_money/components/log_tile.dart';
import 'package:monopoly_money/providers/game_logs.dart';
import 'package:monopoly_money/providers/players.dart';
import 'package:monopoly_money/providers/user.dart';
import 'package:monopoly_money/providers/world.dart';
import 'package:monopoly_money/theme/style.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: GamePanel(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Logs",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            ),
          ),
          Expanded(child: GameLogsListview()),
        ],
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
                    return Text(
                      "${user.money.toString()}\$",
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 30),
                    );
                  },
                ),
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
                            title: Text("Disconnect from Game?"),
                            actions: <Widget>[
                              RaisedButton(
                                shape: roundedBorderShape,
                                child: Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Nearby().stopAllEndpoints();
                                  Navigator.of(context).pop();
                                  Provider.of<World>(context).currentScreen =
                                      ScreenState.StartScreen;
                                  Provider.of<World>(context)
                                      .gameLogs
                                      .clearLogs();
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
            RaisedButton(
              color: Colors.yellow[700],
              shape: roundedBorderShape,
              child: Text(
                "Bank",
                style: whiteTextStyle,
              ),
              onPressed: () {
                Player player = Player("bank", "0");
                showDialog(
                    context: World.context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Text("Bank"),
                        shape: roundedBorderShape,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        children: <Widget>[
                          RaisedButton(
                            shape: roundedBorderShape,
                            color: Colors.green,
                            child: Text(
                              "PAY",
                              style: whiteTextStyle,
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              payDialog(player);
                            },
                          ),
                          RaisedButton(
                            shape: roundedBorderShape,
                            color: Colors.yellow[700],
                            child: Text(
                              "GET",
                              style: whiteTextStyle,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              getDialog();
                            },
                          ),
                          RaisedButton(
                            shape: roundedBorderShape,
                            color: Colors.brown,
                            child: Text(
                              "PASS GO",
                              style: whiteTextStyle,
                            ),
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
      return RaisedButton(
          child: Text(
            player.nickName,
            style: whiteTextStyle,
          ),
          shape: roundedBorderShape,
          color: Colors.blue,
          onPressed: null);

    return RaisedButton(
      shape: roundedBorderShape,
      color: Colors.blue,
      child: Text(
        player.nickName,
        style: whiteTextStyle,
      ),
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
          title: Text(reciever.nickName),
          shape: roundedBorderShape,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          children: <Widget>[
            RaisedButton(
              shape: roundedBorderShape,
              color: Colors.green,
              child: Text(
                "PAY",
                style: whiteTextStyle,
              ),
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
                    //send log to self
                    world.gameLogs.addLog(buffer.toString().split(","));
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
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              controller: t,
              autofocus: true,
              textAlign: TextAlign.center,
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
          title: Text("Bank"),
          shape: roundedBorderShape,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          children: <Widget>[
            RaisedButton(
              color: Colors.yellow[700],
              child: Text(
                "GET",
                style: whiteTextStyle,
              ),
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
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              controller: t,
              autofocus: true,
              textAlign: TextAlign.center,
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
            return LogTile(gameLogs.logs[len - i - 1]);
          },
        );
      },
    );
  }
}
