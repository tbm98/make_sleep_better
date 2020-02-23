import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:make_sleep_better/src/pages/delay_animation.dart';
import 'package:make_sleep_better/src/pages/info.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../supports/prefs.dart';
import '../providers/main.dart';
import '../obj/time_wake_up.dart';
import 'profile.dart';
import '../supports/dates.dart';
import '../supports/sizes.dart';

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
    // TODO: implement didChangeDependencies
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
    return const Expanded(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Do you ever go to bed ridiculously early because you need to wake up on time for work - then feel even more tired in the morning?',
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
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
    _timeSleep = DateTime(_timeSleep.year, _timeSleep.month, _timeSleep.day,
        _timeOfDay.hour, _timeOfDay.minute);
    _loadTimeWakeUp();
  }

  Widget _listTimeWakeup(BuildContext context) {
    return FutureBuilder(
      future: _delayMinuteFuture,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return SizedBox(
            height: Sizes.getHeightNoAppbar(context) * 0.5,
            child: Center(
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
            ),
          );
        } else {
          _delayMinute = snapshot.data;
          _loadTimeWakeUp();
          return DelayedAnimation(
            delay: 150,
            child: SizedBox(
              height: Sizes.getHeightNoAppbar(context) * 0.5,
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    final TimeWakeUp data = _timeWakeUp[index];

                    return ListTile(
                      title: Text(
                        _dateSupport.formatHHmmWithDay(data.time),
                        style: TextStyle(fontSize: Sizes.getWidth(context) / 16),
                      ),
                      subtitle: Text(
                          _mainProvider.getSuggest(data.cycle, snapshot.data)),
                      trailing: InkWell(
                        onTap: () {
                          _confirmSelectTime(data.time);
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              _mainProvider.getIconOfCycle(data.cycle),
                              color: _mainProvider.getColorOfCycle(data.cycle),
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
            ),
          );
        }
      },
    );
  }

  void _confirmSelectTime(DateTime time) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              _dateSupport.formatHHmmWithDay(time),
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
                  _handleWhenConfirmSelected(time);
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

  void _handleWhenConfirmSelected(DateTime time) {
    Navigator.pop(context);
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(minutes: 1),
      content: Text(
          'Let\'s set the alarm at ${_dateSupport.formatHHmmWithDay(time)}'),
      action: SnackBarAction(
        label: 'Yes, I will do it',
        onPressed: () {
          _scaffoldKey.currentState.hideCurrentSnackBar();
        },
      ),
    ));
    _mainProvider.addData(time);
  }
}
