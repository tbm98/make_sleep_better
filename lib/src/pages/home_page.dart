import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:make_sleep_better/src/notifiers.dart';
import 'package:make_sleep_better/src/obj/time_wake_up.dart';
import 'package:make_sleep_better/src/pages/profile_page.dart';
import 'package:make_sleep_better/src/supports/dates.dart';
import 'package:make_sleep_better/src/supports/sizes.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateSupport _dateSupport;
  RangeValues _rangeValues;
  DateTime _timeSleep;
  Future<List<TimeWakeUp>> _timeWakeUp;

  @override
  void initState() {
    super.initState();
    _dateSupport = DateSupport();
    _rangeValues = RangeValues(3, 6);
    _timeSleep = _dateSupport.time;
    _loadTimeWakeUp();
  }

  void _loadTimeWakeUp() {
    _timeWakeUp = _dateSupport.getTimesWakeUp(
        _timeSleep, 14, _rangeValues.start, _rangeValues.end);
  }

  String _labelCycle(double num) {
    return '${num.toInt()} cycle';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Make Sleep Better'),
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
      icon: Icon(Icons.brightness_3),
      onPressed: () {
        Provider.of<MainNotifier>(context, listen: false)
            .switchBrightnessMode();
      },
    );
  }

  List<Widget> _actionAppbars() {
    return [
      IconButton(
        icon: Icon(Icons.account_circle),
        onPressed: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (_) => ProfilePage()));
        },
      )
    ];
  }

  Container _body(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _textHeader(context),
          _timeSetting(context),
          _listTimeWakeup(context)
        ],
      ),
    );
  }

  Widget _textHeader(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: TextSpan(
//                      text: 'I am Minh',
              style: TextStyle(
                  color: Colors.black, fontSize: Sizes.getWidth(context) / 16),
              children: [
                TextSpan(text: 'Nếu bạn đi ngủ vào '),
                TextSpan(text: '8:00 AM'),
                TextSpan(text: ', bạn nên thức giấc vào những thời điểm sau: '),
                TextSpan(text: '11:00 PM'),
                TextSpan(text: ' '),
                TextSpan(text: ''),
                TextSpan(
                    text:
                        '(Thức dậy giữa một chu kỳ giấ cngủ khiến bạn cảm thấy mệt mỏi, nhưng khi thức dậy vào lsdlsj')
              ]),
        ),
      ),
    );
  }

  Widget _timeSetting(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: RangeSlider(
              values: _rangeValues,
              onChanged: (newValue) {
                setState(() {
                  _rangeValues = newValue;
                  _loadTimeWakeUp();
                });
              },
              min: 1.0,
              max: 10.0,
              divisions: 9,
              labels: RangeLabels(_labelCycle(_rangeValues.start),
                  _labelCycle(_rangeValues.end)),
            ),
          ),
          Chip(
            avatar: Icon(
              Icons.history,
              color: Colors.blue,
            ),
            label: Text(
              '8:00',
            ),
            labelStyle: TextStyle(
                color: Colors.blue, fontSize: Sizes.getWidth(context) / 17),
            backgroundColor: Colors.blue[50],
            shadowColor: Colors.red,
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _listTimeWakeup(BuildContext context) {
    return SizedBox(
      height: Sizes.getHeightNoAppbar(context) * 0.5,
      child: FutureBuilder(
        future: _timeWakeUp,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<TimeWakeUp> timeWakeUps = snapshot.data;

            return ListView.separated(
                itemBuilder: (context, index) {
                  TimeWakeUp data = timeWakeUps[index];

                  return ListTile(
                    leading: Text(
                      _dateSupport.format(data.time),
                      style: TextStyle(fontSize: Sizes.getWidth(context) / 16),
                    ),
                    trailing: Switch.adaptive(value: false, onChanged: (_) {}),
                  );
                },
                separatorBuilder: (_, __) {
                  return Divider();
                },
                itemCount: timeWakeUps.length);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
