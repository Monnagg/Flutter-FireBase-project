import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PaylodPage extends StatelessWidget {
  final String info;
  const PaylodPage({super.key,required this.info});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('firebase messaging'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
      ),
      backgroundColor: Colors.brown[100],
      body: Center(
        child: Text(info),
      ),
    );
  }
}
