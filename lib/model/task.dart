// To parse this JSON data, do
//
//     final taskListModel = taskListModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<TaskListModel> taskListModelFromJson(String str) => List<TaskListModel>.from(json.decode(str).map((x) => TaskListModel.fromJson(x)));

String taskListModelToJson(List<TaskListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaskListModel {
  TaskListModel({
    this.displayName = '',
    this.isOwner = false,
    this.isShared = false,
    this.wellknownListName = '',
    this.id = '',
  });

  String displayName;
  bool isOwner;
  bool isShared;
  String wellknownListName;
  String id;

  factory TaskListModel.fromJson(Map<String, dynamic> json) => TaskListModel(
    displayName: json["displayName"],
    isOwner: json["isOwner"],
    isShared: json["isShared"],
    wellknownListName: json["wellknownListName"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "displayName": displayName,
    "isOwner": isOwner,
    "isShared": isShared,
    "wellknownListName": wellknownListName,
    "id": id,
  };
}

//////////////////////////////////////////////////////////////////////////


List<TaskModel> taskModelFromJson(String str) => List<TaskModel>.from(json.decode(str).map((x) => TaskModel.fromJson(x)));

class TaskModel {
  TaskModel({
    this.odataEtag = "",
    this.importance = "",
    this.isReminderOn = false,
    this.status = "",
    this.title = "",
    this.createdDateTime = "",
    this.lastModifiedDateTime = "",
    this.id = "",
    this.body,
    this.duedatetime,
    this.recurrence,
    this.reminderdatetime,
  });

  String odataEtag;
  String importance;
  bool isReminderOn;
  String status;
  String title;
  String createdDateTime;
  String lastModifiedDateTime;
  String id;
  Body? body;
  DueDatetime? duedatetime;
  Recurrence? recurrence;
  ReminderDatetime? reminderdatetime;

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    odataEtag: json["@odata.etag"],
    importance: json["importance"],
    isReminderOn: json["isReminderOn"],
    status: json["status"],
    title: json["title"],
    createdDateTime: json["createdDateTime"],
    lastModifiedDateTime: json["lastModifiedDateTime"],
    id: json["id"],
    body: Body.fromJson(json["body"]),
    duedatetime: DueDatetime.fromJson(json["dueDateTime"]),
    recurrence: Recurrence.fromJson(json["recurrence"]),
    reminderdatetime: ReminderDatetime.fromJson(json["reminderDateTime"]),
  );
}

class Body {
  Body({
    this.content,
    this.contentType,
  });

  String? content;
  String? contentType;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    content: json["content"],
    contentType: json["contentType"],
  );
}

class DueDatetime {
  DueDatetime({
    this.datetime,
    this.timezone,
  });

  String? datetime;
  String? timezone;

  factory DueDatetime.fromJson(Map<String, dynamic>? json) => DueDatetime(
    datetime: json == null ? "" : json["dateTime"],
    timezone: json == null ? "" : json["timeZone"],
  );
}

class ReminderDatetime {
  ReminderDatetime({
    this.datetime,
    this.timezone,
  });

  String? datetime;
  String? timezone;

  factory ReminderDatetime.fromJson(Map<String, dynamic>? json) => ReminderDatetime(
    datetime: json == null ? "" : json["dateTime"],
    timezone: json == null ? "" : json["timeZone"],
  );
}


class Recurrence {
  Recurrence({
    this.pattern,
    this.range,
  });

  Pattern? pattern;
  Range? range;

  factory Recurrence.fromJson(Map<String, dynamic>? json) => Recurrence(
    pattern: Pattern.fromJson(json == null ? null : json["pattern"]),
    range: Range.fromJson(json == null ? null : json["range"]),
  );
}

class Pattern {
  Pattern({
    this.type,
    this.interval,
    this.month,
    this.dayOfMonth,
    this.daysOfWeek,
    this.firstDayOfWeek,
    this.index,
  });

  String? type;
  int? interval;
  int? month;
  int? dayOfMonth;
  List<String>? daysOfWeek;
  String? firstDayOfWeek;
  String? index;

  factory Pattern.fromJson(Map<String, dynamic>? json) => Pattern(
    type: json == null ? "": json["type"],
    interval: json == null ? 0: json["interval"],
    month: json == null ? 0: json["month"],
    dayOfMonth: json == null ? 0: json["dayOfMonth"],
    daysOfWeek: List<String>.from(json == null ? [] : json["daysOfWeek"].map((x) => x)),
    firstDayOfWeek: json == null ? "" : json["firstDayOfWeek"],
    index: json == null ? "" : json["index"],
  );
}

class Range {
  Range({
    this.type,
    this.startdate,
    this.enddate,
    this.recurrencetimezone,
    this.numberofoccurrences,
  });

  String? type;
  String? startdate;
  String? enddate;
  String? recurrencetimezone;
  int? numberofoccurrences;

  factory Range.fromJson(Map<String, dynamic>? json) => Range(
    type: json == null ? "": json["type"],
    startdate: json == null ? "" : json["startDate"],
    enddate: json == null ? "" : json["endDate"],
    recurrencetimezone: json == null ? "" : json["recurrenceTimeZone"],
    numberofoccurrences: json == null ? 0 : json["numberOfOccurrences"],
  );
}