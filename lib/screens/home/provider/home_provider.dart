import 'package:flutter/material.dart';
import 'package:mirror_wall/utils/shared_preference.dart';

class HomeProvider with ChangeNotifier {
  double indicator = 0.0;
  List<String> book = [];
  String search = 'Google';

  void changeUrl(double p1) {
    indicator = p1;
    notifyListeners();
  }

  void changeEngine(change) {
    search = change;
    notifyListeners();
  }

  Future<void> addBookMark(List<String> addBook) async {
    if (getBook() == null) {
      book = [];
    } else {
      addBook = (await getBook())!;
    }
    notifyListeners();
  }

  void getBookMark() {}
}
