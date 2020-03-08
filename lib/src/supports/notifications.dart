import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationSupport {
  NotificationSupport._() {
    _init();
  }

  static NotificationSupport _instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static NotificationSupport getInstance() {
    return _instance ??= NotificationSupport._();
  }

  void _init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void addNotifiSchedule(DateTime time) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'make_sleep_better_id',
        'make_sleep_better_name',
        'make_sleep_better_description');
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        time.millisecondsSinceEpoch,
        'scheduled title',
        'Give feedback on that!',
        time,
        platformChannelSpecifics);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    onSelectNotifi(payload);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {}

  void onSelectNotifi(String payload) {}
}
