import 'package:flutter/foundation.dart';

class OrientationProvider extends ChangeNotifier{

   bool isPortrait = true;
   bool isTab = false;

  void toggle(bool isPortrait, bool isTab) {
    this.isTab = isTab;
    this.isPortrait = isPortrait;

    print(this.isTab.toString()+ "  " +this.isPortrait.toString());

    notifyListeners();
  }

}