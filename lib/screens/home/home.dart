import 'package:firebase/screens/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final AuthenService _auth = AuthenService();
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          )
        ],
      ),
    );
  }
}
