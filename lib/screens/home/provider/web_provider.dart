import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class WebProvider with ChangeNotifier {
  Connectivity connectivity = Connectivity();

  bool isInternet = false;

  void checkInternet() async {
    connectivity.onConnectivityChanged.listen(
          (event) {
        if (event.contains(ConnectivityResult.none)) {
          isInternet = false;
        } else {
          isInternet = true;
        }
        notifyListeners();
      },
    );
  }
}