import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friday_v/auth/sso.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/utils/size_config.dart';
import 'package:friday_v/utils/svg.dart';
import 'package:friday_v/widgets/sizebox_spacer.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: "puppy_tag",
                      child: Image.asset("assets/images/logo.png", scale: SizeConfig.imageSizeMultiplier! - 2.9),
                    ),
                    const Text(
                      "PUPPY",
                      style: TextStyle(color: white, fontSize: 48, fontWeight: FontWeight.w800),
                    ),
                    const Space(size: 24),
                    Text("Your work life is ready to be organised now!",
                        style: body1.copyWith(color: white, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Auth().signIn(true, context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 56.0),
                        decoration: BoxDecoration(
                            color: secondaryDark,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(width: 2, color: primaryDark)),
                        child: Row(
                          children: [
                            SvgPicture.asset(SvgIcon.ms, height: 25, width: 25, matchTextDirection: true),
                            const Space(size: 16.0),
                            Text("Sign in with Microsoft",
                                style: body1.copyWith(color: white, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
