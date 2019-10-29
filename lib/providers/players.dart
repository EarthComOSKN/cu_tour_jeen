import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:cu_tour_jeen/providers/user.dart';
import 'package:cu_tour_jeen/providers/world.dart';
import 'package:provider/provider.dart';

class Players with ChangeNotifier {
  final List<Player> _playerList;
  final Random _random;

  List<Player> _opponents;

  Players()
      : _playerList = [],
        _random = Random();

  List<Player> get playerList => _playerList;

  List<Player> get opponents {
    if (_opponents != null) return _opponents;

    _opponents = []..addAll(_playerList);
    _opponents.removeWhere((player) =>
        player.nickName == Provider.of<User>(World.context).nickName);

    return _opponents;
  }

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

  Player getRandomOpponent() {
    return opponents[_random.nextInt(opponents.length)];
  }
}

class Player {
  String nickName;
  String endPointId;

  Player(this.nickName, this.endPointId);
}
