import 'dart:typed_data';

import 'package:cu_tour_jeen/providers/game_logs.dart';
import 'package:flutter/material.dart';
import 'package:cu_tour_jeen/providers/players.dart';
import 'package:cu_tour_jeen/providers/user.dart';
import 'package:cu_tour_jeen/providers/world.dart';
import 'package:cu_tour_jeen/theme/style.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = new TextEditingController();
  List<List<String>> messages = Provider.of<GameLogs>(World.context).logs;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Consumer<GameLogs>(
              builder: (context, gameLogs, child) {
                return ListView.builder(
                  itemCount: gameLogs.logs.length,
                  itemBuilder: (context, i) {
                    return Text(gameLogs.logs[i][0]);
                  },
                );
              },
            ),
          ),
          new TextField(
            controller: _controller,
            decoration: new InputDecoration(
              hintText: 'Type something',
            ),
          ),
          new RaisedButton(
            onPressed: () {
              print(_controller.text);
              User user = Provider.of<User>(World.context);
              String name = user.nickName;
              if (user.isHost) {
                String mes = _controller.text;
                Provider.of<GameLogs>(World.context).addLog(["$name :$mes"]);
                StringBuffer buffer = StringBuffer("");
                buffer.write("$name :");

                buffer.write(_controller.text);
                for (Player player
                    in Provider.of<Players>(World.context).opponents) {
                  print(player.nickName);
                  Nearby().sendBytesPayload(player.endPointId,
                      Uint8List.fromList(buffer.toString().codeUnits));
                }
              } else {
                World world = Provider.of<World>(context);
                StringBuffer buffer = StringBuffer("");
                buffer.write("$name :");
                buffer.write(_controller.text);
                // sendNotification();
                Nearby().sendBytesPayload(world.hostId,
                    Uint8List.fromList(buffer.toString().codeUnits));
              }
            },
            child: new Text('Send Message'),
          ),
        ],
      ),
    );
  }
}

//  ListView.builder(
//                 itemCount: messages.length,
//                 itemBuilder: (context, index) {
//                   return Text(messages[index][0]);
//                 }),
