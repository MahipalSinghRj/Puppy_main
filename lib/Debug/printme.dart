import 'package:flutter/foundation.dart';

void printMe(String text) {
  if (kDebugMode) {
    print('\x1B[32m$text\x1B[0m');
  }
}

void printResponse(String text) {
  if (kDebugMode) {
    print(text);
  }
}

void printWarning(text) {
  if (kDebugMode) {
    print('\x1B[33m$text\x1B[0m');
  }
}

void printError(String text) {
  if (kDebugMode) {
    print('\x1B[32m$text\x1B[0m');
  }
}

void printAchievement(String text) {
  if (kDebugMode) {
    print('\x1B[35m$text\x1B[0m');
  }
}

// Black:   \x1B[30m
// Red:     \x1B[31m
// Green:   \x1B[32m
// Yellow:  \x1B[33m
// Blue:    \x1B[34m
// Magenta: \x1B[35m
// Cyan:    \x1B[36m
// White:   \x1B[37m
// Reset:   \x1B[0m
