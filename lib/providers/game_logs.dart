import 'package:flutter/foundation.dart';

class GameLogs with ChangeNotifier {
  final List<List<String>> logs;

  GameLogs() : logs = [];

  void addLog(List<String> payload) {
    if (payload[0] != "get" && payload[0] != "go") {
      logs.add(payload);
      notifyListeners();
    }
  }

  void clearLogs() {
    logs.clear();
    notifyListeners();
  }
}
