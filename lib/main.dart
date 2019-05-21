import 'package:flutter/material.dart';
import 'package:monopoly_money/providers/world.dart';
import 'package:monopoly_money/screens/game_screen.dart';
import 'package:monopoly_money/screens/lobby_screen.dart';
import 'package:monopoly_money/screens/start_screen.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final World world = World();

  @override
  void initState() {
    super.initState();
    Nearby().askPermission();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          notifier: world,
        ),
        ChangeNotifierProvider.value(
          notifier: world.user,
        ),
      ],
      child: MaterialApp(
        title: '\$\$Monopoly-Money\$\$',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<World>(
        builder: (context, world, child) {
          switch (world.getCurrentScreen()) {
            case ScreenState.StartScreen:
              return StartScreen();
            case ScreenState.LobbyScreen:
              return LobbyScreen();
            case ScreenState.GameScreen:
              return GameScreen();
          }
        },
      ),
    );
  }
}
