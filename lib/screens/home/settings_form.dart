import 'package:firebase/model/user.dart';
import 'package:firebase/screens/services/databse.dart';
import 'package:firebase/shared/constats.dart';
import 'package:firebase/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

class SettingsFrom extends StatefulWidget {
  const SettingsFrom({super.key});

  @override
  State<SettingsFrom> createState() => _SettingsFromState();
}

class _SettingsFromState extends State<SettingsFrom> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];
  String? _currentName;
  String? _currentSugar;
  double? _currentStrength;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return StreamBuilder<UserData>(
      stream: user == null ? null : DatabaseService(uid: user.uid).userDate,
      builder: (context, snapshot) {
        UserData? userData = snapshot.data;

        if (snapshot.hasData) {
          return Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'update your brew settings',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: '${_currentName ?? (userData != null ? userData.name : '')}',
                    decoration: textInputDecoration,
                    //obscureText: true,
                    validator: (v) =>
                        (v?.isEmpty ?? false) ? 'Please enter a name' : null,
                    onChanged: (v) {
                      setState(() {
                        _currentName = v;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                      value: _currentSugar ??
                          (userData != null ? userData.sugars : '0'),
                      items: sugars.map((sugar) {
                        return DropdownMenuItem(
                          value: sugar,
                          child: Text('Sugar $sugar'),
                        );
                      }).toList(),
                      onChanged: (v) {
                        setState(() {
                          _currentSugar = v ?? '0';
                        });
                      }),
                       SizedBox(
                    height: 20,
                  ),
                  Slider(
                      value: _currentStrength ??
                          (userData != null
                              ? userData.strength.toDouble()
                              : 100),
                      min: 100,
                      max: 900,
                      divisions: 8,
                      activeColor: Colors.brown[(_currentStrength ??
                              (userData != null
                                  ? userData.strength.toDouble()
                                  : 100))
                          .round()],
                      inactiveColor: Colors.brown,
                      onChanged: (v) {
                        setState(() {
                          _currentStrength = v;
                        });
                      }),
                  TextButton(
                      child:
                          Text('Update', style: TextStyle(color: Colors.white)),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.pinkAccent), // 设置背景颜色
                      ),
                      onPressed: () async {
                        print('brew');
                        print(_currentName);
                        print(_currentSugar);
                        print(_currentStrength);
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          if (user != null) {
                            await DatabaseService(uid: user.uid).updateUserData(
                                _currentSugar ??
                                    (userData != null ? userData.sugars : '0'),
                                _currentName ??
                                    (userData != null ? userData.name : ''),
                                (_currentStrength ??
                                        (userData != null
                                            ? userData.strength.toDouble()
                                            : 100))
                                    .round());
                          }
                          Navigator.pop(context);

                          //setState(() {});
                        }
                      }),
                ],
              ));
        } else {
          return Loading();
        }
      },
    );
  }
}
