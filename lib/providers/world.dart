import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_money/providers/players.dart';
import 'package:monopoly_money/providers/user.dart';

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
  //init values upon creating the world
  World()
      : user = User("User" + Random().nextInt(100).toString()),
        players = Players() {
    _currentScreen = ScreenState.StartScreen;
  }

  set currentScreen(ScreenState currentScreen) {
    _currentScreen = currentScreen;
    notifyListeners();
  }

  ScreenState get currentScreen => _currentScreen;
}
