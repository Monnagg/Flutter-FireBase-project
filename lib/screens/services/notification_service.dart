import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static Future initalize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        new AndroidInitializationSettings('mipmap/ic_launcher');
    //var iOSInitialize = IOSInitializationSettings();
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin
          flutterLocalNotificationsPlugin}) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'my_channel_name',
      'body',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );
    var notification =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(0, title, body, notification);
  }
}
