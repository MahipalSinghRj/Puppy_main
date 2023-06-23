import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class remainter extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<remainter> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final myController = TextEditingController();
  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = const AndroidInitializationSettings('flutter_notification');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings, onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(payload) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return NewScreen(
        payload: payload,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: const Text('Flutter notification'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 250,
              child: TextField(
                controller: myController,
                decoration: const InputDecoration(
                  hintText: 'notification details',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: scheduleNotifications,
              child: const Text(
                'show schedule',
              ),
            ),
            ElevatedButton(onPressed: _showInboxNotification, child: const Text('Show InboxNotification')),
            ElevatedButton(onPressed: _showProgressNotification, child: const Text('show progressnotification')),
          ],
        ),
      ),
    );
  }

  Future<void> showNotificationMediaStyle() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'media channel id',
      'media channel name',
      color: Colors.red,
      enableLights: true,
      largeIcon: DrawableResourceAndroidBitmap("flutter_devs"),
      styleInformation: MediaStyleInformation(),
    );
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'notification title', 'notification body', platformChannelSpecifics);
  }

  Future<void> _showProgressNotification() async {
    const int maxProgress = 5;
    for (int i = 0; i <= maxProgress; i++) {
      await Future<void>.delayed(const Duration(seconds: 1), () async {
        final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
            'progress channel', 'progress channel',
            channelShowBadge: false, onlyAlertOnce: true, showProgress: true, maxProgress: maxProgress, progress: i);
        final NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0, 'progress notification title', 'progress notification body', platformChannelSpecifics,
            payload: 'item x');
      });
    }
  }

  Future<void> _showInboxNotification() async {
    final List<String> lines = <String>['line <b>1</b>', 'line <i>2</i>'];
    final InboxStyleInformation inboxStyleInformation = InboxStyleInformation(lines,
        htmlFormatLines: true,
        contentTitle: 'overridden <b>inbox</b> context title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('inbox channel id', 'inboxchannel name', styleInformation: inboxStyleInformation);
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'inbox title', 'inbox body', platformChannelSpecifics);
  }

  Future<void> showAlertNotification() async {
    var time = const Time(19, 15, 0);
    var androidChannel = const AndroidNotificationDetails('channelID', 'channelName',
        importance: Importance.defaultImportance, priority: Priority.defaultPriority, playSound: true);

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin
        .showDailyAtTime(2, 'notification title', 'message here', time, platformChannel, payload: 'new payload');
  }

  Future<void> showBigPictureNotification() async {
    var bigPictureStyleInformation = const BigPictureStyleInformation(DrawableResourceAndroidBitmap("flutter_devs"),
        largeIcon: DrawableResourceAndroidBitmap("flutter_devs"),
        contentTitle: 'flutter devs',
        htmlFormatContentTitle: true,
        summaryText: 'summaryText',
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('big text channel id', 'big text channel name',
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'big text title', 'silent body', platformChannelSpecifics,
        payload: "big image notifications");
  }

  Future<void> scheduleNotifications() async {
    var scheduledNotificationDateTime = const Time(19, 40, 0);
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel id',
      'channel name',
      icon: 'flutter_devs',
      largeIcon: DrawableResourceAndroidBitmap('flutter_devs'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0, 'scheduled title', 'Daily at time', scheduledNotificationDateTime, platformChannelSpecifics);
  }

  Future scheuleAtParticularTime() async {
    // var time = DateTime(timee.day, timee.month, timee.year, timee.hour,
    //     timee.minute, timee.second);
    var time = DateTime(2021, 10, 23, 18, 05);

    var scheduledNotificationDateTime = DateTime.now().add(const Duration(seconds: 5));
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
    );
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    // tz.initializeTimeZones();
    // tz.setLocalLocation(tz.getLocation('Italy'));
    var fltrNotification;
    await fltrNotification.schedule(1, 'scheduled title', 'scheduled body', time, platformChannelSpecifics);
  }

  Future<void> scheduleNotification() async {
    var scheduledNotificationDateTime = DateTime(2021, 10, 234000, 0, 5, 0); //Here you can set your custom Date&Time

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel id',
      'channel name',
      icon: 'flutter_devs',
      largeIcon: DrawableResourceAndroidBitmap('flutter_devs'),
    );
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0, 'scheduled title', 'scheduled body', scheduledNotificationDateTime, platformChannelSpecifics);
  }

  Future<void> _showTimeoutNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'silent channel id', 'silent channel name',
        timeoutAfter: 5000, styleInformation: DefaultStyleInformation(true, true));
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'Schedule notification', '5 seconds', platformChannelSpecifics);
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  showNotification() async {
    var android =
        const AndroidNotificationDetails('id', 'channel ', priority: Priority.high, importance: Importance.max);
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(0, 'Flutter ', myController.text, platform,
        payload: 'Welcome to the Local Notification demo ');
  }
}

class NewScreen extends StatelessWidget {
  String payload;

  NewScreen({
    required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(payload),
      ),
    );
  }
}
