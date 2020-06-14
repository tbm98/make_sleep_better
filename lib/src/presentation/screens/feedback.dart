import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helpers/dates.dart';
import '../../model/database/local/file_store.dart';
import '../../model/entities/data.dart';
import '../common_widgets/delay_animation.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage();

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  DateSupport _dateSupport;
  FileStore _fileStore;
  Future<List<Data>> _listDataWakeUpFuture;
  List<Data> _listDataWakeUp;

  @override
  void initState() {
    super.initState();
    _dateSupport = DateSupport();
    _fileStore = const FileStore();
    _listDataWakeUpFuture = _getListWakeUpNotYetRated();
  }

  Future<List<Data>> _getListWakeUpNotYetRated() async {
    final String readFromFile = await _fileStore.readData();
    final listDataFromFile = jsonDecode(readFromFile) as List;
    _listDataWakeUp = listDataFromFile.map((e) => Data.fromMap(e)).toList()
      ..removeWhere((element) => element.feedback);
    return _listDataWakeUp ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _listDataWakeUpFuture,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (_listDataWakeUp.isEmpty) {
            return const DelayedAnimation(
              delay: 300,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36),
                  child: Text(
                    'You\'ve finished your sleep, go to the statistics page'
                    ' to see how effective it is.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          } else {
            return _buildListWakeUp();
          }
        }
      },
    );
  }

  Widget _buildListWakeUp() {
    return DelayedAnimation(
      delay: 250,
      child: ListView.separated(
          separatorBuilder: (_, __) {
            return const Divider();
          },
          itemCount: _listDataWakeUp.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(right: 8, bottom: 8),
                    child: Icon(Icons.access_alarm),
                  ),
                  Text(
                    _dateSupport
                        .formatWithDayDMY(_listDataWakeUp[index].timeWakeUp),
                    style: DefaultTextStyle.of(context)
                        .style
                        .copyWith(fontSize: 18),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(right: 8, bottom: 4),
                        child: Icon(Icons.airline_seat_individual_suite),
                      ),
                      Text(_dateSupport
                          .formatWithDayDMY(_listDataWakeUp[index].timeSleep)),
                    ],
                  ),
                  Text(
                    '${_listDataWakeUp[index].cycleSleep} cycles sleep',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              trailing: InkWell(
                  onTap: () =>
                      _confirmRating(_listDataWakeUp[index].timeWakeUp, index),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue, width: 0.5)),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Vote',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                  )),
            );
          }),
    );
  }

  void _confirmRating(DateTime time, int index) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title:
                Text('You woke up at ${_dateSupport.formatWithDayDMY(time)}'),
            content: const Text('How do you feel ?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => _rating(4, index),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Icon(Icons.delete_forever, color: Colors.red),
                    Text(' My mistake. remove it',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              FlatButton(
                onPressed: () => _rating(1, index),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.red,
                    ),
                    Text(
                      ' Tired',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              FlatButton(
                onPressed: () => _rating(2, index),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Icon(
                      Icons.sentiment_neutral,
                      color: Colors.grey,
                    ),
                    Text(' Normal',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey)),
                  ],
                ),
              ),
              FlatButton(
                onPressed: () => _rating(3, index),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Icon(Icons.sentiment_satisfied, color: Colors.blue),
                    Text(' Comfortable',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          );
        });
  }

  void _rating(int level, int index) async {
    Navigator.pop(context);
    if (level != 4) {
      _listDataWakeUp[index].feedback = true;
      _listDataWakeUp[index].level = level;
      await _fileStore.updateData(_listDataWakeUp[index]);
      _listDataWakeUpFuture = _getListWakeUpNotYetRated();
    } else {
      await _fileStore.removeData(_listDataWakeUp[index]);
      _listDataWakeUpFuture = _getListWakeUpNotYetRated();
    }
    setState(() {});
  }
}
