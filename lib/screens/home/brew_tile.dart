import 'package:firebase/model/brew.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class BrewTile extends StatelessWidget {
  final Brew brew;
  const BrewTile({super.key,required this.brew});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: 8),
    child: Card(
      margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.brown[brew.strength],
        radius: 25,
        backgroundImage: AssetImage('images/coffee_icon.png'),
        ),
        title: Text(brew.name),
        subtitle: Text('Take ${brew.sugars} sugar(s )'),
      ),
    ),
    );
  }
}
