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

  void setLink1(String link) {
    book.add(link);
    SharedHelper.helper.setBook(book);
    getBookMark();
    notifyListeners();
  }

  Future<void> getBookMark() async {
    var link = await SharedHelper.helper.getBook();
    if (link != null) {
      book = link;
    }
    notifyListeners();
  }

  void deleteLink(int index) {
    book.removeAt(index);
    SharedHelper.helper.setBook(book);
    notifyListeners();
  }
}
