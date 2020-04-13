import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:make_sleep_better/src/obj/data_for_hour.dart';
import 'package:make_sleep_better/src/pages/statistic_detail.dart';
import 'package:make_sleep_better/src/widgets/line_chart.dart';
import 'package:make_sleep_better/src/widgets/list_statistic_dialog_content.dart';
import 'package:make_sleep_better/src/widgets/statistic_by_time.dart';
import 'package:make_sleep_better/src/widgets/tile_counter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:code_faster/code_faster.dart' hide DateSupport;

import '../obj/data.dart';
import 'delay_animation.dart';
import '../supports/dates.dart';
import '../supports/file_store.dart';
import '../supports/logs.dart';
import '../supports/sizes.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage();

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  DateSupport _dateSupport;
  FileStore _fileStore;
  Future<List<Data>> _listDataWakeUpFuture;
  List<Data> _listDataWakeUp;
  int _total, _unsatisfied = 0, _normal = 0, _satisfied = 0;
  final List<String> _titleCounter = [
    'Total',
    'Unsatisfied',
    'Normal',
    'Satisfied'
  ];
  final List<Color> _colorCounter = [
    Colors.green,
    Colors.red,
    Colors.grey,
    Colors.blue
  ];
  final List<IconData> _iconLevel = [
    null,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_satisfied
  ];

  @override
  void initState() {
    super.initState();
    _dateSupport = DateSupport();
    _fileStore = const FileStore();
    _listDataWakeUpFuture = _getListWakeUp();
  }

  Future<List<Data>> _getListWakeUp() async {
    final listDataFromFile = await _fileStore.readDataToList();
    _listDataWakeUp = listDataFromFile
      ..removeWhere((element) => element.feedback == false);
    _total = _listDataWakeUp.length;

    for (final data in _listDataWakeUp) {
      if (data.level == 1) {
        _unsatisfied++;
      }
      if (data.level == 2) {
        _normal++;
      }
      if (data.level == 3) {
        _satisfied++;
      }
    }
    return _listDataWakeUp ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildStatisticCounter(),
          _buildStatisticByTimeSleep(),
        ],
      ),
    );
  }

  Widget _buildStatisticCounter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Statistic counter',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        FutureBuilder(
          future: _listDataWakeUpFuture,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return SizedBox(
                child: Shimmer.fromColors(
                  baseColor: Colors.red,
                  highlightColor: Colors.yellow,
                  child: const Text(
                    'Loading from data...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            } else {
              return DelayedAnimation(
                delay: 250,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TileCounter(
                            Colors.green, _total, _titleCounter[0], () {
                      _showListStatistic(0);
                    })),
                    Expanded(
                        child: TileCounter(
                            Colors.red, _unsatisfied, _titleCounter[1], () {
                      _showListStatistic(1);
                    })),
                    Expanded(
                        child: TileCounter(
                            Colors.grey, _normal, _titleCounter[2], () {
                      _showListStatistic(2);
                    })),
                    Expanded(
                        child: TileCounter(
                            Colors.blue, _satisfied, _titleCounter[3], () {
                      _showListStatistic(3);
                    })),
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }

  void _showListStatistic(int index) {
    final List<Data> _listData = List.from(_listDataWakeUp);
    if (index != 0) {
      _listData.removeWhere((data) => data.level != index);
    }
    logs('length is ${_listData.length}');
    showDialog(
        context: context,
        builder: (context) {
          return ListStatisticDialogContent(
              _titleCounter[index],
              _colorCounter[index],
              _listData,
              _dateSupport.formatWithDayDMY,
              (level) => _getTrailingStatistic(index, level));
        });
  }

  Widget _getTrailingStatistic(int index, int level) {
    if (index == 0) {
      return Icon(
        _iconLevel[level],
        color: _colorCounter[level],
      );
    } else {
      return null;
    }
  }

  Widget _buildStatisticByTimeSleep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Statistics by bedtime.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        _buildStatisticByTime()
      ],
    );
  }

  Widget _buildStatisticByTime() {
    final double height = context.getH(30);
    return FutureBuilder(
      future: _listDataWakeUpFuture,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Shimmer.fromColors(
              baseColor: Colors.red,
              highlightColor: Colors.yellow,
              child: const Center(
                child: Text('Loading data ...'),
              ));
        } else {
          return StatisticByTime(
              type: 0, height: height, listData: snapshot.data);
        }
      },
    );
  }
}
