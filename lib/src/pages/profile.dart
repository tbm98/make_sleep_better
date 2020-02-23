import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:make_sleep_better/src/obj/data.dart';
import 'package:make_sleep_better/src/pages/delay_animation.dart';
import 'package:make_sleep_better/src/pages/feedback.dart';
import 'package:make_sleep_better/src/pages/statistic.dart';
import 'package:make_sleep_better/src/providers/main.dart';
import 'package:make_sleep_better/src/supports/dates.dart';
import 'package:make_sleep_better/src/supports/file_store.dart';
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
  DateSupport _dateSupport;
  TimeOfDay _timeOfDay = TimeOfDay.now();
  int _indexPage = 0;
  final _pageController = PageController(initialPage: 0);
  FileStore _fileStore;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateSupport = DateSupport();
    _fileStore = const FileStore();
    _getListWakeUpNotYetRated();
  }

  Future<void> _getListWakeUpNotYetRated() async {
    final String readFromFile = await _fileStore.readData();
    final listDataFromFile = jsonDecode(readFromFile) as List;
    final _listDataWakeUp = listDataFromFile
        .map((e) => Data.fromMap(e))
        .toList()
          ..removeWhere((element) => element.feedback);
    if (_listDataWakeUp.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 1000));
      await _pageController.animateToPage(1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutQuart);
    }
  }

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
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indexPage,
          onTap: (index) {
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutQuart);
          },
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
                  _clock(context),
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

  Widget _clock(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        _dateSupport.formatTime(_timeOfDay),
        style: const TextStyle(color: Colors.blue, fontSize: 36),
      ),
    );
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
          return DelayedAnimation(
            delay: 200,
            child: FractionallySizedBox(
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
                    ))),
          );
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
      content: Text(
        'Update time success ^_^',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blue,
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
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _indexPage = index;
        });
      },
      children: const <Widget>[
        FeedbackPage(),
        StatisticPage(),
      ],
    );
  }
}
