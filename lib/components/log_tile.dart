import 'package:flutter/material.dart';
import 'package:monopoly_money/theme/style.dart';

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
        textspan = TextSpan(
          text: "Started New Game\n",
          style: new TextStyle(
              fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w200),
          children: <TextSpan>[
            TextSpan(text: "Initial Money: \$${payload[1]}, "),
            TextSpan(text: "Passing Go Money: \$${payload[2]}\n"),
            TextSpan(text: "Players\n"),
            for (String s in payload.getRange(3, payload.length))
              TextSpan(text: "\n$s"),
          ],
        );
        break;

      case "pay":
        c = Colors.green[100];
        textspan = TextSpan(
            style: new TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.w300,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: "${payload[2].toUpperCase()} ",
                  style: darkRedTextStyle),
              TextSpan(text: "payed ${payload[3]}\$ to "),
              TextSpan(
                  text: "${payload[1].toUpperCase()}",
                  style: darkGreenTextStyle),
            ]);
        break;

      case "go-success":
        c = payload[3] == "true" ? Colors.brown[100] : Colors.red[100];
        textspan = TextSpan(
            style: new TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(text: "${payload[1]} ", style: darkGreenTextStyle),
              payload[3] == "true"
                  ? TextSpan(text: "recieved Go Money, ")
                  : TextSpan(
                      text: "was denied Go Money, ", style: darkRedTextStyle),
              TextSpan(text: "permitter- ${payload[2]}"),
            ]);
        break;

      case "get-success":
        c = payload[4] == "true" ? Colors.yellow[100] : Colors.red[100];
        textspan = TextSpan(
            style: new TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(text: "${payload[1]} ", style: darkGreenTextStyle),
              payload[4] == "true"
                  ? TextSpan(text: "recieved \$${payload[3]} ")
                  : TextSpan(
                      text: "was denied \$${payload[3]} ",
                      style: darkRedTextStyle),
              TextSpan(text: "from bank, permitter- ${payload[2]}"),
            ]);
        break;
    }

    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(6),
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
