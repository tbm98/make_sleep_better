import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:make_sleep_better/src/supports/dates.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage(this.index);

  final int index;

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  DateSupport _dateSupport;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateSupport = DateSupport();
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('20:20'),
            trailing: InkWell(
                onTap: () => _confirmRating(DateTime.now()),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Vote',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                )),
          );
        });
  }

  void _confirmRating(DateTime time) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('You woke up at ${_dateSupport.formatWithDMY(time)}'),
            content: const Text('How do you feel ?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.red,
                    ),
                    const Text(
                      ' Tired',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.sentiment_neutral),
                    const Text(' Normal',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.sentiment_satisfied, color: Colors.blue),
                    const Text(' Comfortable',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
