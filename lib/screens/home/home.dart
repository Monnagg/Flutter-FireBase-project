import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/model/brew.dart';
import 'package:firebase/screens/home/brew_list.dart';
import 'package:firebase/screens/home/settings_form.dart';
import 'package:firebase/screens/services/auth.dart';
import 'package:firebase/screens/services/databse.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthenService _auth = AuthenService();
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: SettingsFrom(),
            );
          });
    }

    return StreamProvider<List<Brew>?>.value(
      value: DatabaseService().coffeShopSnapshot,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('home page'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: [
            TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.person),
              label: Text('logout'),
            ),
            TextButton.icon(
              onPressed: ()=>_showSettingsPanel(),
              icon: Icon(Icons.settings),
              label: Text('settings'),
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('images/coffee_bg.png'),
            fit: BoxFit.cover
            )
          ),
          child: UserList()),
      ),
    );
  }
}
