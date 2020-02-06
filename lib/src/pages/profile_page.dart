import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile setting'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.assessment),
              onPressed: (){},
            )
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Center(
                child: Icon(
                  Icons.account_circle,
                  size: 100,
                ),
              ),
              Text('say hi')
            ],
          ),
        ));
  }
}
