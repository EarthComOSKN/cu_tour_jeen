import 'package:flutter/material.dart';
import 'package:monopoly_money/providers/world.dart';
import 'package:monopoly_money/screens/connect_screen.dart';
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
        ChangeNotifierProvider.value(
          notifier: world.players,
        ),
      ],
      child: MaterialApp(
        title: 'Monopoly-Money',
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
          World.context = context;
          switch (world.currentScreen) {
            case ScreenState.StartScreen:
              return StartScreen();
            case ScreenState.ConnectScreen:
              return ConnectScreen();
            case ScreenState.LobbyScreen:
              return LobbyScreen(world.user.isHost);
            case ScreenState.GameScreen:
              return GameScreen();
          }
        },
      ),
    );
  }
}
