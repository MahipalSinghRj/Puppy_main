import 'package:flutter/material.dart';
import 'package:friday_v/Navigation_drawer/drawer.dart';
import 'package:friday_v/provider/ui/rest.dart';
import 'package:friday_v/utils/shared_pref.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context);

    if (userData.loading == false) {
      SharedPref().save("principal", userData.post.mail);
      SharedPref().save("usermodel", userData.post);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: Center(child: Container()),
        drawer: const NavDrawer());
  }

  @override
  void initState() {
    final user = Provider.of<UserProvider>(context, listen: false);
    user.getUserData(context);
    super.initState();
  }
}
