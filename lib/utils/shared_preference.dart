import 'package:shared_preferences/shared_preferences.dart';

class SharedHelper
{
static SharedHelper helper = SharedHelper._();
  SharedHelper._();

  Future<void> setBook(List<String> l1) async {
    SharedPreferences bookList = await SharedPreferences.getInstance();
    bookList.setStringList("book", l1);
  }

  Future<List<String>?> getBook() async {
    List<String>? bookData = [];
    SharedPreferences bookList = await SharedPreferences.getInstance();
    bookData = bookList.getStringList("book");
    return bookData;
  }
}
