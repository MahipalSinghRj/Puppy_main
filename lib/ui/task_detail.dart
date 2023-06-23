import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friday_v/model/task.dart';
import 'package:friday_v/service/task_service.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/utils/svg.dart';
import 'package:friday_v/utils/utils.dart';
import 'package:friday_v/widgets/sizebox_spacer.dart';

import '../widgets/svg_view.dart';
import '../widgets/top_bar.dart';

class TaskDetail extends StatefulWidget {
  final TaskModel taskModel;

  const TaskDetail({Key? key, required this.taskModel}) : super(key: key);

  @override
  TaskDetailState createState() => TaskDetailState();
}

class TaskDetailState extends State<TaskDetail> {
  String stat = "notStarted";
  String importance = "normal";
  String body = '';
  late TaskModel task;

  @override
  void initState() {
    super.initState();
    task = widget.taskModel;
    stat = task.status;
    importance = task.importance;
  }

  String status(status) {
    String stat = '';
    switch (status) {
      case 'notStarted':
        stat = 'Pending';
        break;
      case 'completed':
        stat = 'Completed';
        break;
      default:
        stat = '';
        break;
    }
    return stat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: "Todo Details",
        appBar: AppBar(),
        widgets: const [],
        leading: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        importance = importance == "high" ? "normal" : "high";
                      });
                      await TodoService().update('importance', importance, task.odataEtag, task.id);
                    },
                    child: SvgPicture.asset(
                      importance == 'high' ? SvgIcon.star_filled : SvgIcon.star_outline,
                      height: 24,
                      width: 24,
                      matchTextDirection: true,
                    ),
                  ),
                  spacer(16.0),
                  Text(Utils().String_toDTA(task.createdDateTime),
                      style: body2.copyWith(color: menuDisabled, fontWeight: FontWeight.w500)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        stat = stat == "notStarted" ? "completed" : "notStarted";
                      });
                      await TodoService().update('status', stat, task.odataEtag, task.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: status(stat) == 'Completed' ? green.withOpacity(0.1) : primaryDark.withOpacity(0.1)),
                      child: Text(
                        status(stat),
                        style: body2.copyWith(
                            color: status(stat) == 'Completed' ? green : primaryDark, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              spacer(16),
              Text(task.title.trim(), style: title.copyWith(color: secondaryDark, fontWeight: FontWeight.w800)),
              const Divider(),
              Visibility(
                visible: task.body!.content.toString().trim() == '' ? false : true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      task.body!.content.toString().trim(),
                      style: body1.copyWith(color: menuDisabled, fontWeight: FontWeight.w500),
                    ),
                    const Divider(),
                  ],
                ),
              ),
              Wrap(
                children: [
                  Visibility(
                    visible: task.recurrence!.pattern!.type == "" ? false : true,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 24.0, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Repeat",
                            style: body2.copyWith(
                              color: subTextColor,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgView(
                                color: primaryColor,
                                icon: SvgIcon.redo,
                                size: 16,
                              ),
                              spacer(8.0),
                              Text(task.recurrence!.pattern!.type.toString().capitalizeFirstOfEach,
                                  style: body1.copyWith(color: black, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: task.reminderdatetime!.datetime == "" ? false : true,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 24.0, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Reminder",
                            style: body2.copyWith(
                              color: subTextColor,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgView(
                                color: primaryColor,
                                icon: SvgIcon.clock,
                                size: 16,
                              ),
                              spacer(8.0),
                              Text(Utils().String_toDTA(task.reminderdatetime!.datetime.toString()),
                                  style: body1.copyWith(color: black, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: task.duedatetime!.datetime == "" ? false : true,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 24.0, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Due on",
                            style: body2.copyWith(color: subTextColor),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgView(
                                color: primaryColor,
                                icon: SvgIcon.calendar,
                                size: 16,
                              ),
                              spacer(8.0),
                              Text(Utils().String_toDTA(task.duedatetime!.datetime.toString()),
                                  style: body1.copyWith(color: black, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Space(size: 8),
              Text("Notes", style: body2.copyWith(fontWeight: FontWeight.w500)),
              TextField(
                onChanged: (s) => body = s,
                controller: TextEditingController()..text = task.body!.content ?? '',
                style: body1.copyWith(color: secondaryDark),
                maxLines: 4,
                decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    fillColor: white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: primaryLite.withOpacity(0.8), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: borderColor, width: 2.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8.0),
                    hintText: "Site Representative Name",
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
              Row(
                children: [
                  InkResponse(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    highlightColor: primaryColor.withOpacity(0.4),
                    child: SvgView(
                      padding: 16,
                      color: primaryColor,
                      icon: SvgIcon.file,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  InkResponse(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      await TodoService().updateBody(body, task.odataEtag, task.id);
                    },
                    highlightColor: primaryColor.withOpacity(0.4),
                    child: SvgView(
                      padding: 16,
                      color: primaryColor,
                      icon: SvgIcon.send_solid,
                      size: 24,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
