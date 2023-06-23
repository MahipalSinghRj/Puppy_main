import 'package:device_preview/device_preview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:friday_v/auth/sso.dart';
import 'package:friday_v/provider/bottom_provider.dart';
import 'package:friday_v/provider/orientation_provider.dart';
import 'package:friday_v/provider/ui/rest.dart';
import 'package:friday_v/provider/ui/todo.dart';
import 'package:friday_v/routes.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/utils/size_config.dart';
import 'package:provider/provider.dart';
import 'Debug/printme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Dio dio = Dio();

  await dio.get('https://login.microsoftonline.com/59450111-f685-4ebf-b9bc-d5252cd42c5f/oauth2/v2.0/authorize');
  dio.interceptors.add(InterceptorsWrapper(onError: (error, errorInterceptorHandler) {
    if (error.response?.statusCode == 403 || error.response?.statusCode == 401) {
      Auth().refreshTokenResponse();
    }
  }, onRequest: (request, requestInterceptorHandler) {
    printMe("Request method & Request path is : ${request.method} | ${request.path}");
  }, onResponse: (responses, responseInterceptorHandler) {
    printMe('Status code & Response data is : ${responses.statusCode} ${responses.statusCode} ${responses.data}');
  })); //  callbackDispatcher();

  runApp(const PuppyApp());
}

class PuppyApp extends StatelessWidget {
  const PuppyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        Auth().refreshTokenResponse();
        return OrientationBuilder(builder: (context, orientation) {
          SizeConfig().init(constraint, orientation);
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<BottomProvider>(
                create: (_) => BottomProvider(),
              ),
              ChangeNotifierProvider<OrientationProvider>(
                create: (_) => SizeConfig.orientationProvider,
              ),
              ChangeNotifierProvider<UserProvider>(
                create: (_) => UserProvider(),
              ),
              ChangeNotifierProvider<TodoProvider>(
                create: (_) => TodoProvider(),
              ),
            ],
            child: MaterialApp(
              builder: DevicePreview.appBuilder,
              debugShowCheckedModeBanner: false,
              title: 'Friday',
              onGenerateRoute: Routes.generateRoute,
              theme: ThemeData(
                primaryColor: Colors.white,
                primarySwatch: Colors.deepOrange,
                appBarTheme: const AppBarTheme(iconTheme: IconThemeData(color: Colors.black)),
                fontFamily: "RedHatDisplay",
                canvasColor: scaffoldBackground,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
            ),
          );
        });
      },
    );
  }
}
