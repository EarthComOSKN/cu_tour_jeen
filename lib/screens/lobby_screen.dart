import 'dart:typed_data';

import 'package:cu_tour_jeen/main.dart';
import 'package:flutter/material.dart';
import 'package:cu_tour_jeen/components/player_tile.dart';
import 'package:cu_tour_jeen/providers/players.dart';
import 'package:cu_tour_jeen/providers/user.dart';
import 'package:cu_tour_jeen/providers/world.dart';
import 'package:cu_tour_jeen/theme/style.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            child: Text(
              "Tour",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
            ),
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
                  "Super Button",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
                ),
                onPressed: () {
                  print("test");
                  World world = Provider.of<World>(context);
                  StringBuffer buffer =
                      StringBuffer("message from ลูกทัวจ้าาาา");
                  buffer.write(world.user.nickName);
                  buffer.write(",");
                  sendNotification()
                  Nearby().sendBytesPayload(world.hostId,
                      Uint8List.fromList(buffer.toString().codeUnits));

                  Scaffold.of(context).showSnackBar(new SnackBar(
                    content: new Text("Sending Message"),
                  ));
                }),
          ])
        ],
      ),
    );
  }
}

sendNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails('10000',
      'FLUTTER_NOTIFICATION_CHANNEL', 'FLUTTER_NOTIFICATION_CHANNEL_DETAIL',
      importance: Importance.Max, priority: Priority.High);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();

  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(111, 'Hello, benznest.',
      'This is a your notifications. ', platformChannelSpecifics,
      payload: 'I just haven\'t Met You Yet');
}
