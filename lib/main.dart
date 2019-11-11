import 'package:cu_tour_jeen/screens/chat_room.dart';
import 'package:flutter/material.dart';
import 'package:cu_tour_jeen/providers/world.dart';
import 'package:cu_tour_jeen/screens/connect_screen.dart';
import 'package:cu_tour_jeen/screens/lobby_screen.dart';
import 'package:cu_tour_jeen/screens/start_screen.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final World world = World();
  String message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";

  @override
  void initState() {
    // message = "No message.";

    // var initializationSettingsAndroid =
    //     AndroidInitializationSettings('ic_launcher');

    // var initializationSettingsIOS = IOSInitializationSettings(
    //     onDidReceiveLocalNotification: (id, title, body, payload) {
    //   print("onDidReceiveLocalNotification called.");
    // });
    // var initializationSettings = InitializationSettings(
    //     initializationSettingsAndroid, initializationSettingsIOS);

    // flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: (payload) {
    //   // when user tap on notification.
    //   print("onSelectNotification called.");
    //   setState(() {
    //     message = payload;
    //   });
    // });
    super.initState();
    Nearby().askLocationPermission();
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
        ChangeNotifierProvider.value(
          notifier: world.gameLogs,
        ),
      ],
      child: MaterialApp(
        title: 'Monopoly-Money',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
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
            case ScreenState.ChatScreen:
              return ChatScreen();
          }
        },
      ),
    );
  }
}
