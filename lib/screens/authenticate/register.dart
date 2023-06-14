import 'dart:ffi';

import 'package:firebase/shared/constats.dart';
import 'package:firebase/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthenService _auth = AuthenService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading? Loading():Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: [
          TextButton.icon(
            onPressed: () async {
              widget.toggleView();
            },
            icon: Icon(Icons.person),
            label: Text('sign in'),
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
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
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
                  child: Text('Sign up'),
                  onPressed: () async {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                           setState(() {
                        loading = true;
                      });
                      print('email password');
                      print(email);
                      print(password);
                      dynamic result = await _auth.registerWithEmailPassowrd(
                          email, password);
                      if (result == null) {
                        setState(() {
                          loading = false;
                          error = 'please supply a valid email';
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
                )
              ],
            )),
      ),
    );
  }
}
