import 'package:flutter/material.dart';

class LogTile extends StatelessWidget {
  final List<String> payload;
  LogTile(this.payload);
  @override
  Widget build(BuildContext context) {
    Color c;
    TextSpan textspan;

    switch (payload[0]) {
      case "start":
        c = Colors.grey[100];
        textspan = TextSpan(text: "Started New Game\n", children: <TextSpan>[
          TextSpan(text: "Initial Money: \$${payload[1]}, "),
          TextSpan(text: "Passing Go Money: \$${payload[2]}\n"),
          TextSpan(text: "Players\n"),
          for (String s in payload.getRange(3, payload.length))
            TextSpan(text: "$s\n"),
        ]);
        break;

      case "pay":
        c = Colors.green[100];
        textspan = TextSpan(children: <TextSpan>[
          TextSpan(text: "${payload[2]}"),
          TextSpan(text: "payed ${payload[3]} to"),
          TextSpan(text: "${payload[1]}"),
        ]);
        break;

      case "go-success":
        c = payload[3] == "true" ? Colors.yellow[100] : Colors.red[100];
        textspan = TextSpan(children: <TextSpan>[
          TextSpan(text: "${payload[1]} "),
          payload[3] == "true"
              ? TextSpan(text: "recieved Go Money, ")
              : TextSpan(text: "was denied Go Money, "),
          TextSpan(text: "permitter: ${payload[2]}"),
        ]);
        break;

      case "get-success":
        c = payload[4] == "true" ? Colors.yellow[100] : Colors.red[100];
        textspan = TextSpan(children: <TextSpan>[
          TextSpan(text: "${payload[1]} "),
          payload[3] == "true"
              ? TextSpan(text: "recieved \$${payload[3]} ")
              : TextSpan(text: "was denied \$${payload[3]} "),
          TextSpan(text: "from bank, permitter: ${payload[2]}"),
        ]);
        break;
    }

    return Container(
      color: c,
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: textspan,
        ),
      ),
    );
  }
}
