import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/screens/services/auth.dart';
import 'package:firebase/screens/services/notification_service.dart';
import 'package:firebase/shared/constats.dart';
import 'package:firebase/shared/loading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthenService _auth = AuthenService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  bool loading = false;

  String? myToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //local notification
    //NotificationService.initalize();

    //firebase messaging
    requestPermission();
    getToken();
    NotificationService.initalize(context);
  }

  void sendPushMessage(String title, String body, String token) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=fTDEs-EbSPeiO3nS33zIrw:APA91bHjp981BvsazvDfti6GM1QHwByv1-c24erylVs4alcan3XCMVNEmXjQ4eCdldGlfgQl5W5Jogy8_12O4dAP0d-IptUlw-oninXbLOgkMMYNI3d50ZVXqF_r4K5EIODgwRrWa0Qc'
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            //direct user to new page
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title
            },
            //send notification
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
              'android_channel_id': 'your_channel_id'
              //'android_channel_name': 'your_channel_name'
            },
            'to': token,
          }));
      print('push success');
    } catch (e) {
      if (kDebugMode) {
        print('error push notification');
      }
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        //divice token
        myToken = token;
        print('My token is $myToken');
      });
      if (token != null) {
        saveToken(token);
      }
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection('UserTokens')
        .doc('User1')
        .set({'token': token});
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user granted provisional permission');
    } else {
      print('user declined the request');
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('sign in'),
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              actions: [
                TextButton.icon(
                  onPressed: () async {
                    widget.toggleView();
                  },
                  icon: Icon(Icons.person),
                  label: Text('Register'),
                )
              ],
            ),
            backgroundColor: Colors.brown[100],
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (v) =>
                            v?.isEmpty ?? true ? 'Enter an email' : null,
                        onChanged: (v) {
                          setState(() {
                            email = v;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        obscureText: true,
                        validator: (v) => (v?.length ?? 0) < 6
                            ? 'Enter an passowrd 6+ chars long'
                            : null,
                        onChanged: (v) {
                          setState(() {
                            password = v;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        child: Text('Sign in'),
                        onPressed: () async {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            print('email password');
                            print(email);
                            print(password);
                            dynamic result = await _auth
                                .signInWithEmailPassowrd(email, password);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = 'could sign in use those credentials';
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          //child: Text('local notification'),
                          child: Text('Push notification'),
                          onPressed: () async {
                            // NotificationService.showBigTextNotification(
                            //   title: 'new message title',
                            //   body: 'local notification body',
                            // );

                            //FCM 这里的Email要输入User1
                            if (email != null && email != '') {
                              DocumentSnapshot snapshot =
                                  await FirebaseFirestore.instance
                                      .collection('UserTokens')
                                      .doc(email)
                                      .get();
                              try {
                                String token = snapshot['token'];
                                print('my token is');
                                print(token);
                                sendPushMessage(
                                    'test title', 'test body', token);
                              } catch (e) {
                                print('not able to find user');
                              }
                            }
                          }),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  )),
            ),
          );
  }
}
