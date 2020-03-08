import 'package:android_intent/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'delay_animation.dart';
import 'info.dart';
import '../supports/prefs.dart';
import '../providers/main.dart';
import '../obj/time_wake_up.dart';
import 'profile.dart';
import '../supports/dates.dart';
import '../supports/sizes.dart';
import 'dart:io' show Platform;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateSupport _dateSupport;
  RangeValues _rangeValues;
  DateTime _timeSleep;
  List<TimeWakeUp> _timeWakeUp;

  MainProvider get _mainProvider =>
      Provider.of<MainProvider>(context, listen: false);

  DateTime _now = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay.now();

  Future<int> _delayMinuteFuture;
  int _delayMinute;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _dateSupport = DateSupport();
    _rangeValues = const RangeValues(3, 6);
    _timeSleep = _dateSupport.time;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _delayMinuteFuture =
        Provider.of<PrefsSupport>(context, listen: false).getDelayMinute();
  }

  void _loadTimeWakeUp() {
    _timeWakeUp = _dateSupport.getTimesWakeUp(
        _timeSleep, _delayMinute, _rangeValues.start, _rangeValues.end);
  }

  String _labelCycle(double num) {
    return '${num.toInt()} cycle';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Make Sleep Better'),
          centerTitle: true,
          leading: _leadingAppbar(),
          actions: _actionAppbars(),
        ),
        body: Builder(
          builder: (context) {
            return _body(context);
          },
        ));
  }

  Widget _leadingAppbar() {
    return IconButton(
      icon: Consumer<MainProvider>(
        builder: (_, provider, __) {
          if (provider.darkMode) {
            return Icon(Icons.brightness_3);
          } else {
            return Icon(Icons.brightness_4);
          }
        },
      ),
      onPressed: () {
        Provider.of<MainProvider>(context, listen: false)
            .switchBrightnessMode();
      },
    );
  }

  List<Widget> _actionAppbars() {
    return [
      IconButton(
        icon: Icon(Icons.info),
        onPressed: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (_) => const InfoPage()));
        },
      ),
      IconButton(
        icon: Icon(Icons.account_circle),
        onPressed: () async {
          await Navigator.push(
              context, CupertinoPageRoute(builder: (_) => const ProfilePage()));
          setState(() {
            _delayMinuteFuture =
                Provider.of<PrefsSupport>(context, listen: false)
                    .getDelayMinute();
          });
        },
      ),
    ];
  }

  void _launchClock(int hour, int minutes) async {
    if (Platform.isAndroid) {
      final AndroidIntent intent =
          AndroidIntent(action: 'android.intent.action.SET_ALARM', flags: [
        0x10000000
      ], arguments: {
        'android.intent.extra.alarm.HOUR': hour,
        'android.intent.extra.alarm.MINUTES': minutes
      });
      await intent.launch();
    }
  }

  Widget _body(BuildContext context) {
    return Column(
      children: <Widget>[
        _clock(context),
        _textHeader(context),
        _timeSetting(context),
        _listTimeWakeup(context)
      ],
    );
  }

  Widget _clock(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: FractionallySizedBox(
        widthFactor: 0.6,
        child: FittedBox(
          child: Text(
            _dateSupport.formatTime(_timeOfDay),
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
    );
  }

  Widget _textHeader(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        'Do you ever go to bed ridiculously early because you need to wake up on time for work - then feel even more tired in the morning?',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _timeSetting(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        RangeSlider(
          values: _rangeValues,
          onChanged: (newValue) {
            setState(() {
              _rangeValues = newValue;
              _loadTimeWakeUp();
            });
          },
          min: 1,
          max: 10,
          divisions: 9,
          labels: RangeLabels(
              _labelCycle(_rangeValues.start), _labelCycle(_rangeValues.end)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: <Widget>[
              Text(
                _rangeValues.start.toInt().toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(' - ', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(_rangeValues.end.toInt().toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const Text(' cycles',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.history,
                  color: Colors.blue,
                  size: 36,
                ),
                onPressed: () {
                  _showTimePicker();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showTimePicker() async {
    final TimeOfDay timeSelected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    if (timeSelected == null) {
      return;
    }
    _timeOfDay = timeSelected;
    _now = DateTime(_now.year, _now.month, _now.day, _timeOfDay.hour,
        _timeOfDay.minute, _now.second, _now.millisecond, _now.microsecond);

    _timeSleep = DateTime(_timeSleep.year, _timeSleep.month, _timeSleep.day,
        _timeOfDay.hour, _timeOfDay.minute);
    _loadTimeWakeUp();
  }

  Widget _listTimeWakeup(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: _delayMinuteFuture,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: Shimmer.fromColors(
                baseColor: Colors.red,
                highlightColor: Colors.yellow,
                child: const Text(
                  'Loading from data',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          } else {
            _delayMinute = snapshot.data;
            _loadTimeWakeUp();
            return DelayedAnimation(
              delay: 150,
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    final TimeWakeUp timeWakeup = _timeWakeUp[index];

                    return ListTile(
                      title: Text(
                        _dateSupport.formatHHmmWithDay(timeWakeup.time),
                        style:
                            TextStyle(fontSize: Sizes.getWidth(context) / 16),
                      ),
                      subtitle: Text(_mainProvider.getSuggest(
                          timeWakeup.cycle, snapshot.data)),
                      trailing: InkWell(
                        onTap: () {
                          _confirmSelectTime(timeWakeup.time, timeWakeup.cycle);
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              _mainProvider.getIconOfCycle(timeWakeup.cycle),
                              color: _mainProvider
                                  .getColorOfCycle(timeWakeup.cycle),
                            ),
                            const Text('Select')
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) {
                    return const Divider();
                  },
                  itemCount: _timeWakeUp.length),
            );
          }
        },
      ),
    );
  }

  void _confirmSelectTime(DateTime timeWakeup, int cycle) {
//    logs(time.difference(_now).inMinutes);
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              _dateSupport.formatHHmmWithDay(timeWakeup),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
            ),
            content: const Text('Do you want to wake up at this time ?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              FlatButton(
                onPressed: () {
                  _handleWhenConfirmSelected(timeWakeup, cycle);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.green),
                ),
              )
            ],
          );
        });
  }

  void _handleWhenConfirmSelected(DateTime timeWakeup, int cycle) {
    Navigator.pop(context);
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(minutes: 1),
      content: Text(
          'Let\'s set the alarm at ${_dateSupport.formatHHmmWithDay(timeWakeup)}'),
      action: SnackBarAction(
        label: 'Yes, I did this.',
        onPressed: () {
          _scaffoldKey.currentState.hideCurrentSnackBar();
        },
      ),
    ));
    _mainProvider.addData(timeWakeup, _now, cycle);
    _mainProvider.setScheduleNotification(
        timeWakeup, _now, cycle, _delayMinute, context);
    _launchClock(timeWakeup.hour, timeWakeup.minute);
  }
}
