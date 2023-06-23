import 'package:flutter/material.dart';
import 'package:friday_v/Debug/printme.dart';
import 'package:friday_v/provider/orientation_provider.dart';

class SizeConfig {
  static late double _screenWidth;
  static late double _screenHeight;

  static double? screenWidth_;
  static double? screenHeight_;

  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  static double? textMultiplier;
  static double? imageSizeMultiplier;
  static late double heightMultiplier;
  static late bool isPortrait;
  static late bool isTab;

  static OrientationProvider orientationProvider = OrientationProvider();

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenHeight = constraints.maxHeight;
      _screenWidth = constraints.maxWidth;

      screenHeight_ = constraints.maxHeight;
      screenWidth_ = constraints.maxWidth;

      print("Portrait");
      isPortrait = true;

      //isTab finder
      if (_screenWidth > 600) {
        isTab = true;
      } else {
        isTab = false;
      }
      orientationProvider.toggle(isPortrait, isTab);
    } else {
      _screenHeight = constraints.maxWidth;
      _screenWidth = constraints.maxHeight;

      screenHeight_ = constraints.maxHeight;
      screenWidth_ = constraints.maxWidth;

      print("Landscape");
      isPortrait = false;

      // isTab finder
      if (_screenWidth > 600) {
        isTab = true;
      } else {
        isTab = false;
      }

      orientationProvider.toggle(isPortrait, isTab);
    }

    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;

    textMultiplier = _blockSizeVertical;
    imageSizeMultiplier = _blockSizeHorizontal;
    heightMultiplier = _blockSizeVertical;

    printAchievement("TextMultiplier...$textMultiplier");
    printAchievement("ImageSizeMultiplier...$imageSizeMultiplier");
    printAchievement("HeightMultiplier...$heightMultiplier");
    printAchievement("SceenHeight...$_screenHeight");
    printAchievement("SceenWidth...$_screenWidth");
  }
}
