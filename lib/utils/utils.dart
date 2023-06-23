import 'package:intl/intl.dart';

class Utils {
  String DT_toString(DateTime dateTime) {
    var outputFormat = DateFormat('dd MMM yyyy');
    String outputDate = outputFormat.format(dateTime).toString();
    return outputDate;
  }

  String DTA_toString(DateTime dateTime) {
    var outputFormat = DateFormat('dd MMM yyyy H:m:s');
    String outputDate = outputFormat.format(dateTime).toString();
    return outputDate;
  }

  String String_toDT(String? dateTime) {
    if (dateTime == '' || dateTime == null) {
      return '';
    } else {
      DateTime dateTime_ = DateTime.parse(dateTime);
      var outputFormat = DateFormat('dd MMM yyyy');
      String outputDate = outputFormat.format(dateTime_).toString();
      return outputDate;
    }
  }

  String String_toDTA(String? dateTime) {
    if (dateTime == '' || dateTime == null) {
      return '';
    } else {
      DateTime dateTime_ = DateTime.parse(dateTime);
      var outputFormat = DateFormat('dd MMM yyyy hh:mm a');
      String outputDate = outputFormat.format(dateTime_).toString();
      return outputDate;
    }
  }
}

extension CapExtension on String {
  String get inCaps => length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';

  String get allInCaps => toUpperCase();

  String get capitalizeFirstOfEach => replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.inCaps).join(" ");
}
