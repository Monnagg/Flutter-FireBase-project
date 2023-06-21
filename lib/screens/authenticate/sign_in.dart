import 'package:firebase/screens/services/auth.dart';
import 'package:firebase/screens/services/notification_service.dart';
import 'package:firebase/shared/constats.dart';
import 'package:firebase/shared/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
     FlutterLocalNotificationsPlugin();

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   NotificationService.initalize();
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
                          child: Text('local notification'),
                          onPressed: () async {
                            NotificationService.showBigTextNotification(
                                title: 'new message title',
                                body: 'local notification body',
                                );
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
