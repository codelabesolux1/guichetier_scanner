import 'package:flutter/material.dart';

class NavBarProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int newCurrentIndex) {
    _currentIndex = newCurrentIndex;
    notifyListeners();
  }
}
