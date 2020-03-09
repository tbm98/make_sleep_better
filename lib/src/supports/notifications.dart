import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../pages/profile.dart';

class NotificationSupport {
  NotificationSupport._(BuildContext context) {
    _init(context);
  }

  BuildContext context;
  static NotificationSupport _instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static NotificationSupport instance(BuildContext context) {
    return _instance ??= NotificationSupport._(context);
  }

  void _init(BuildContext context) async {
    this.context = context;
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void addNotifiSchedule(DateTime timeWakeup, Duration timeForSleep) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'make_sleep_better_id',
        'make_sleep_better_name',
        'make_sleep_better_description');
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        timeWakeup.millisecondsSinceEpoch % 1000000,
        'How do you feel ?',
        'You slept within ${timeForSleep.inHours} '
            'hours ${timeForSleep.inMinutes % 60} minutes',
        timeWakeup,
        platformChannelSpecifics);
  }

  void cancelAllNotifi() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    onSelectNotifi(payload);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {
    // todo: add logic to handle did receive local notification
  }

  void onSelectNotifi(String payload) async {
    await Navigator.push(
        context, CupertinoPageRoute(builder: (context) => const ProfilePage()));
  }
}
