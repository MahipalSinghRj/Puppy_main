import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friday_v/Navigation_drawer/drawer.dart';
import 'package:friday_v/pdf/barcode.dart';
import 'package:friday_v/pdf/pdf.dart';
import 'package:friday_v/pdf/printer.dart';
import 'package:friday_v/provider/ui/rest.dart';
import 'package:friday_v/service/customer_onsite.dart';
import 'package:friday_v/service/easy_geofencing.dart';
// import 'package:friday_v/service/geofence.dart';
import 'package:friday_v/service/remainter.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/utils/shared_pref.dart';
import 'package:friday_v/utils/svg.dart';
import 'package:friday_v/widgets/atoms.dart';
import 'package:provider/provider.dart';

import '../../routes.dart';
import 'home.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final user_data = Provider.of<UserProvider>(context);
    final token = user_data.post.odataContext;

    if (user_data.loading == false) {
      SharedPref().save("principal", user_data.post.mail);
      SharedPref().save("usermodel", user_data.post);
    }

    void handleClick(int value) {
      switch (value) {
        case 0:
          SharedPref().remove('login');
          Navigator.pushReplacementNamed(context, Routes.Login_);
          break;
          // case 1:
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => customer_onsite()),
          //   );
          //   break;
          // case 2:
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => CreatePdfWidget()),
          //   );
          //   break;
          // case 3:
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => geofence()),
          // );
          // break;
          // case 4:
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => Barcode()),
          //   );
          //   break;
          // case 5:
          break;
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: Center(child: Container()),
        drawer: const NavDrawer());

    //     widgets: [
    //       // SvgView(color: black, size: 22, icon: SvgIcon.search),
    //       // const Space(size: 22),
    //       // SvgView(color: black, icon: SvgIcon.notification),
    //       // const Space(size: 24),
    //       PopupMenuButton<int>(
    //         icon: SvgView(color: black, size: 24, icon: SvgIcon.overflow),
    //         onSelected: handleClick,
    //         itemBuilder: (context) => [
    //           const PopupMenuItem<int>(value: 0, child: Text('Logout')),
    //           // const PopupMenuItem<int>(value: 1, child: Text('Customer on site')),
    //           // const PopupMenuItem<int>(value: 2, child: Text('pdf')),
    //           // const PopupMenuItem<int>(value: 3, child: Text('geofence')),
    //           // const PopupMenuItem<int>(value: 4, child: Text('Barcode')),
    //
    //           // PopupMenuItem<int>(value: 1, child: Text('Settings')),
    //         ],
    //       ),
    //
    //       //C:\Program Files\Intel\WiFi\bin\;C:\Program Files\Common Files\Intel\WirelessCommon\;C:\Users\Lenovo\AppData\Local\Programs\Microsoft VS Code\bin;C:\Users\Lenovo\AppData\Local\GitHubDesktop\bin
    //
    //
    //       // itemBuilder: (BuildContext context) {
    //       //   return {'Logout', 'Settings'}.map((String choice) {
    //       //     return PopupMenuItem<String>(
    //       //       value: choice,
    //       //       child: Text(choice),
    //       //     );
    //       //   }).toList();
    //       // },
    //       // SvgView(color: black, size: 24, icon: SvgIcon.overflow),
    //       // const Space(size: 16)
    //     ],
    //
    //   ),
    //
    //   body: SafeArea(
    //     child: Column(
    //       children: [
    //         user_data.loading
    //             ? Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: const [
    //                   Padding(
    //                     padding: EdgeInsets.all(16.0),
    //                     child: CircularProgressIndicator(),
    //                   ),
    //                 ],
    //               )
    //             : Container(
    //                 padding: const EdgeInsets.all(16.0),
    //                 child: Row(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     ClipRRect(
    //                       borderRadius: BorderRadius.circular(56),
    //                       child: FadeInImage(
    //                         image: NetworkImage(
    //                           "https://graph.microsoft.com/v1.0/me/photo/\$value",
    //                           headers: {
    //                             "Authorization": "Bearer $token",
    //                           },
    //                         ),
    //                         imageErrorBuilder: (BuildContext context,
    //                             Object exception, StackTrace? stackTrace) {
    //                           return Image.asset('assets/images/404.png');
    //                         },
    //                         placeholder: AssetImage("assets/images/404.png"),
    //                         height: 56,
    //                         width: 56,
    //                         fit: BoxFit.fitHeight,
    //                       ),
    //                     ),
    //                     spacer(16),
    //                     Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Text(
    //                           user_data.post.displayName,
    //                           style: body1.copyWith(
    //                               fontSize: 20, fontWeight: FontWeight.w700),
    //                         ),
    //                         spacer(8),
    //                         Text(user_data.post.jobTitle),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //       ],
    //     ),
    //   ),
    // );
  }

  @override
  void initState() {
    final user = Provider.of<UserProvider>(context, listen: false);
    user.getUserData(context);
    super.initState();
  }
}
