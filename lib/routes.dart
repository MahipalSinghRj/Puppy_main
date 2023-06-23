import 'package:flutter/material.dart';
import 'package:friday_v/utils/transition.dart';
import 'Views/JobsScreen/JobDetailScreens/local_details.dart';
import 'Views/JobsScreen/new_job.dart';
import 'Views/LoginScreen/login_screen.dart';
import 'Views/SplashScreen/splash_screen.dart';
import 'Views/task_detail.dart';

class Routes {
  //Route name constants
  static const String initialRoute = '/';
  static const String loginPage = 'login';
  static const String detailPage = 'detail';
  static const String newJobPage = 'newjob';
  static const String jobDetailPage = 'jobdetail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map args = {};
    if (settings.arguments != null) {
      args = settings.arguments as Map<dynamic, dynamic>;
    }

    switch (settings.name) {
      case initialRoute:
        return FadeRoute(page: const Splash());
      case loginPage:
        return FadeRoute(page: const Login());
      case detailPage:
        return FadeRoute(page: TaskDetail(taskModel: args['arg']));
      case newJobPage:
        return FadeRoute(page: const NewJob());
      case jobDetailPage:
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
