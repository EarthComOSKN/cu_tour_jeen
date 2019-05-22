import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:monopoly_money/providers/players.dart';
import 'package:monopoly_money/providers/user.dart';
import 'package:monopoly_money/providers/world.dart';
import 'package:monopoly_money/theme/style.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    //else below code

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "\$\$ ",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.blue,
                          fontWeight: FontWeight.w900)),
                  TextSpan(
                      text: "Monopoly-Money",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w900)),
                  TextSpan(
                      text: " \$\$",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.blue,
                          fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              //edit the userNickName onTap
              var t = TextEditingController();
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: roundedBorderShape,
                      title: Text("Set NickName"),
                      content: TextField(
                        controller: t,
                        decoration: InputDecoration(hintText: "Nick Name"),
                        autofocus: true,
                        textAlign: TextAlign.center,
                      ),
                      actions: <Widget>[
                        RaisedButton(
                          shape: roundedBorderShape,
                          child: Text(
                            "Set",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (t.text.trim().isNotEmpty) {
                              Provider.of<User>(context).nickName =
                                  t.text.trim();
                              Navigator.pop(context);
                            }
                          },
                        )
                      ],
                    );
                  });
            },
            child: Consumer<User>(
              builder: (context, user, child) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        user.nickName,
                        style: TextStyle(fontSize: 30),
                      ),
                      Icon(Icons.edit)
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                color: Colors.blue,
                padding: EdgeInsets.all(8),
                child: Text(
                  "HOST",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
                ),
                onPressed: onPressHost,
              ),
              VerticalDivider(),
              RaisedButton(
                color: Colors.blue,
                padding: EdgeInsets.all(8),
                child: Text(
                  "JOIN",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
                ),
                onPressed: onPressJoin,
              )
            ],
          ),
        ],
      ),
    );
  }

  void onPressHost() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Nearby().startAdvertising(
          Provider.of<User>(World.context).nickName, Strategy.P2P_STAR,
          onConnectionInitiated: (endpointId, connectionInfo) async {
        try {
          await Nearby().acceptConnection(
            endpointId,
            onPayLoadRecieved: payloadRecieved,
          );
          //will only add if successful
          Provider.of<Players>(World.context)
              .addPlayer(Player(connectionInfo.endpointName, endpointId));
        } catch (exception) {
          Scaffold.of(World.context).showSnackBar(SnackBar(
            content: Text(exception.toString()),
          ));
        }
      }, onConnectionResult: (endpointId, status) {
        if (status != Status.CONNECTED) {
          Provider.of<Players>(World.context).removePlayer(endpointId);
        }
      }, onDisconnected: (endpointId) {
        Provider.of<Players>(World.context).removePlayer(endpointId);
      });

      Provider.of<User>(World.context).isHost = true;
      // add your own name to list of players
      Provider.of<Players>(World.context)
          .addPlayer(Player(Provider.of<User>(World.context).nickName, null));
      // change state if advertising is started successfully
      Provider.of<World>(World.context).currentScreen = ScreenState.LobbyScreen;
    } catch (exception) {
      Scaffold.of(World.context).showSnackBar(SnackBar(
        content: Text(exception.toString()),
      ));
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onPressJoin() async {
    setState(() {
      isLoading = true;
    });

    try {
      await Nearby().startDiscovery(
        Provider.of<User>(World.context).nickName,
        Strategy.P2P_STAR,
        onEndpointFound: (endpointId, endpointName, serviceId) async {
          try {
            await Nearby().requestConnection(
                Provider.of<User>(World.context).nickName, endpointId,
                onConnectionInitiated: (endpointId, connectionInfo) async {
              try {
                await Nearby().acceptConnection(
                  endpointId,
                  onPayLoadRecieved: payloadRecieved,
                );
                //will only add if successfully sent accept request
                Provider.of<Players>(World.context)
                    .addPlayer(Player(connectionInfo.endpointName, endpointId));
              } catch (exception) {
                Scaffold.of(World.context).showSnackBar(SnackBar(
                  content: Text(exception.toString()),
                ));
              }
            }, onConnectionResult: (endpointId, status) {
              if (status != Status.CONNECTED) {
                Provider.of<Players>(World.context).removePlayer(endpointId);
              } else {
                Provider.of<World>(World.context).currentScreen =
                    ScreenState.LobbyScreen;
                Provider.of<World>(World.context).hostId = endpointId;
                //for securing connection error chances
                Nearby().stopDiscovery();
              }
            }, onDisconnected: (endpointId) {
              Provider.of<Players>(World.context).removePlayer(endpointId);
            });
          } catch (exception) {
            print(exception.toString());
            Scaffold.of(World.context).showSnackBar(SnackBar(
              content: Text(exception.toString()),
            ));
          }
        },
        onEndpointLost: (endpointId) {},
      );

      Provider.of<User>(World.context).isHost = false;
      //add own name before start
      Provider.of<Players>(World.context)
          .addPlayer(Player(Provider.of<User>(World.context).nickName, "0"));
      // change state if discovery is started successfully

      Provider.of<World>(World.context).currentScreen =
          ScreenState.ConnectScreen;
    } catch (exception) {
      Scaffold.of(World.context).showSnackBar(SnackBar(
        content: Text(exception.toString()),
      ));
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  //called on recieving payload
  void payloadRecieved(String endpointId, Uint8List bytes) {
    World world = Provider.of<World>(World.context);

    List<String> payload = String.fromCharCodes(bytes).split(",");
    // storing game logs for use later
    world.gameLogs.addLog(payload);

    print(payload[0]);
    switch (payload[0]) {
      case "start":
        // method, starting-money, go-money, p1, p2, p3...
        world.goMoney = int.parse(payload[2]);
        world.user.money = int.parse(payload[1]);

        // arrange names of player in same order but keep endpointId intact
        // List<Player> list = Provider.of<Players>(World.context).playerList;
        // list.firstWhere((p)=>s==p.nickName).endPointId
        world.players.refreshPlayers(payload
            .getRange(3, payload.length)
            .map((s) => Player(s, "0"))
            .toList());

        world.currentScreen = ScreenState.GameScreen;

        Nearby().stopAdvertising();
        break;
      case "pay":
        // method, reciever, sender, money
        if (payload[1] == world.user.nickName) {
          world.user.addMoney(int.parse(payload[3]));
        }

        if (world.user.isHost) {
          for (Player player in world.players.opponents) {
            Nearby().sendPayload(player.endPointId, bytes);
          }
        }

        break;
      case "go":
        // method, reciever, permitter
        if (payload[2] == world.user.nickName) {
          // show sheet
          permitGoDialog(payload[1]);
        } else if (world.user.isHost) {
          //forward to permitter
          Nearby().sendPayload(
              world.players.playerList
                  .firstWhere((p) => p.nickName == payload[2])
                  .endPointId,
              bytes);
        }

        break;
      case "get":
        // method, reciever, permitter, money
        if (payload[2] == world.user.nickName) {
          // show sheet
          permitGetDialog(payload[1], payload[3]);
        } else if (world.user.isHost) {
          //forward to permitter
          Nearby().sendPayload(
              world.players.playerList
                  .firstWhere((p) => p.nickName == payload[2])
                  .endPointId,
              bytes);
        }
        break;
      case "go-success":
        // method, reciever, permitter, allowed
        if (payload[1] == world.user.nickName && payload[3] == "true") {
          world.user.addMoney(world.goMoney);
        }

        if (world.user.isHost) {
          for (Player player in world.players.opponents) {
            Nearby().sendPayload(player.endPointId, bytes);
          }
        }

        break;
      case "get-success":
        // method, reciever, permitter, money, allowed
        if (payload[1] == world.user.nickName && payload[4] == "true") {
          world.user.addMoney(int.parse(payload[3]));
        }

        if (world.user.isHost) {
          for (Player player in world.players.opponents) {
            Nearby().sendPayload(player.endPointId, bytes);
          }
        }
        break;
    }
  }

  void permitGoDialog(String reciever) {
    showDialog(
        barrierDismissible: false,
        context: World.context,
        builder: (context) {
          return AlertDialog(
            shape: roundedBorderShape,
            title: Text("Allow $reciever to collect Go Money ?"),
            actions: <Widget>[
              RaisedButton(
                child: Text(
                  "Allow",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  sendGoSuccessPayload(true, reciever);
                  Navigator.pop(context);
                },
              ),
              RaisedButton(
                child: Text(
                  "Deny",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  sendGoSuccessPayload(false, reciever);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void sendGoSuccessPayload(bool allowed, String reciever) {
    User user = Provider.of<User>(World.context);
    StringBuffer buffer = StringBuffer("go-success,");
    buffer.write(reciever);
    buffer.write(",");
    buffer.write(user.nickName);
    buffer.write(",");
    buffer.write(allowed.toString());

    if (user.isHost) {
      //send log to self
      Provider.of<World>(World.context)
          .gameLogs
          .addLog(buffer.toString().split(","));
      for (Player player in Provider.of<Players>(World.context).opponents) {
        Nearby().sendPayload(
            player.endPointId, Uint8List.fromList(buffer.toString().codeUnits));
      }
    } else {
      Nearby().sendPayload(Provider.of<World>(World.context).hostId,
          Uint8List.fromList(buffer.toString().codeUnits));
    }
  }

  void permitGetDialog(String reciever, String money) {
    showDialog(
        barrierDismissible: false,
        context: World.context,
        builder: (context) {
          return AlertDialog(
            shape: roundedBorderShape,
            title: Text("Allow $reciever to collect \$$money ?"),
            actions: <Widget>[
              RaisedButton(
                child: Text(
                  "Allow",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  sendGetSuccessPayload(true, reciever, money);
                  Navigator.pop(context);
                },
              ),
              RaisedButton(
                child: Text(
                  "Deny",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  sendGetSuccessPayload(false, reciever, money);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void sendGetSuccessPayload(bool allowed, String reciever, String money) {
    User user = Provider.of<User>(World.context);
    StringBuffer buffer = StringBuffer("get-success,");
    buffer.write(reciever);
    buffer.write(",");
    buffer.write(user.nickName);
    buffer.write(",");
    buffer.write(money);
    buffer.write(",");
    buffer.write(allowed.toString());

    if (user.isHost) {
      //send log to self
      Provider.of<World>(World.context)
          .gameLogs
          .addLog(buffer.toString().split(","));
      for (Player player in Provider.of<Players>(World.context).opponents) {
        Nearby().sendPayload(
            player.endPointId, Uint8List.fromList(buffer.toString().codeUnits));
      }
    } else {
      Nearby().sendPayload(Provider.of<World>(World.context).hostId,
          Uint8List.fromList(buffer.toString().codeUnits));
    }
  }
}
