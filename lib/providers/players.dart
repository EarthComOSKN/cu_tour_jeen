import 'dart:math';

import 'package:flutter/foundation.dart';

class Players with ChangeNotifier {
  final List<Player> _playerList;
  final Random _random;

  Players()
      : _playerList = [],
        _random = Random();

  List<Player> get playerList => _playerList;

  void addPlayers(List<Player> list) {
    _playerList.addAll(list);
    notifyListeners();
  }

  void refreshPlayers(List<Player> list) {
    _playerList.clear();
    _playerList.addAll(list);
    notifyListeners();
  }

  void addPlayer(Player player) {
    _playerList.add(player);
    notifyListeners();
  }

  void removePlayer(String playerId) {
    _playerList.removeWhere((player) => playerId == player.endPointId);
    notifyListeners();
  }

  void removeAllPlayers() {
    _playerList.clear();
    notifyListeners();
  }
}

class Player {
  String nickName;
  String endPointId;

  Player(this.nickName, this.endPointId);
}
