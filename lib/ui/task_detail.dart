import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friday_v/model/task.dart';
import 'package:friday_v/service/task_service.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/utils/svg.dart';
import 'package:friday_v/utils/utils.dart';
import 'package:friday_v/widgets/atoms.dart';
//import 'package:html_editor_enhanced/html_editor.dart';

class TaskDetail extends StatefulWidget {
  final TaskModel taskModel;

  const TaskDetail({Key? key, required this.taskModel}) : super(key: key);

  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
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

  //HtmlEditorController controller = HtmlEditorController();

  // String data = widget.taskModel.status;
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

  @override
  Widget build(BuildContext context) {
    // importance = widget.taskModel.importance;
    // stat = widget.taskModel.status;

    // print('importance: '+importance+'    stat: '+stat);

    return Scaffold(
      appBar: TopBar(
        title: "Todo Details",
        appBar: AppBar(),
        widgets: [
          // SvgView(color: secondaryLite, size: 24, icon: SvgIcon.overflow),
          // spacer(16.0)
        ],
        leading: true,
      ),
      body: SafeArea(
        child: Container(
          // color: Colors.red,
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        importance = importance == "high" ? "normal" : "high";
                      });
                      await TodoService().update(
                          'importance', importance, task.odataEtag, task.id);
                    },
                    child: SvgPicture.asset(
                      importance == 'high'
                          ? SvgIcon.star_filled
                          : SvgIcon.star_outline,
                      height: 24,
                      width: 24,
                      matchTextDirection: true,
                    ),
                  ),
                  spacer(16.0),
                  Text(Utils().String_toDTA(task.createdDateTime),
                      style: body2.copyWith(
                          color: menuDisabled, fontWeight: FontWeight.w500)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        stat =
                            stat == "notStarted" ? "completed" : "notStarted";
                      });
                      await TodoService()
                          .update('status', stat, task.odataEtag, task.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: status(stat) == 'Completed'
                              ? green.withOpacity(0.1)
                              : primaryDark.withOpacity(0.1)),
                      child: Text(
                        status(stat),
                        style: body2.copyWith(
                            color: status(stat) == 'Completed'
                                ? green
                                : primaryDark,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              spacer(16),
              Text(task.title.trim(),
                  style: title.copyWith(
                      color: secondaryDark, fontWeight: FontWeight.w800)),
              const Divider(),
              Visibility(
                visible:
                    task.body!.content.toString().trim() == '' ? false : true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      task.body!.content.toString().trim(),
                      style: body1.copyWith(
                          color: menuDisabled, fontWeight: FontWeight.w500),
                    ),
                    const Divider(),
                  ],
                ),
              ),
              Wrap(
                children: [
                  Visibility(
                    visible:
                        task.recurrence!.pattern!.type == "" ? false : true,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 24.0, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Repeat", style: body2.copyWith(color: subTextColor,),),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgView(
                                color: primaryColor,
                                icon: SvgIcon.redo,
                                size: 16,
                              ),
                              spacer(8.0),
                              Text(
                                  task.recurrence!.pattern!.type
                                      .toString()
                                      .capitalizeFirstOfEach,
                                  style: body1.copyWith(
                                      color: black,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        task.reminderdatetime!.datetime == "" ? false : true,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 24.0, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Reminder", style: body2.copyWith(color: subTextColor,),),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgView(
                                color: primaryColor,
                                icon: SvgIcon.clock,
                                size: 16,
                              ),
                              spacer(8.0),
                              Text(
                                  Utils().String_toDTA(task
                                      .reminderdatetime!.datetime
                                      .toString()),
                                  style: body1.copyWith(
                                      color: black,
                                      fontWeight: FontWeight.w500)),
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
                          Text("Due on", style: body2.copyWith(color: subTextColor,),),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgView(
                                color: primaryColor,
                                icon: SvgIcon.calendar,
                                size: 16,
                              ),
                              spacer(8.0),
                              Text(
                                  Utils().String_toDTA(
                                      task.duedatetime!.datetime.toString()),
                                  style: body1.copyWith(
                                      color: black,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Space(
                size: 8,
              ),
              Text("Notes", style: body2.copyWith(fontWeight: FontWeight.w500),),
              TextField(
                onChanged: (s) => body = s,
                controller: TextEditingController()
                  ..text = task.body!.content ?? '',
                style: body1.copyWith(color: secondaryDark),
                maxLines: 4,
                decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    fillColor: white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: primaryLite.withOpacity(0.8), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: borderColor, width: 2.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 8.0),
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
                  // SvgView(
                  //   color: primaryColor,
                  //   icon: SvgIcon.file,
                  //   size: 18,
                  // ),
                  // Space(size: 24,),
                  // SvgView(
                  //   color: primaryColor,
                  //   icon: SvgIcon.mic,
                  //   size: 24,
                  // ),

                  Spacer(),

                  InkResponse(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      await TodoService()
                          .updateBody(body, task.odataEtag, task.id);
                    },
                    // splashColor: primaryColor,
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
/*
controller.getText().then((value) {
                     print(value);
                   });
* */

//
// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:friday_v/auth/sso.dart';
// import 'package:friday_v/model/user.dart';
// import 'package:friday_v/service/config.dart';
// import 'package:friday_v/utils/constants.dart';
// import 'package:friday_v/utils/shared_pref.dart';
// import 'package:http/http.dart' as http;
//
// class UserService {
//   SharedPref shared = SharedPref();
//
//   Future<UserModel> getPeople() async {
//     UserModel result = UserModel();
//     // try {
//     var token = await getToken();
//     print(token);
//     final response = await http.get( //Todo: GET
//       Config.user_profile,
//       headers: {
//         "Content-Type": "application/json",
//         'Authorization': 'Bearer $token',
//       },
//     );
//     print(response.body);
//     print(result.jobTitle);
//     print(result.displayName);
//
//     switch(response.statusCode)
//     {
//       case OK:
//         final item = json.decode(response.body);
//         print(item);
//         result = UserModel.fromJson(item);
//         result.odataContext = token;
//         break;
//       case UNAUTHORIZED:
//         Auth().refreshTokenResponse();
//         getPeople();
//         break;
//     }
//     //  }
//     // catch (e) {
//     //   log(e.toString());
//     // }
//     return result;
//   }
//
//   Future<String> getToken() async {
//     User user = User.fromJson(await shared.read("user"));
//     return user.AccessToken.toString();
//   }
//
//   Future<String> getID() async {
//     UserModel user = UserModel.fromJson(await shared.read("usermodel"));
//     return user.id.toString();
//   }
//
//   Future<UserModel> getPeopleByID(userId) async {
//     UserModel result = UserModel();
//     try {
//       var token = await getToken();
//       final response = await http.get( //Todo: GET
//         Uri.parse("https://graph.microsoft.com/v1.0/users/$userId"),
//         headers: {
//           "Content-Type": "application/json",
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       switch(response.statusCode)
//       {
//         case OK:
//           final item = json.decode(response.body);
//           result = UserModel.fromJson(item);
//           result.odataContext = token;
//           break;
//         case UNAUTHORIZED:
//           Auth().refreshTokenResponse();
//           getPeopleByID(userId);
//           break;
//       }
//     } catch (e) {
//       log(e.toString());
//     }
//     return result;
//
//   }
// }
// /*
//   Future<UserModel> getPeople() async {
//     UserModel result = UserModel();
//     try {
//       var token = await getToken();
//       final response = await http.get(
//         Config.user_profile,
//             headers: {
//               "Content-Type": "image/jpeg",
//               'Authorization': 'Bearer $token',
//             },
//       );
//       if (response.statusCode == OK) {
//         final item = json.decode(response.body);
//         result = UserModel.fromJson(item);
//         result.odataContext = token;
//       } else {
//       }
//     } catch (e) {
//       log(e.toString());
//     }
//     return result;
//   }
// * */
