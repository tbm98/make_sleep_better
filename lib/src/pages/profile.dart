import 'package:flutter/material.dart';
import 'package:make_sleep_better/src/pages/feedback.dart';
import 'package:make_sleep_better/src/pages/statistic.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../supports/prefs.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<int> _delayMinuteFuture;
  int _delayMinute = 0;
  PrefsSupport _prefsSupport;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _delayMinuteFuture =
        Provider.of<PrefsSupport>(context, listen: false).getDelayMinute();
  }

  @override
  Widget build(BuildContext context) {
    _prefsSupport = Provider.of<PrefsSupport>(context, listen: false);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Profile setting'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.assessment),
              onPressed: () {},
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.snooze), title: const Text('Not yet rated')),
            BottomNavigationBarItem(
                icon: Icon(Icons.assessment), title: const Text('Statistical'))
          ],
        ),
        body: SizedBox.expand(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: FractionallySizedBox(
                      widthFactor: 0.4,
                      child: FittedBox(
                        child: Icon(
                          Icons.account_circle,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Have a nice day!',
                    style: TextStyle(color: Colors.blue),
                  ),
                  _buildForm(),
                ],
              ),
              Expanded(child: _buildTimeWakeUpFeedback())
            ],
          ),
        ));
  }

  Widget _buildForm() {
    return FutureBuilder(
      future: _delayMinuteFuture,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return SizedBox(
            child: Shimmer.fromColors(
              baseColor: Colors.red,
              highlightColor: Colors.yellow,
              child: Text(
                'Loading from data',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        } else {
          _delayMinute = snapshot.data;
          return FractionallySizedBox(
              widthFactor: 0.8,
              child: Form(
                  key: _formKey,
                  child: TextFormField(
                    initialValue: snapshot.data.toString(),
                    onChanged: (value) {
                      _delayMinute = int.tryParse(value);
                    },
                    decoration: InputDecoration(
                        helperText:
                            'Time from lying in bed to sleeping (minute)',
                        suffixIcon: InkWell(
                            onTap: _formValidate,
                            child: const Chip(
                              label: Text('Update time'),
                            ))),
                    keyboardType: TextInputType.number,
                    validator: _formValidator,
                    maxLength: 3,
                  )));
        }
      },
    );
  }

  String _formValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'Must not be empty!';
    }
    if (int.parse(value) == 0) {
      return 'Unbelievable, It can\'t be zero';
    } else {
      return null;
    }
  }

  void _formValidate() async {
    if (_formKey.currentState.validate()) {
      final bool success = await _prefsSupport.saveDelayMinute(_delayMinute);
      if (success) {
        _updateTimeSuccess();
      } else {
        _updateTimeFail();
      }
    }
  }

  void _updateTimeSuccess() {
    _scaffoldKey.currentState.showSnackBar(const SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text('Update time success ^_^'),
      backgroundColor: Colors.green,
    ));
  }

  void _updateTimeFail() {
    _scaffoldKey.currentState.showSnackBar(const SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text('Update time fail :('),
      backgroundColor: Colors.red,
    ));
  }

  Widget _buildTimeWakeUpFeedback() {
    return PageView(
      children: const <Widget>[
        FeedbackPage(),
        StatisticPage(),
      ],
    );
  }
}
