import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:make_sleep_better/src/obj/data.dart';
import 'package:make_sleep_better/src/pages/delay_animation.dart';
import 'package:make_sleep_better/src/supports/dates.dart';
import 'package:make_sleep_better/src/supports/file_store.dart';
import 'package:make_sleep_better/src/supports/sizes.dart';
import 'package:shimmer/shimmer.dart';

class DataForHour {
  int unsatisfied = 0, normal = 0, satisfied = 0;

  int get sum => unsatisfied + normal + satisfied;

  double get level {
    if (sum == 0) {
      return 0;
    }
    return (unsatisfied * -1 + normal * 0 + satisfied * 1) / sum;
  }

  double get unpt {
    if (sum == 0) {
      return 0;
    }
    return unsatisfied / sum;
  }

  double get nopt {
    if (sum == 0) {
      return 0;
    }
    return normal / sum;
  }

  double get sapt {
    if (sum == 0) {
      return 0;
    }
    return satisfied / sum;
  }

  @override
  String toString() {
    return '$unsatisfied;$normal;$satisfied;$level';
  }
}

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
  final Map<int, DataForHour> _dataByHour = {};
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

  @override
  void initState() {
    super.initState();
    _dateSupport = DateSupport();
    _fileStore = const FileStore();
    for (int i = 0; i < 24; i++) {
      _dataByHour[i] = DataForHour();
    }
    _listDataWakeUpFuture = _getListWakeUp();
  }

  Future<List<Data>> _getListWakeUp() async {
    final String readFromFile = await _fileStore.readData();
    final listDataFromFile = jsonDecode(readFromFile) as List;
    _listDataWakeUp = listDataFromFile.map((e) => Data.fromMap(e)).toList()
      ..removeWhere((element) => element.feedback == false);
    _total = _listDataWakeUp.length;

    for (final data in _listDataWakeUp) {
      if (data.level == 1) {
        _unsatisfied++;
        _dataByHour[data.timeWakeUp.hour].unsatisfied++;
      }
      if (data.level == 2) {
        _normal++;
        _dataByHour[data.timeWakeUp.hour].normal++;
      }
      if (data.level == 3) {
        _satisfied++;
        _dataByHour[data.timeWakeUp.hour].satisfied++;
      }
    }
    for (int i = 0; i < 24; i++) {
      print('$i = ${_dataByHour[i]}');
    }
    return _listDataWakeUp ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildStatisticCounter(),
        _buildStatisticByTime(),
      ],
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
            style: TextStyle(fontSize: 20),
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
                  child: Text(
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
    List<Data> _listData = List.from(_listDataWakeUp);
    if (index != 0) {
      _listData.removeWhere((data) => data.level != index);
    }
    print('length is ${_listData.length}');
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              _titleCounter[index],
              style: TextStyle(color: _colorCounter[index], fontSize: 36),
            ),
            content: Container(
              height: 300,
              child: ListView.builder(
                  itemCount: _listData.length,
                  itemBuilder: (context, id) {
                    final data = _listData[id];
                    return Material(
                      color: Colors.transparent,
                      child: ListTile(
                        title: Text(
                            _dateSupport.formatHHmmWithDay(data.timeWakeUp)),
                        subtitle: Text(_dateSupport.formatDMY(data.timeWakeUp)),
                        trailing: _getTrailingStatistic(index, data.level),
                      ),
                    );
                  }),
            ),
          );
        });
  }

  Widget _getTrailingStatistic(int index, int level) {
    if (index == 0) {
      return Text(
        _titleCounter[level],
        style: TextStyle(
          color: _colorCounter[level],
        ),
      );
    } else {
      return null;
    }
  }

  Widget _buildStatisticByTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Statistic by time',
            style: TextStyle(fontSize: 20),
          ),
        ),
        _buildListStatisticByTime()
      ],
    );
  }

  Widget _buildListStatisticByTime() {
    final double height = Sizes.getHeightNoAppbar(context) * 0.4;
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
          return DelayedAnimation(
            delay: 300,
            child: Container(
              height: height,
              child: Row(
                children: <Widget>[
                  _tileLeftChart(),
                  Expanded(child: _listChart()),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _tileLeftChart() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            width: 20,
            decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                    colors: [Colors.blue, Colors.grey, Colors.red],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
          ),
        ),
        const Text('Hour')
      ],
    );
  }

  Widget _listChart() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 24,
        itemBuilder: (context, index) {
          final DataForHour data = _dataByHour[index];
          return Padding(
            padding: index == 23
                ? const EdgeInsets.only(left: 16, right: 16)
                : const EdgeInsets.only(left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: LayoutBuilder(builder: (context, constrains) {
                    final _height = constrains.maxHeight / 2;
                    return _typeLineChart(_height, data);
                  }),
                ),
                Text((index).toString())
              ],
            ),
          );
        });
  }

  Widget _typeLineChart(double height, DataForHour data) {
    if (data.level > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Flexible(flex: 1, child: LineChart(height * data.level.abs(), data)),
          Flexible(
              flex: 1,
              child: SizedBox(
                height: height,
              )),
        ],
      );
    } else if (data.level < 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
              flex: 1,
              child: SizedBox(
                height: height,
              )),
          Flexible(flex: 1, child: LineChart(height * data.level.abs(), data)),
        ],
      );
    } else {
      return Container(
          alignment: Alignment.center, child: Text(data.sum.toString()));
    }
  }
}

class TileCounter extends StatelessWidget {
  const TileCounter(this.color, this.number, this.name, this.showDialog);

  final Color color;
  final int number;
  final String name;
  final VoidCallback showDialog;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: InkWell(
            onTap: showDialog,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  number.toString(),
                  style: TextStyle(fontSize: 36, color: color),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(name),
                ),
              ],
            ),
          ),
        ));
  }
}

class LineChart extends StatelessWidget {
  const LineChart(this.maxHeight, this.data);

  final double maxHeight;
  final DataForHour data;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: maxHeight,
        child: Column(children: _getLine()),
      ),
    );
  }

  List<Widget> _getLine() {
    if (data.level < 0) {
      return [
        Container(
          height: data.sapt * maxHeight,
          width: 10,
          color: Colors.blue,
        ),
        Container(
          height: data.nopt * maxHeight,
          width: 10,
          color: Colors.grey,
        ),
        Container(
          height: data.unpt * maxHeight,
          width: 10,
          color: Colors.red,
        ),
      ];
    } else if (data.level > 0) {
      return [
        Container(
          height: data.unpt * maxHeight,
          width: 10,
          color: Colors.red,
        ),
        Container(
          height: data.nopt * maxHeight,
          width: 10,
          color: Colors.grey,
        ),
        Container(
          height: data.sapt * maxHeight,
          width: 10,
          color: Colors.blue,
        ),
      ];
    }
  }
}
