import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cu_tour_jeen/providers/game_logs.dart';
import 'package:cu_tour_jeen/providers/players.dart';
import 'package:cu_tour_jeen/providers/user.dart';

enum ScreenState { StartScreen, ConnectScreen, LobbyScreen, GameScreen }

class World with ChangeNotifier {
  static BuildContext context;
  int goMoney;
  String hostId;
  //direct changeNotifiers
  ScreenState _currentScreen;

  //indirect changeNotifiers
  final User user;
  final Players players;
  final GameLogs gameLogs;
  //init values upon creating the world
  World()
      : user = User("User" + Random().nextInt(100).toString()),
        gameLogs = GameLogs(),
        players = Players() {
    _currentScreen = ScreenState.StartScreen;
  }

  set currentScreen(ScreenState currentScreen) {
    _currentScreen = currentScreen;
    notifyListeners();
  }

  ScreenState get currentScreen => _currentScreen;
}
