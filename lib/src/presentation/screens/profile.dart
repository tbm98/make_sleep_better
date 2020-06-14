import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:make_sleep_better/src/notifiers/main_state.dart';
import 'package:provider/provider.dart';

import '../../helpers/dates.dart';
import '../../model/database/local/file_store.dart';
import '../../model/database/local/prefs.dart';
import '../../model/entities/data.dart';
import '../../notifiers/main.dart';
import '../common_widgets/delay_animation.dart';
import 'feedback.dart';
import 'statistic.dart';

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
  final TimeOfDay _timeOfDay = TimeOfDay.now();
  int _indexPage = 0;
  final _pageController = PageController(initialPage: 0);
  FileStore _fileStore;
  final _focusNode = FocusNode();

  @override
  void initState() {
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
      await Future.delayed(const Duration(milliseconds: 2000));
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
              icon: Consumer<MainState>(
                builder: (_, state, __) {
                  if (state.darkMode) {
                    return const Icon(Icons.brightness_3);
                  } else {
                    return const Icon(Icons.brightness_4);
                  }
                },
              ),
              onPressed: () {
                Provider.of<MainNotifier>(context, listen: false)
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
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.snooze), title: Text('Not yet rated')),
            BottomNavigationBarItem(
                icon: Icon(Icons.assessment), title: Text('Statistical'))
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          _delayMinute = snapshot.data;
          return DelayedAnimation(
            delay: 200,
            child: FractionallySizedBox(
                widthFactor: 0.9,
                child: Form(
                    key: _formKey,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            focusNode: _focusNode,
                            initialValue: snapshot.data.toString(),
                            onChanged: (value) {
                              _delayMinute = int.tryParse(value);
                            },
                            decoration: const InputDecoration(
                              helperText:
                                  'Time from lying in bed to sleeping (minute)',
                            ),
                            keyboardType: TextInputType.number,
                            validator: _formValidator,
                            maxLength: 3,
                          ),
                        ),
                        InkWell(
                            onTap: _formValidate,
                            child: const Chip(
                              label: Text('Update'),
                            ))
                      ],
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
      FocusScope.of(_formKey.currentContext).unfocus();
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
