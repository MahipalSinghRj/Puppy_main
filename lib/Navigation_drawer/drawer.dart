import 'package:flutter/material.dart';
import 'package:friday_v/pdf/barcode.dart';
import 'package:friday_v/pdf/pdf.dart';
import 'package:friday_v/provider/ui/rest.dart';
import 'package:friday_v/service/customer_onsite.dart';
import 'package:friday_v/service/easy_geofencing.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/utils/shared_pref.dart';
import 'package:friday_v/widgets/sizebox_spacer.dart';
import 'package:provider/provider.dart';
import '../Views/HomeScreen/home.dart';
import '../routes.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key, title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context);
    final token = userData.post.odataContext;

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(56),
                  child: FadeInImage(
                      image: NetworkImage(
                        "https://graph.microsoft.com/v1.0/me/photo/\$value",
                        headers: {"Authorization": "Bearer $token"},
                      ),
                      imageErrorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Image.asset('assets/images/404.png');
                      },
                      placeholder: const AssetImage("assets/images/404.png"),
                      height: 56,
                      width: 56,
                      fit: BoxFit.fitHeight),
                ),
                spacer(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData.post.displayName,
                        style: body1.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      spacer(8),
                      Text(userData.post.jobTitle)
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text("Home"),
            leading: IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            title: const Text("Customer on site"),
            leading: IconButton(icon: const Icon(Icons.account_circle), onPressed: () {}),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CustomerOnSite()));
            },
          ),
          ListTile(
            title: const Text("Scanner"),
            leading: IconButton(icon: const Icon(Icons.scanner), onPressed: () {}),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const scanner(text: '')));
            },
          ),
          ListTile(
            title: const Text("Pdf"),
            leading: IconButton(icon: const Icon(Icons.picture_as_pdf_outlined), onPressed: () {}),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const CreatePdfWidget()));
            },
          ),
          ListTile(
            title: const Text("geofence"),
            leading: IconButton(icon: const Icon(Icons.maps_ugc_rounded), onPressed: () {}),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => geofence()));
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            title: const Text("Logout"),
            leading: IconButton(icon: const Icon(Icons.logout), onPressed: () {}),
            onTap: () {
              SharedPref().remove('login');
              Navigator.pushReplacementNamed(context, Routes.loginPage);
            },
          )
        ],
      ),
    );
  }
}
