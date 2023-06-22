import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class remainter extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<remainter> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final myController = TextEditingController();
  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
    AndroidInitializationSettings('flutter_notification');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
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
      appBar: new AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: new Text('Flutter notification'),
      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 250,
              child: TextField(
                controller: myController,
                decoration: InputDecoration(
                  hintText: 'notification details',
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: showNotification,
            //   child: new Text(
            //     'show Notification',
            //   ),
            // ),
            //
            // ElevatedButton(
            //   onPressed: cancelNotification,
            //   child: new Text(
            //     'cancel Notification',
            //   ),
            // ),
            // ElevatedButton(
            //   onPressed: _showTimeoutNotification,
            //   child: new Text(
            //     'schedule Notification',
            //   ),
            // ),
            ElevatedButton(
              onPressed: scheduleNotifications,
              child: new Text(
                'show schedule',
              ),
            ),
            // ElevatedButton(
            //   onPressed: showNotificationMediaStyle,
            //   child: new Text(
            //     'show NotificationMediaStyle',
            //   ),
            // ),
            ElevatedButton(onPressed: _showInboxNotification, child: new Text(
                'Show InboxNotification'
            )),
            ElevatedButton(onPressed: _showProgressNotification, child: new Text(
                'show progressnotification'
            )),

          ],
        ),
      ),
    );
  }

  Future<void> showNotificationMediaStyle() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'media channel id',
      'media channel name',
      color: Colors.red,
      enableLights: true,
      largeIcon: DrawableResourceAndroidBitmap("flutter_devs"),
      styleInformation: MediaStyleInformation(),
    );
    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'notification title', 'notification body', platformChannelSpecifics);
  }

  Future<void> _showProgressNotification() async {
    const int maxProgress = 5;
    for (int i = 0; i <= maxProgress; i++) {
      await Future<void>.delayed(const Duration(seconds: 1), () async {
        final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('progress channel', 'progress channel',
            channelShowBadge: false,
            onlyAlertOnce: true,
            showProgress: true,
            maxProgress: maxProgress,
            progress: i);
        final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0,
            'progress notification title',
            'progress notification body',
            platformChannelSpecifics,
            payload: 'item x');
      });
    }
  }
  Future<void> _showInboxNotification() async {
    final List<String> lines = <String>['line <b>1</b>', 'line <i>2</i>'];
    final InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        lines,
        htmlFormatLines: true,
        contentTitle: 'overridden <b>inbox</b> context title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('inbox channel id', 'inboxchannel name',
        styleInformation: inboxStyleInformation);
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'inbox title', 'inbox body', platformChannelSpecifics);
  }

  Future<void> showAlertNotification() async {
    var time = Time(19, 15, 0);
    var androidChannel = AndroidNotificationDetails(
        'channelID', 'channelName',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        playSound: true);

    var iosChannel = IOSNotificationDetails();
    var platformChannel =
    NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin.showDailyAtTime(2, 'notification title',
        'message here', time, platformChannel,
        payload: 'new payload');
  }

  Future<void> showBigPictureNotification() async {
    var bigPictureStyleInformation = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("flutter_devs"),
        largeIcon: DrawableResourceAndroidBitmap("flutter_devs"),
        contentTitle: 'flutter devs',
        htmlFormatContentTitle: true,
        summaryText: 'summaryText',
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics,
        payload: "big image notifications");
  }

  Future<void> scheduleNotifications() async {
    var scheduledNotificationDateTime = Time(19,40,0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      icon: 'flutter_devs',
      largeIcon: DrawableResourceAndroidBitmap('flutter_devs'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'scheduled title',
        'Daily at time',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }
  Future scheuleAtParticularTime() async {
    // var time = DateTime(timee.day, timee.month, timee.year, timee.hour,
    //     timee.minute, timee.second);
    var time =
    DateTime(2021,10, 23, 18, 05);

    var scheduledNotificationDateTime =
    new DateTime.now().add(new Duration(seconds: 5));
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    // tz.initializeTimeZones();
    // tz.setLocalLocation(tz.getLocation('Italy'));
    var fltrNotification;
    await fltrNotification.schedule(1, 'scheduled title', 'scheduled body',
        time, platformChannelSpecifics);
  }


  Future<void> scheduleNotification() async {

    var scheduledNotificationDateTime =
    DateTime(2021,10,234000,0,5,0); //Here you can set your custom Date&Time

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      icon: 'flutter_devs',
      largeIcon: DrawableResourceAndroidBitmap('flutter_devs'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }



  Future<void> _showTimeoutNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('silent channel id', 'silent channel name',
        timeoutAfter: 5000,
        styleInformation: DefaultStyleInformation(true, true));
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'Schedule notification',
        '5 seconds', platformChannelSpecifics);
  }


  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  showNotification() async {
    var android = new AndroidNotificationDetails(
        'id', 'channel ',
        priority: Priority.high, importance: Importance.max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'Flutter ',myController.text, platform,
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


//
// name: notifi
// description: A new Flutter project.
//
// # The following line prevents the package from being accidentally published to
// # pub.dev using `flutter pub publish`. This is preferred for private packages.
// publish_to: 'none' # Remove this line if you wish to publish to pub.dev
//
// # The following defines the version and build number for your application.
// # A version number is three numbers separated by dots, like 1.2.43
// # followed by an optional build number separated by a +.
// # Both the version and the builder number may be overridden in flutter
// # build by specifying --build-name and --build-number, respectively.
// # In Android, build-name is used as versionName while build-number used as versionCode.
// # Read more about Android versioning at https://developer.android.com/studio/publish/versioning
// # In iOS, build-name is used as CFBundleShortVersionString while build-number used as CFBundleVersion.
// # Read more about iOS versioning at
// # https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
// version: 1.0.0+1
//
// environment:
// sdk: ">=2.7.0 <3.0.0"
//
// # Dependencies specify other packages that your package needs in order to work.
// # To automatically upgrade your package dependencies to the latest versions
// # consider running `flutter pub upgrade --major-versions`. Alternatively,
// # dependencies can be manually updated by changing the version numbers below to
// # the latest version available on pub.dev. To see which dependencies have newer
// # versions available, run `flutter pub outdated`.
// dependencies:
// flutter:
// sdk: flutter
//
//
// # The following adds the Cupertino Icons font to your application.
// # Use with the CupertinoIcons class for iOS style icons.
// cupertino_icons: ^1.0.2
//
// dev_dependencies:
// flutter_test:
// sdk: flutter
//
// # The "flutter_lints" package below contains a set of recommended lints to
// # encourage good coding practices. The lint set provided by the package is
// # activated in the `analysis_options.yaml` file located at the root of your
// # package. See that file for information about deactivating specific lint
// # rules and activating additional ones.
// flutter_lints: ^1.0.0
// flutter_local_notifications: ^1.4.4+1
// flutter_native_timezone: ^2.0.0
//
// device_info: ^2.0.2
// http: ^0.13.3
// path_provider: ^2.0.5
// rxdart: ^0.27.2
//
//
// # For information on the generic Dart part of this file, see the
// # following page: https://dart.dev/tools/pub/pubspec
//
// # The following section is specific to Flutter.
// flutter:
//
// # The following line ensures that the Material Icons font is
// # included with your application, so that you can use the icons in
// # the material Icons class.
// uses-material-design: true
//
//
//
// # To add assets to your application, add an assets section, like this:
// # assets:
// #   - images/a_dot_burr.jpeg
// #   - images/a_dot_ham.jpeg
//
// # An image asset can refer to one or more resolution-specific "variants", see
// # https://flutter.dev/assets-and-images/#resolution-aware.
//
// # For details regarding adding assets from package dependencies, see
// # https://flutter.dev/assets-and-images/#from-packages
//
// # To add custom fonts to your application, add a fonts section here,
// # in this "flutter" section. Each entry in this list should have a
// # "family" key with the font family name, and a "fonts" key with a
// # list giving the asset and other descriptors for the font. For
// # example:
// # fonts:
// #   - family: Schyler
// #     fonts:
// #       - asset: fonts/Schyler-Regular.ttf
// #       - asset: fonts/Schyler-Italic.ttf
// #         style: italic
// #   - family: Trajan Pro
// #     fonts:
// #       - asset: fonts/TrajanPro.ttf
// #       - asset: fonts/TrajanPro_Bold.ttf
// #         weight: 700
// #
// # For details regarding fonts from package dependencies,
// # see https://flutter.dev/custom-fonts/#from-packages