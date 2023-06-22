import 'package:flutter/material.dart';
import 'package:friday_v/ui/job_detail.dart';
import 'package:friday_v/ui/new_job.dart';
import 'package:friday_v/ui/splash.dart';
import 'package:friday_v/ui/task_detail.dart';
import 'package:friday_v/utils/transition.dart';

class Routes {
  //Route name constants
  static const String Root = '/';
  static const String Login_ = 'login';
  static const String Detail_ = 'detail';
  static const String NewJob_ = 'newjob';
  static const String JobDetail_ = 'jobdetail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map args = {};
    if (settings.arguments != null) {
      args = settings.arguments as Map<dynamic, dynamic>;
    }

    switch (settings.name) {
      case Root:
        return FadeRoute(page: Splash());
      case Login_:
        return FadeRoute(page: Login());
      case Detail_:
        return FadeRoute(
            page: TaskDetail(
          taskModel: args['arg'],
        ));
      case NewJob_:
        return FadeRoute(page: NewMeeting());
      case JobDetail_:
        return FadeRoute(page: LocalDetail(sessionData: args['localDetail']));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return const Scaffold(
        body: Center(
          child: Text("Error Route"),
        ),
      );
    });
  }
}
