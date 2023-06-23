import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:friday_v/model/user.dart';
import 'package:friday_v/ui/HomeScreen/home.dart';
import 'package:friday_v/utils/status_code_constants.dart';
import 'package:friday_v/utils/shared_pref.dart';
import 'package:http/http.dart' as http;
import '../Debug/printme.dart';

class Auth {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  String? _refreshToken;
  String? _accessToken;
  Dio dio = Dio();

  final String _clientId = 'a7b468bb-77ba-4bb0-8e0a-22f13751daf1';

  final String _redirectUrl = 'msauth://com.smart.puppy/stwwmz2PdtGvlZyxY7Wrb0wlPdo%3D';

  final List<String> _scopes = <String>['openid', 'profile', 'email', 'offline_access'];

  final AuthorizationServiceConfiguration _serviceConfiguration = const AuthorizationServiceConfiguration(
      authorizationEndpoint:
          'https://login.microsoftonline.com/59450111-f685-4ebf-b9bc-d5252cd42c5f/oauth2/v2.0/authorize',
      tokenEndpoint: 'https://login.microsoftonline.com/59450111-f685-4ebf-b9bc-d5252cd42c5f/oauth2/v2.0/token');

  Future<void> signIn(bool firstTime, BuildContext context) async {
    try {
      final AuthorizationTokenResponse? result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(_clientId, _redirectUrl,
            serviceConfiguration: _serviceConfiguration, scopes: _scopes, promptValues: ['login']),
      );

      if (result != null) {
        final currentContext = context;
        Future.delayed(Duration.zero, () {
          _processAuthTokenResponse(result, firstTime, currentContext);
        });
      }
    } catch (err) {
      printError("Sign In Error is : ${err.toString()}");
    }
  }

  Future<void> _processAuthTokenResponse(
      AuthorizationTokenResponse response, bool firstTime, BuildContext context) async {
    _accessToken = response.accessToken!;
    _refreshToken = response.refreshToken!;

    User user = User(AccessToken: _accessToken!, IDToken: response.idToken!, RefreshToken: _refreshToken!);

    SharedPref sharedPref = SharedPref();
    sharedPref.save("user", user);
    sharedPref.savebool('login', true);

    await dio.get('https://login.microsoftonline.com/59450111-f685-4ebf-b9bc-d5252cd42c5f/oauth2/v2.0/authorize');

    dio.interceptors.add(InterceptorsWrapper(onError: (error, errorInterceptorHandler) {
      if (error.response?.statusCode == 403 || error.response?.statusCode == 401) {
        printError("Error status code is : ${error.response?.statusCode}");
        Auth().refreshTokenResponse();
      }
    }, onRequest: (request, requestInterceptorHandler) {
      printMe("Request method and Request path is : ${request.method} | ${request.path}");
    }, onResponse: (responses, responseInterceptorHandler) {
      printMe('Response status code and Data is : ${responses.statusCode} ${responses.statusCode} ${responses.data}');
    }));

    final currentContext = context;
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(
        currentContext,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
    printMe("Refresh token is : $_refreshToken");
  }

  void refreshTokenResponse() async {
    Uri refreshUrl =
        Uri.parse('https://login.microsoftonline.com/59450111-f685-4ebf-b9bc-d5252cd42c5f/oauth2/v2.0/token');

    final Map<String, dynamic> data = <String, dynamic>{};
    SharedPref sharedPref = SharedPref();

    sharedPref.readRefresh().then((value) async {
      data['client_id'] = 'a7b468bb-77ba-4bb0-8e0a-22f13751daf1';
      data['refresh_token'] = value;
      data['redirect_uri'] = 'msauth://com.smart.puppy/stwwmz2PdtGvlZyxY7Wrb0wlPdo%3D';
      data['grant_type'] = 'refresh_token';

      var response = await http.post(refreshUrl, body: data);

      switch (response.statusCode) {
        case UNAUTHORIZED:
          printError("Unauthorized");
          break;
        case OK:
          RefreshModel refreshModel = RefreshModel.fromJson(json.decode(response.body.toString()));
          User user = User(
              AccessToken: refreshModel.accessToken,
              IDToken: refreshModel.idToken,
              RefreshToken: refreshModel.refreshToken);

          SharedPref sharedPref = SharedPref();
          sharedPref.save("user", user);
          sharedPref.save("refreshed", refreshModel);

          break;
        default:
          printError("Error");
      }
    });
  }
}
