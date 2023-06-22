import 'package:flutter/foundation.dart';

class BottomProvider extends ChangeNotifier{
  //Index of the BottomBar
  int index = 0;

  void toggle(int index) {
    this.index = index;
    notifyListeners();
  }

}