import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_geofence/geofence.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:friday_v/Navigation_drawer/drawer.dart';
import '../Debug/printme.dart';

class geofence extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<geofence> {
  final String _platformVersion = 'Unknown';

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = const AndroidInitializationSettings('logo');
    var initializationSettingsIOS = const IOSInitializationSettings(onDidReceiveLocalNotification: null);
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: null);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;
    Geofence.initialize();
    Geofence.startListening(GeolocationEvent.entry, (entry) {
      scheduleNotification("Entry of a georegion", "Welcome to: ${entry.id}");
    });

    Geofence.startListening(GeolocationEvent.exit, (entry) {
      scheduleNotification("Exit of a georegion", "Byebye to: ${entry.id}");
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('geofencce'),
        ),
        drawer: const NavDrawer(),
        body: ListView(
          children: <Widget>[
            Text('Running on: $_platformVersion\n'),
            ElevatedButton(
              child: const Text("Add region"),
              onPressed: () {
                Geolocation location =
                    const Geolocation(latitude: 11.6289461, longitude: 78.1238373, radius: 100.0, id: "location 1");
                Geofence.addGeolocation(location, GeolocationEvent.entry).then((onValue) {
                  printMe("great success");
                  scheduleNotification("Georegion added", "Your geofence has been added!");
                }).catchError((onError) {
                  printMe("great failure");
                });
              },
            ),
            ElevatedButton(
              child: const Text("Add neighbour region"),
              onPressed: () {
                Geolocation location = const Geolocation(
                    latitude: 11.628371337571693, longitude: 78.1254818290472, radius: 100.0, id: "location 2");
                Geofence.addGeolocation(location, GeolocationEvent.entry).then((onValue) {
                  printMe("great success");
                  scheduleNotification("Georegion added", "Your geofence has been added!");
                }).catchError((onError) {
                  printMe("great failure");
                });
              },
            ),
            ElevatedButton(
              child: const Text("Request Permissions"),
              onPressed: () {
                Geofence.startListening(GeolocationEvent.entry, (entry) {
                  printMe("entry");
                });

                Geofence.startListening(GeolocationEvent.exit, (entry) {
                  printMe("exit");
                  scheduleNotification("Exit of a home", "Byebye to: ${entry.id}");
                });
              },
            ),
            ElevatedButton(
                child: const Text("Stop listening to background updates"),
                onPressed: () {
                  Geofence.stopListeningForLocationChanges();
                }),
          ],
        ),
      ),
    );
  }

  void scheduleNotification(String title, String subtitle) {
    printMe("scheduling one with $title and $subtitle");
    var rng = Random();
    Future.delayed(const Duration(seconds: 5)).then((result) async {
      var androidPlatformChannelSpecifics = const AndroidNotificationDetails('your channel id', 'your channel name',
          importance: Importance.high, priority: Priority.high, ticker: 'ticker');
      var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
      var platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(rng.nextInt(100000), title, subtitle, platformChannelSpecifics,
          payload: 'item x');
    });
  }
}
