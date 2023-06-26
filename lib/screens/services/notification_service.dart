import 'package:firebase/screens/payload_destionation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future initalize(BuildContext context) async {
    var androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    //var iOSInitialize = IOSInitializationSettings();
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitialize);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
      try {
        print('is empty');
        print(''.isEmpty);
        if (notificationResponse.payload != null &&
            (notificationResponse.payload ?? '').isNotEmpty) {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return PaylodPage(info: notificationResponse.payload.toString());
          }));
        }
      } catch (e) {
        // 处理异常情况
        // ...
      }
    });

    //added for fcm
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Received FCM message:');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification?.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        // playSound: true,
        // sound: RawResourceAndroidNotificationSound('notification'),
        importance: Importance.max,
        priority: Priority.high,
      );
      var notification =
          NotificationDetails(android: androidNotificationDetails);
      await _flutterLocalNotificationsPlugin.show(0,
          message.notification?.title, message.notification?.body, notification,
          payload: message.data['body']);
    });
  }

  static Future showBigTextNotification({
    var id = 0,
    required String title,
    required String body,
    var payload,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      // playSound: true,
      // sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );
    var notification = NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(0, title, body, notification);
  }

  // static Future<void> _firebaseMessageBackgroundHandler(RemoteMessage message)async {
  //   print('Handling a background message ${message.messageId}');
  // }
}
