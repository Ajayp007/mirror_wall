import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  double indicator = 0.0;
  List<String> book = [];
  String? search;

  void changeUrl(double p1) {
    indicator = p1;
    notifyListeners();
  }

  void changeEngine(change) {
    search = change;
    notifyListeners();
  }
}
