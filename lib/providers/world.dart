import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:monopoly_money/providers/user.dart';

enum ScreenState { StartScreen, LobbyScreen, GameScreen }

class World with ChangeNotifier {
  //direct changeNotifiers
  ScreenState _currentScreen;

  //indirect changeNotifiers
  final User user;

  //init values upon creating the world
  World() : user = User("User" + Random().nextInt(100).toString()) {
    _currentScreen = ScreenState.StartScreen;
  }

  set currentScreen(ScreenState currentScreen) {
    _currentScreen = currentScreen;
    notifyListeners();
  }

  ScreenState getCurrentScreen() => _currentScreen;
}
