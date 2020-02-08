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
              onPressed: () {},
            )
          ],
        ),
        body: SizedBox.expand(
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Icon(
                        Icons.account_circle,
                        size: 100,
                        color: Colors.blue,
                      ),
                    ),
                    Text('say hi'),
                    //todo: add controller for how long of one cycle and time for waiting to go to sleep
                    FractionallySizedBox(widthFactor: 0.3, child: TextField()),
                    FractionallySizedBox(widthFactor: 0.3, child: TextField()),
                    RaisedButton(),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  color: Colors.red,
                  //todo: add charts ,
                ),
              )
            ],
          ),
        ));
  }
}
