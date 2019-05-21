import 'package:flutter/foundation.dart';

class User extends ChangeNotifier {
  bool isHost = false;
  int money;

  String _nickName;

  User(this._nickName);

  String get nickName {
    return _nickName;
  }

  set nickName(String s) {
    _nickName = s;
    notifyListeners();
  }

  void addMoney(int amt) {
    money += amt;
    notifyListeners();
  }

  void subtractMoney(int amt) {
    money -= amt;
    notifyListeners();
  }

  @override
  String toString() => _nickName;
}
