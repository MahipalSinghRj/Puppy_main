import 'package:flutter/material.dart';
import 'package:friday_v/utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../LoginScreen/login_screen.dart';
import '../HomeScreen/home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      user();
    });
  }

  void user() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool logged = (prefs.getBool('login') ?? false);
    if (logged == true) {
      final currentContext = context;
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          currentContext,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      });
    } else {
      final currentContext = context;
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          currentContext,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Hero(
        tag: "puppy_tag",
        child: Image.asset(
          "assets/images/logo.png",
          scale: SizeConfig.imageSizeMultiplier! - 2.5,
        ),
      ),
    ));
  }
}
